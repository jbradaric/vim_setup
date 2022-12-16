" File: .vimrc
" Author: Jurica Bradarić
" Description: My .vimrc file
"===================================================================================
" GENERAL SETTINGS
"===================================================================================
"-------------------------------------------------------------------------"{{{
" Colors and other UI options
"-------------------------------------------------------------------------"}}}
" if has('termguicolors')  " Turn on true colors
"   if has('nvim') || !(&term =~# '^tmux')
"     set termguicolors
"     if &term =~# '^screen'
"       let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"       let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"     endif
"   endif
" endif
" if has('gui_running') || (has('termguicolors') && &termguicolors)
"   colorscheme wombat
" else
"   colorscheme desert256
" endif
" if has('gui_running')
"   set guifont=Consolas\ 11
"   set guioptions=ac
"   set lines=999
" endif
set previewheight=20 " Height of the preview window

lua vim.opt.guifont = 'UbuntuMono Nerd Font Mono:h12.5'
let g:neovide_cursor_animation = 0

"-------------------------------------------------------------------------"}}}
" Remap <Leader> to ,
"-------------------------------------------------------------------------"{{{
let mapleader = ','
"-------------------------------------------------------------------------"}}}
" Set up VimPlug
"-------------------------------------------------------------------------"{{{
call plug#begin(stdpath('cache') . '/plugins')

if isdirectory(expand('~/src/misc/nvim-work-config'))
  Plug '~/src/misc/nvim-work-config'
endif

" Appearance
Plug 'feline-nvim/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'SmiteshP/nvim-gps'
Plug 'stevearc/dressing.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'b0o/incline.nvim'
Plug 'sam4llis/nvim-tundra'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Text objects
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-underscore'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" Motions
Plug 'phaazon/hop.nvim'

Plug 'folke/paint.nvim'

" Search
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

if exists('&pumblend')
  set pumblend=5
endif

Plug 'justinmk/vim-dirvish'

Plug 'jbradaric/rooter.nvim'

Plug 'tyru/open-browser.vim'

Plug 'gabrielelana/vim-markdown'

Plug 'jbradaric/nvim-miniyank'

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

Plug 'martinsione/darkplus.nvim'
Plug 'tomasiser/vim-code-dark'
Plug 'Mofiqul/vscode.nvim'
Plug 'monsonjeremy/onedark.nvim'
Plug 'norcalli/nvim-colorizer.lua'

Plug 'AckslD/nvim-trevJ.lua'

Plug 'pianocomposer321/yabs.nvim'

Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'

Plug 'nvim-neorg/neorg'

Plug 'yioneko/nvim-yati'
Plug 'yioneko/vim-tmindent'

Plug 'luukvbaal/statuscol.nvim'

Plug 'MunifTanjim/nui.nvim'
Plug 'folke/noice.nvim'

call plug#end()

" Configure plugins
lua require('config').setup()

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
if !has('nvim')
  set popt=left:8pc,right:3pc    " print options
endif
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
set updatetime=750               " trigger CursorHold sooner, 4 seconds is too long
set splitkeep=cursor             " Keep the same relative cursor position.
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
