" File: .vimrc
" Author: Jurica Bradarić
" Description: My .vimrc file
"===================================================================================
" GENERAL SETTINGS
"===================================================================================
"-------------------------------------------------------------------------"{{{
" Colors and other UI options
"-------------------------------------------------------------------------"}}}
if has('termguicolors')  " Turn on true colors
  if has('nvim') || !(&term =~# '^tmux')
    set termguicolors
    if &term =~# '^screen'
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
  endif
endif
if has('gui_running') || (has('termguicolors') && &termguicolors)
  colorscheme wombat
else
  colorscheme desert256
endif
if has('gui_running')
  set guifont=Consolas\ 11
  set guioptions=ac
  set lines=999
endif
set previewheight=20 " Height of the preview window

"-------------------------------------------------------------------------"}}}
" Remap <Leader> to ,
"-------------------------------------------------------------------------"{{{
let mapleader = ','
"-------------------------------------------------------------------------"}}}
" Set up VimPlug
"-------------------------------------------------------------------------"{{{
call plug#begin(stdpath('cache') . '/plugins')

" Appearance
Plug 'feline-nvim/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'SmiteshP/nvim-gps'

" Text objects
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-underscore'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" Motions
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-easyoperator-line'
Plug 'terryma/vim-expand-region'

" Search
Plug 'haya14busa/incsearch.vim'
Plug 'mg979/vim-visual-multi'
Plug 'jbradaric/vim-interestingwords'

" Tim Pope's plugins
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
let g:surround_no_insert_mappings = 1
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'

let g:sleuth_automatic = 0
Plug 'tpope/vim-sleuth', { 'on': ['Sleuth'] }

" Filetype specific
Plug 'avakhov/vim-yaml', { 'for': ['yaml'] }
Plug 'cespare/vim-toml', { 'for': ['toml'] }

" Git
Plug 'junegunn/gv.vim', { 'on': ['GV'] }
Plug 'nvim-lua/plenary.nvim'
Plug 'TimUntersberger/neogit'

" Fuzzy search
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Misc
Plug 'chrisbra/NrrwRgn', { 'on': ['NRV'] }
Plug 'mtth/scratch.vim'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes', { 'on': ['Note', 'NoteFromSelectedText'] }

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 1
let g:gutentags_file_list_command = 'fd'

Plug 'jaxbot/semantic-highlight.vim', { 'on': ['SemanticHighlight', 'SemanticHighlightToggle', 'SemanticHighlightRevert'] }

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
let g:vsnip_extra_mapping = v:false
let g:vsnip_snippet_dir = expand('~/.config/nvim/global-snippets')

Plug 'liuchengxu/vista.vim'

Plug 'onsails/lspkind-nvim'
Plug 'neovim/nvim-lspconfig'

sign define DiagnosticSignError text=✖ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text=⚠ texthl=DiagnosticSignWarn linehl= numhl=

set completeopt=menuone,noselect

if exists('&pumblend')
  set pumblend=5
endif

Plug 'justinmk/vim-dirvish'

Plug 'jbradaric/rooter.nvim'

Plug 'tyru/open-browser.vim'
let g:openbrowser_browser_commands = [
    \ {'name': '/usr/bin/firefox',
    \ 'args': ['{browser}', '-P', 'work', '--new-tab', '{uri}']}
    \ ]
nmap gx <Plug>(openbrowser-smart-search)

" Get selected text in visual mode.
function! s:_get_last_selected()
    let save_z = getreg('z', 1)
    let save_z_type = getregtype('z')

    try
        normal! gv"zy
        return @z
    finally
        call setreg('z', save_z, save_z_type)
    endtry
endfunction

function! s:_get_selected_text() abort
  let selected_text = s:_get_last_selected()
  let text = substitute(selected_text, '[\n\r]\+', '', 'g')
  return substitute(text, '^\s*\|\s*$', '', 'g')
endfunction

function! s:open_selected_url()
  let text = s:_get_selected_text()
  call openbrowser#open(text)
endfunction

vmap gx :<c-u>call <sid>open_selected_url()<cr>

Plug 'gabrielelana/vim-markdown'

Plug 'jbradaric/nvim-miniyank'

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

Plug 'martinsione/darkplus.nvim'

Plug 'AckslD/nvim-trevJ.lua'

Plug 'pianocomposer321/yabs.nvim'

call plug#end()

lua require('config.telescope').setup()

colorscheme darkplus
lua << EOF
local darkplus_colors = require 'darkplus.colors'
local function highlight(group, properties)
  local bg = properties.bg == nil and '' or 'guibg=' .. properties.bg
  local fg = properties.fg == nil and '' or 'guifg=' .. properties.fg
  local style = properties.style == nil and '' or 'gui=' .. properties.style
  local cmd = table.concat({ 'highlight', group, bg, fg, style }, ' ')
  vim.api.nvim_command(cmd)
end
highlight('TSComment', { fg = darkplus_colors.gray, style = 'italic' })
highlight('VertSplit', { fg = '#444444', bg = '#444444' })
highlight('TSString', { fg = '#6bab37' })
highlight('Normal', { fg = '#f6f3e8', bg = '#1e1e1e' })
highlight('NormalNC', { bg = '#212121' })
EOF

set completeopt=menu,menuone,noselect
lua require('config/nvim_cmp').setup_nvim_cmp()

"-------------------------------------------------------------------------"}}}
" Enable file type detection. Use the default filetype settings.
" Also load indent files, to automatically do language-dependent indenting.
"-------------------------------------------------------------------------"{{{
filetype plugin indent on
"-------------------------------------------------------------------------"}}}
" Various settings
"-------------------------------------------------------------------------"{{{
syntax on                        " Switch syntax highlighting on
set autoindent                   " copy indent from current line
set autoread                     " read open files again when changed outside Vim
set backspace=indent,eol,start   " backspacing over everything in insert mode
set nobackup                     " don't keep backup files
set noswapfile                   " don't create swap files
set nomodeline                   " don't use modelines
set undofile                     " use persistent undo
set hidden
set browsedir=current            " which directory to use for the file browser
set noautochdir                  " do not automatically cd into the directory that the file is in
set complete+=k                  " scan the files given with the 'dictionary' option
set history=1000                 " keep 1000 lines of command line history
set undolevels=1000              " lots and lots of undo
set showbreak=↪                  " indicate wrapped lines
set listchars=tab:→\ ,trail:•    " strings to use in 'list' mode
set mouse=a                      " enable the use of the mouse
set nowrap                       " do not wrap lines
set popt=left:8pc,right:3pc      " print options
set ruler                        " show the cursor position all the time
set shiftwidth=4                 " number of spaces to use for each step of indent
set showcmd                      " display incomplete commands
set softtabstop=4                " make vim see 4 spaces as tab
set expandtab                    " insert spaces for tabs
set formatoptions+=j             " delete comment character when joining commented lines
set wildignore+=*.bak,*.o,*.e,*~ " wildmenu: ignore these extensions
set wildignore+=*.class,*.pyc
" Show command mode completions in a floating window
set wildmode=full
set wildoptions=pum
set wildmenu                     " command-line completion in an enhanced mode
set number                       " turn the line numbers on
set ve=block                     " set virtualedit mode to block
set splitright                   " split new vertical windows to the right of the current window
set splitbelow                   " split new horizontal windows below the current window
set encoding=utf-8               " set the default encoding to UTF-8
set scrolloff=3                  " always show at least 3 lines after the current one
set ttyfast
set completeopt-=preview
set lazyredraw                   " speed up on large files
set updatetime=750               " trigger CursorHold sooner, 4 seconds is too long
"-------------------------------------------------------------------------"}}}
" Search settings
"-------------------------------------------------------------------------"{{{
set incsearch                    " do incremental searching
set ignorecase                   " use case-insensitive search...
set smartcase                    " ... unless there are upper-case characters
set hlsearch                     " highlight all occurences of a word
"-------------------------------------------------------------------------"}}}
" Fix slow O inserts
"-------------------------------------------------------------------------"{{{
set timeout
set timeoutlen=1000
set ttimeoutlen=0
"-------------------------------------------------------------------------"}}}
" Folding options
"-------------------------------------------------------------------------"{{{
set nofoldenable " Turn off folding because I never use it
" set foldmethod=indent
" set foldlevel=99
" set foldnestmax=2
" nnoremap <Space> za
"-------------------------------------------------------------------------"}}}
" <export to html> settings
"-------------------------------------------------------------------------"{{{
let html_use_css        = 1     " Use stylesheet instead of inline style
let html_number_lines   = 0     " Don't show line numbers
let html_no_pre         = 1     " Don't wrap lines in <pre>
"-------------------------------------------------------------------------"}}}
" Plugin configurations
"-------------------------------------------------------------------------"{{{
" runtime! macros/matchit.vim

" Global configuration
for fpath in split(globpath('~/.config/nvim/config', '*.vim'), '\n')
    exe 'source' fpath
endfor

" Machine-specific configuration
for fpath in split(globpath('~/.config/nvim/local-config', '*.vim'), '\n')
    exe 'source' fpath
endfor
"-------------------------------------------------------------------------"}}}
