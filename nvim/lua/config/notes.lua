local M = {}

local defaults = {
  dir = '~/.config/nvim/notes',
}

local config = {
  dir = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(defaults.dir), ':p')),
}

local group = vim.api.nvim_create_augroup('notes', { clear = true })

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'notes' })
end

local function normalize_title(text)
  if not text then
    return ''
  end

  local title = vim.trim(text)
  title = title:gsub('^#+', '')

  return vim.trim(title)
end

local function validate_title(title)
  if title == '' then
    return nil, 'Note title cannot be empty'
  end

  if title:find('/', 1, true) then
    return nil, 'Note titles cannot contain /'
  end

  if title:find('\0', 1, true) then
    return nil, 'Note titles cannot contain NUL bytes'
  end

  return title
end

local function note_path(title)
  return vim.fs.normalize(vim.fs.joinpath(config.dir, title .. '.md'))
end

local function is_note_path(path)
  if path == '' then
    return false
  end

  local normalized = vim.fs.normalize(path)
  return vim.fs.dirname(normalized) == config.dir and vim.fs.basename(normalized):sub(-3) == '.md'
end

local function current_title(bufnr)
  local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
  return normalize_title(first_line)
end

local function ensure_notes_dir()
  if vim.uv.fs_stat(config.dir) then
    return true
  end

  vim.fn.mkdir(config.dir, 'p')

  if vim.uv.fs_stat(config.dir) then
    return true
  end

  notify('Failed to create notes directory: ' .. config.dir, vim.log.levels.ERROR)
  return false
end

local function list_note_titles(arg_lead)
  if not ensure_notes_dir() then
    return {}
  end

  local titles = {}
  local prefix = arg_lead or ''

  for name, file_type in vim.fs.dir(config.dir) do
    if file_type == 'file' and name:sub(-3) == '.md' then
      local title = name:sub(1, -4)
      if prefix == '' or title:sub(1, #prefix) == prefix then
        titles[#titles + 1] = title
      end
    end
  end

  table.sort(titles)
  return titles
end

local function delete_conflicting_buffer(path, current_bufnr)
  local bufnr = vim.fn.bufnr(path)
  if bufnr == -1 or bufnr == current_bufnr then
    return true
  end

  if vim.bo[bufnr].modified then
    local msg = 'Cannot rename note, modified buffer already exists: ' .. path
    notify(msg, vim.log.levels.ERROR)
    return false, msg
  end

  local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  if not ok then
    local msg = 'Cannot rename note, failed to remove old buffer: ' .. tostring(err)
    notify(msg, vim.log.levels.ERROR)
    return false, msg
  end

  return true
end

local function open_note(raw_title)
  local title, err = validate_title(normalize_title(raw_title))
  if not title then
    notify(err, vim.log.levels.ERROR)
    return
  end

  if not ensure_notes_dir() then
    return
  end

  local path = note_path(title)
  local exists = vim.uv.fs_stat(path) ~= nil

  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.bo[0].filetype = 'markdown'
  vim.b.notes_managed = true

  if exists then
    return
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    '# ' .. title,
    '',
  })
end

local function rename_note(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if not is_note_path(path) then
    return
  end

  local title, err = validate_title(current_title(bufnr))
  if not title then
    notify(err, vim.log.levels.ERROR)
    error(err)
  end

  local current_path = vim.fs.normalize(path)
  local target_path = note_path(title)
  if current_path == target_path then
    return
  end

  if vim.uv.fs_stat(target_path) then
    local msg = 'Cannot rename note, file already exists: ' .. target_path
    notify(msg, vim.log.levels.ERROR)
    error(msg)
  end

  local ok, conflict_err = delete_conflicting_buffer(target_path, bufnr)
  if not ok then
    error(conflict_err)
  end

  if vim.uv.fs_stat(current_path) then
    local renamed, rename_err = vim.uv.fs_rename(current_path, target_path)
    if not renamed then
      local msg = 'Failed to rename note: ' .. tostring(rename_err)
      notify(msg, vim.log.levels.ERROR)
      error(msg)
    end
  end

  local ok_set_name, set_name_err = pcall(vim.api.nvim_buf_set_name, bufnr, target_path)
  if not ok_set_name then
    local msg = 'Failed to update note buffer name: ' .. tostring(set_name_err)
    notify(msg, vim.log.levels.ERROR)
    error(msg)
  end

  delete_conflicting_buffer(current_path, bufnr)
end

function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_extend('force', config, opts)
  config.dir = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(config.dir), ':p'))

  vim.api.nvim_create_user_command('Note', function(args)
    open_note(args.args)
  end, {
    desc = 'Open or create a note',
    force = true,
    nargs = '+',
    complete = function(arg_lead)
      return list_note_titles(arg_lead)
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    callback = function(args)
      rename_note(args.buf)
    end,
    desc = 'Rename note file when title changes',
  })
end

return M
