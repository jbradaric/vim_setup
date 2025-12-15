local link_highlight = require('config.utils').link_highlight

local M = {}

local function setup_highlights()
  link_highlight('TSFuncBuiltin', 'Function')
  link_highlight('TSConstBuiltin', 'MyConstant')
  link_highlight('TSBoolean', 'MyConstant')
  link_highlight('TSOperator', 'MyConstant')
  link_highlight('TSInclude', 'MyConditional')
  link_highlight('TSConditional', 'TSInclude')
  link_highlight('TSRepeat', 'TSInclude')
  link_highlight('TSParameter', 'FunctionParameter')
end

local function setup_utils()
  vim.cmd([[
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
  ]])
end

local highlight_fts = {
  'c',
  'css',
  'groovy',
  'html',
  'lua',
  'markdown',
  'markdown',
  'python',
  'typescript',
  'typescript',
  'yaml',
  'zsh',
}

local ensure_installed = {
  'bash',
  'c',
  'cpp',
  'css',
  'groovy',
  'helm',
  'html',
  'http',
  'javascript',
  'lua',
  'markdown',
  'markdown_inline',
  'nginx',
  'python',
  'query',
  'regex',
  'rust',
  'sql',
  'tsx',
  'typescript',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'zsh',
}

local indent_fts = {
  'python',
}

M.setup = function()
  require('nvim-treesitter').install(ensure_installed)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function()
      if vim.tbl_contains(highlight_fts, vim.bo.filetype) then
        vim.treesitter.start()
      end
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function()
      if vim.tbl_contains(indent_fts, vim.bo.filetype) then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  require('nvim-treesitter-textobjects').setup({})

  vim.keymap.set({ 'x', 'o' }, 'af', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'if', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'ac', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'ic', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
  end)
  -- You can also use captures from other query groups like `locals.scm`
  vim.keymap.set({ 'x', 'o' }, 'as', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
  end)

  vim.keymap.set('n', '<leader>a', function()
    require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
  end)
  vim.keymap.set('n', '<leader>A', function()
    require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
  end)

  setup_highlights()
  setup_utils()
end

return M
