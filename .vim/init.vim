" File: .vimrc
" Author: Jurica Bradarić
" Description: My .vimrc file
" Last Modified: 2017-03-20
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
call plug#begin('~/.vim/bundle')

" Plug 'raghur/vim-ghost'

" Appearance
Plug 'itchyny/lightline.vim'
if has('nvim')
  Plug 'junegunn/rainbow_parentheses.vim'
endif

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

if has('nvim')
  Plug 'w0rp/ale'
endif

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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'

let g:sleuth_automatic = 0
Plug 'tpope/vim-sleuth', { 'on': ['Sleuth'] }

" Filetype specific
Plug 'avakhov/vim-yaml', { 'for': ['yaml'] }
Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'cespare/vim-toml', { 'for': ['toml'] }
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['javascript']

" Git
Plug 'junegunn/gv.vim', { 'on': ['GV'] }
Plug 'jreybert/vimagit', { 'branch': 'next' }

" Misc
Plug 'chrisbra/NrrwRgn', { 'on': ['NRV'] }
Plug 'mtth/scratch.vim'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'majutsushi/tagbar', { 'on': ['TagbarToggle', 'TagbarOpenAutoClose'] }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'mhinz/vim-grepper'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'PeterRincker/vim-argumentative'
Plug 'vim-scripts/DoxygenToolkit.vim', { 'on': ['Dox', 'DoxUndoc'] }
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes', { 'on': ['Note', 'NoteFromSelectedText'] }

Plug 'ludovicchabant/vim-gutentags'

Plug 'jaxbot/semantic-highlight.vim', { 'on': ['SemanticHighlight', 'SemanticHighlightToggle', 'SemanticHighlightRevert'] }

if has('nvim')
  " the framework
  " Plug 'roxma/nvim-completion-manager'
  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'

  autocmd Bufenter * call ncm2#enable_for_buffer()
  set completeopt=noinsert,menuone,noselect

  " When the <Enter> key is pressed while the popup menu is visible, it only
  " hides the menu. Use this mapping to close the menu and also start a new
  " line.
  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

  " Use <TAB> to select the popup menu:
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  Plug 'ncm2/ncm2-ultisnips'
  Plug 'SirVer/ultisnips'

  " Press enter key to trigger snippet expansion
  " The parameters are the same as `:help feedkeys()`
  inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

  " c-j c-k for moving in snippet
  let g:UltiSnipsExpandTrigger          = "<Plug>(ultisnips_expand)"
  let g:UltiSnipsJumpForwardTrigger     = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger    = "<c-k>"
  let g:UltiSnipsRemoveSelectModeMappings = 0

  " imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>(expand_or_cr)" : "\<CR>")
  " imap <expr> <Plug>(expand_or_cr) (cm#completed_is_snippet() ? "\<F20>" : "\<CR>")

  " Use Tab to select completion items
  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Plug 'SirVer/ultisnips'
  " let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"

  " inoremap <silent> <F20> <C-R>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<CR>
  " let g:UltiSnipsJumpForwardTrigger = "<C-J>"
  " let g:UltiSnipsJumpBackwardTrigger = "<C-K>"

  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh'
      \ }

  let g:LanguageClient_serverCommands = {
      \ 'python': ['/home/jurica/.scripts/local_workenv.sh', '/home/jurica/.local/bin/pyls'],
      \ 'cpp': ['cquery'],
      \ 'c': ['cquery'],
      \ 'go': ['/home/jurica/go/bin/go-langserver'],
      \ }
  let g:LanguageClient_rootMarkers = ['.git']
  " let g:LanguageClient_loggingLevel = 'DEBUG'
  let g:LanguageClient_loadSettings = 1
  let g:LanguageClient_settingsPath = '/home/jurica/.config/nvim/lang_server_settings.json'
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_diagnosticsEnable = 0

  function! SetupPythonServer()
    if &ft !=# 'python'
      return
    endif
    let l:conf = readfile(g:LanguageClient_settingsPath)
    let l:settings = json_decode(l:conf)
    let l:method = 'workspace/didChangeConfiguration'
    let l:params = {'settings': l:settings}
    call LanguageClient#Write(json_encode({ 'jsonrpc': '2.0', 'method': l:method, 'params': l:params, }))
    echom 'server setup done'
  endfunction

  augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted call SetupPythonServer()
  augroup END

  " nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
  nnoremap <silent> gD :call LanguageClient_textDocument_typeDefinition()<CR>
  nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
  nnoremap <silent> <F3> :call LanguageClient_textDocument_references()<CR>

  if exists('&pumblend')
    set pumblend=5
  endif
endif

Plug 'justinmk/vim-dirvish'

Plug 'airblade/vim-rooter'

Plug 'tyru/open-browser.vim'
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

Plug 'dhruvasagar/vim-table-mode'

Plug 'gabrielelana/vim-markdown'

Plug 'jbradaric/nvim-miniyank'

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
set nomodeline                   " don't use modelines
if has('nvim')
    set undofile                 " use persistent undo
endif
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
if has('nvim')
  " Show command mode completions in a floating window
  set wildmode=full
  set wildoptions=pum
else
  " First tab press = complete as much as possible
  " Second tab = provide a list
  " Third and subsequent tab = cycle through completions
  set wildmode=longest,list,full
endif
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
if !has('nvim')
  set ttimeoutlen=0
endif
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
