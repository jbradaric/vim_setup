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
" Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'cespare/vim-toml', { 'for': ['toml'] }
" Plug 'sheerun/vim-polyglot'
" let g:polyglot_disabled = ['javascript']

" Git
Plug 'junegunn/gv.vim', { 'on': ['GV'] }
Plug 'jreybert/vimagit', { 'branch': 'next' }

" Misc
Plug 'chrisbra/NrrwRgn', { 'on': ['NRV'] }
Plug 'mtth/scratch.vim'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
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
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  let g:vsnip_extra_mapping = v:false
  let g:vsnip_snippet_dir = expand('~/.config/nvim/global-snippets')

  Plug 'liuchengxu/vista.vim'

  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " inoremap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  " set completeopt=menu,menuone,noselect
  " set shortmess+=c
  " let g:completion_enable_snippet = 'vim-vsnip'
  " let g:completion_enable_auto_hover = 0
  " " let g:completion_confirm_key = ''

  Plug 'onsails/lspkind-nvim'
  Plug 'neovim/nvim-lspconfig'

  sign define LspDiagnosticsSignError text=✖ texthl=LspDiagnosticsErrorSign linehl= numhl=
  sign define LspDiagnosticsSignWarning text=⚠ texthl=LspDiagnosticsWarningSign linehl= numhl=

  set completeopt=menuone,noselect
  Plug 'hrsh7th/nvim-compe'

  let g:compe = {}
  let g:compe.enabled = v:true
  let g:compe.autocomplete = v:true
  let g:compe.debug = v:false
  let g:compe.min_length = 1
  let g:compe.preselect = 'enable'
  let g:compe.throttle_time = 80
  let g:compe.source_timeout = 200
  let g:compe.incomplete_delay = 400
  let g:compe.max_abbr_width = 100
  let g:compe.max_kind_width = 100
  let g:compe.max_menu_width = 100
  let g:compe.documentation = v:true

  let g:compe.source = {}
  let g:compe.source.path = v:false
  let g:compe.source.buffer = v:false
  let g:compe.source.calc = v:false
  let g:compe.source.vsnip = v:true
  let g:compe.source.nvim_lsp = v:true
  let g:compe.source.nvim_lua = v:false
  let g:compe.source.spell = v:false
  let g:compe.source.tags = v:false
  let g:compe.source.snippets_nvim = v:false
  let g:compe.source.treesitter = v:false
  let g:compe.source.omni = v:false

  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

  lua <<EOF
  local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF

  " Plug 'nvim-lua/popup.nvim'
  " Plug 'nvim-lua/plenary.nvim'
  " Plug 'nvim-lua/telescope.nvim'

  if exists('&pumblend')
    set pumblend=5
  endif
endif

Plug 'justinmk/vim-dirvish'

Plug 'airblade/vim-rooter'

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

Plug 'dhruvasagar/vim-table-mode'

Plug 'gabrielelana/vim-markdown'

if has('nvim')
  Plug 'jbradaric/nvim-miniyank'
endif

if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif

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
