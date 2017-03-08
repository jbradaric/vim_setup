" Miscellaneous options
" -------------------------------------------------------------- {{{
set viewoptions=cursor
set gdefault
nnoremap <C-s> :Gstatus<CR>
" Make Q more useful
nnoremap Q q:

" Show the effects of a command incrementally, while typing.
if exists('&inccommand')
  set inccommand=nosplit
endif
" -------------------------------------------------------------- }}}
" Use ag for Ack/grep
" -------------------------------------------------------------- {{{
" let g:ackprg = 'ag -s --vimgrep'
let g:ack_wildignore = 0

nnoremap <Space>/ :<C-U>Rg<Space>

if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
else
  set grepprg=ag\ --vimgrep\ $*
endif
set grepformat=%f:%l:%c:%m
" -------------------------------------------------------------- }}}
" Quicker saving
" -------------------------------------------------------------- {{{
nnoremap <Leader>w :update<CR>
" -------------------------------------------------------------- }}}
" Search for the word under cursor
" -------------------------------------------------------------- {{{
nmap <Leader>a :Ag! <cword><CR>
" -------------------------------------------------------------- }}}
" Enter search term
" -------------------------------------------------------------- {{{
nmap <Leader>A :Ag!<Space>
" -------------------------------------------------------------- }}}
" Insert the word under cursor in the command line
cnoremap <C-w> <C-r><C-w>
" -------------------------------------------------------------- }}}
" Base64 encode/decode
" -------------------------------------------------------------- {{{
vnoremap <Leader>d64 c<C-R>=system('base64 --decode', @")<CR><ESC>
vnoremap <Leader>e64 c<C-R>=system('base64', @")<CR><ESC>
" -------------------------------------------------------------- }}}
" Always show the status line
" -------------------------------------------------------------- {{{
set laststatus=2
" -------------------------------------------------------------- }}}
" When a bracket is inserted, briefly jump to the matching one.
" -------------------------------------------------------------- {{{
set showmatch
set matchtime=2
" -------------------------------------------------------------- }}}
" Fast window moves
" -------------------------------------------------------------- {{{
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

if has('nvim')
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif
" -------------------------------------------------------------- }}}
" Remap <C-W><C-]> and <C-W>] to use vertical splits
" see :h CTRL-W_CTRL-]
" -------------------------------------------------------------- {{{
fun! VSplitTag() range
    vsplit
    exe "tag " . expand("<cword>")
endfun
nnoremap <C-W><C-]> :call VSplitTag()<CR>
nnoremap <C-W>] :call VSplitTag()<CR>

nnoremap <C-W>f :vsplit<CR>gf
nnoremap <leader>S :<C-U>Scratch<CR>

" Call :update when :w is typed
cnoreabbrev w update
" -------------------------------------------------------------- }}}
" Python syntax settings
" -------------------------------------------------------------- {{{
" let g:python_highlight_exceptions = 1
" let g:python_highlight_builtin_funcs = 1
" let g:python_highlight_string_format = 1
" let g:python_highlight_string_formatting = 1
" let g:python_highlight_builtin_objs = 1
