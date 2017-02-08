" File: .vimrc
" Author: Jurica Bradarić
" Description: My .vimrc file
" Last Modified: 2015-04-29
"===================================================================================
" GENERAL SETTINGS
"===================================================================================
"-------------------------------------------------------------------------"{{{
" Colors and other UI options
"-------------------------------------------------------------------------"}}}
if has('termguicolors')  " Turn on true colors
  set termguicolors
  if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
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
call plug#begin('~/.vim/bundle')

" Appearance
Plug 'itchyny/lightline.vim'
if has('nvim')
  Plug 'junegunn/rainbow_parentheses.vim'
endif

" Autocomplete
" Plug 'ervandew/supertab'

" CtrlP
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

if has('nvim')
  Plug 'neomake/neomake'
  Plug 'dojoteef/neomake-autolint'
endif

" Text objects
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-underscore'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" Motions
Plug 'haya14busa/vim-easyoperator-line'
Plug 'Lokaltog/vim-easymotion'
Plug 'terryma/vim-expand-region'

" Search
Plug 'haya14busa/incsearch.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'jbradaric/vim-interestingwords'

" Tim Pope's plugins
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'

" Filetype specific
Plug 'avakhov/vim-yaml', { 'for': ['yaml'] }
Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'cespare/vim-toml', { 'for': ['toml'] }
Plug 'sheerun/vim-polyglot', { 'do': './build' }
let g:polyglot_disabled = ['javascript']

" Git
Plug 'junegunn/gv.vim', { 'on': ['GV'] }
Plug 'idanarye/vim-merginal', { 'on': ['Merginal'] }
Plug 'jreybert/vimagit', { 'branch': 'next' }

" Misc
Plug 'chrisbra/NrrwRgn', { 'on': ['NRV'] }
Plug 'duff/vim-scratch', { 'on': ['Scratch'] }
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'majutsushi/tagbar', { 'on': ['TagbarToggle', 'TagbarOpenAutoClose'] }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'mhinz/vim-grepper'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'PeterRincker/vim-argumentative', { 'on': ['<Plug>Argumentative_MoveRight', '<Plug>Argumentative_MoveLeft'] }
Plug 'vim-scripts/DoxygenToolkit.vim', { 'on': ['Dox', 'DoxUndoc'] }
Plug 'vim-scripts/YankRing.vim'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes', { 'on': ['Note', 'NoteFromSelectedText'] }

Plug 'jaxbot/semantic-highlight.vim', { 'on': ['SemanticHighlight', 'SemanticHighlightToggle', 'SemanticHighlightRevert'] }

if has('nvim')
  " Plug 'unblevable/quick-scope'
  " Plug 'Valloric/YouCompleteMe'

  let g:deoplete#enable_at_startup = 1
  Plug 'Shougo/deoplete.nvim'
  Plug 'jbradaric/deoplete-jedi'
  " Plug 'zchee/deoplete-clang'
  Plug 'carlitux/deoplete-ternjs'
endif

Plug 'justinmk/vim-dirvish'

" Plug 'chrisbra/vim-diff-enhanced'
" if &diff
"     let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
" endif

" Plug 'AndrewRadev/linediff.vim'
" " Plug 'machakann/vim-highlightedyank'

Plug 'blindFS/vim-taskwarrior', { 'on': ['TW'] }

call plug#end()
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
if has('nvim')
    set undofile                 " use persistent undo
endif
set browsedir=current            " which directory to use for the file browser
set noautochdir                    " automatically cd into the directory that the file is in
set complete+=k                  " scan the files given with the 'dictionary' option
set history=1000                 " keep 1000 lines of command line history
set undolevels=1000              " lots and lots of undo
set listchars=tab:>.,trail:.     " strings to use in 'list' mode
set mouse=a                      " enable the use of the mouse
set nowrap                       " do not wrap lines
set popt=left:8pc,right:3pc      " print options
set ruler                        " show the cursor position all the time
set shiftwidth=4                 " number of spaces to use for each step of indent
set showcmd                      " display incomplete commands
set tabstop=4                    " number of spaces that a <Tab> counts for
set softtabstop=4                " make vim see 4 spaces as tab
set expandtab                    " insert spaces for tabs
set formatoptions+=j             " delete comment character when joining commented lines
set wildignore+=*.bak,*.o,*.e,*~ " wildmenu: ignore these extensions
set wildignore+=*.class,*.pyc
" First tab press = complete as much as possible
" Second tab = provide a list
" Third and subsequent tab = cycle through completions
set wildmode=longest,list,full
set wildmenu                     " command-line completion in an enhanced mode
set number                       " turn the line numbers on
set ve=block                     " set virtualedit mode to block
set splitright                   " split new vertical windows to the right of the current window
set encoding=utf-8               " set the default encoding to UTF-8
set scrolloff=3                  " always show at least 3 lines after the current one
set ttyfast
set completeopt-=preview
set lazyredraw                   " speed up on large files
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
for fpath in split(globpath('~/.vim/config', '*.vim'), '\n')
    exe 'source' fpath
endfor

" Machine-specific configuration
for fpath in split(globpath('~/.vim/local-config', '*.vim'), '\n')
    exe 'source' fpath
endfor
"-------------------------------------------------------------------------"}}}
