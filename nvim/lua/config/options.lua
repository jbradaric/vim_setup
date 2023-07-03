local options = {
  backup = false,
  swapfile = false,
  modeline = false,
  undofile = true,
  autochdir = false,
  complete = { 'k' },
  showbreak = '↪',
  listchars = { 'tab:→ ', 'trail:•' },
  mouse = 'a',
  wrap = false,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
  wildignore = { '*.bak', '*.o', '*.e', '*~', '*.class', '*.pyc' },
  wildmode = 'full',
  wildoptions = 'pum',
  number = true,
  virtualedit = 'block',
  splitright = true,
  splitbelow = true,
  scrolloff = 3,
  updatetime = 750,
  splitkeep = 'cursor',
  ignorecase = true,
  smartcase = true,
  ttimeoutlen = 0,
  foldenable = false,
  pumblend = 5,
  previewheight = 20,
  shortmess = { 'c', 'C' },
}

for name, value in pairs(options) do
  if type(value) == 'table' then
    for _, v in ipairs(value) do
      vim.opt[name]:append(v)
    end
  else
    vim.opt[name] = value
  end
end
