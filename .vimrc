" File: .vimrc
" Author: Jurica Bradarić
" Description: My .vimrc file
" Last Modified: 2013-11-01
"===================================================================================
" GENERAL SETTINGS
"===================================================================================
"
"-------------------------------------------------------------------------------
" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
"-------------------------------------------------------------------------"{{{
set nocompatible
"-------------------------------------------------------------------------"{{{
" Colors and other UI options
"-------------------------------------------------------------------------"}}}
set t_Co=256
if has("gui_running")
    colorscheme wombat
    set guifont=Consolas\ 11
    set guioptions=ac
    set lines=999
else
    colorscheme desert256
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
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'alfredodeza/khuno.vim', { 'for': ['python'] }
Plug 'vim-scripts/repeat.vim'
Plug 'vim-scripts/sort-python-imports'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'SirVer/ultisnips'
Plug 'PeterRincker/vim-argumentative'
Plug 'tpope/vim-commentary'
Plug 'Twinside/vim-cuteTodoList'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'xolox/vim-easytags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'michaeljsmith/vim-indent-object'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-underscore'
Plug 'kana/vim-textobj-user'
Plug 'avakhov/vim-yaml'
Plug 'chrisbra/NrrwRgn'
Plug 'chrisbra/NrrwRgn'
Plug 'Lokaltog/vim-easymotion'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'duff/vim-scratch'
Plug 'haya14busa/vim-easyoperator-line'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-dispatch'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'haya14busa/incsearch.vim'
Plug 'gorkunov/smartpairs.vim'
Plug 'tpope/vim-vinegar'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'terryma/vim-expand-region'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'hdima/python-syntax'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
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
set browsedir=current            " which directory to use for the file browser
set autochdir                    " automatically cd into the directory that the file is in
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
set wildignore+=*.keys,*.mo
set wildignore+=*.prefs,*.datapool
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
set ttimeoutlen=100
"-------------------------------------------------------------------------"}}}
" Folding options
"-------------------------------------------------------------------------"{{{
set foldmethod=indent
set foldlevel=99
set foldnestmax=2
nnoremap <Space> za
"-------------------------------------------------------------------------"}}}
" <export to html> settings
"-------------------------------------------------------------------------"{{{
let html_use_css        = 1     " Use stylesheet instead of inline style
let html_number_lines   = 0     " Don't show line numbers
let html_no_pre         = 1     " Don't wrap lines in <pre>
"-------------------------------------------------------------------------"}}}
" Plugin configurations
"-------------------------------------------------------------------------"{{{
runtime! macros/matchit.vim

" Global configuration
for fpath in split(globpath('~/.vim/config', '*.vim'), '\n')
    exe 'source' fpath
endfor

" Machine-specific configuration
for fpath in split(globpath('~/.vim/local-config', '*.vim'), '\n')
    exe 'source' fpath
endfor
"-------------------------------------------------------------------------"}}}
