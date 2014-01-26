" Miscellaneous options
" -------------------------------------------------------------- {{{
set viewoptions=cursor
nnoremap <C-s> :Gstatus<CR>
nnoremap <silent><Leader><CR> :nohl<CR>
nnoremap <Leader>c \\
" -------------------------------------------------------------- }}}
" Use ag instead of ack
" -------------------------------------------------------------- {{{
let g:ackprg = 'ag --nogroup --nocolor --column'
" -------------------------------------------------------------- }}}
" Quicker saving
" -------------------------------------------------------------- {{{
nnoremap <Leader>w :update<CR>
" -------------------------------------------------------------- }}}
" Search for the word under cursor
" -------------------------------------------------------------- {{{
nmap <Leader>a :LAck! <cword><CR> 
" -------------------------------------------------------------- }}}
" Enter search term
" -------------------------------------------------------------- {{{
nmap <Leader>A :LAck!<Space>
" -------------------------------------------------------------- }}}
" Insert the word under cursor in the command line
cnoremap <C-w> <C-r><C-w>
" -------------------------------------------------------------- }}}
" Base64 encode/decode
" -------------------------------------------------------------- {{{
vnoremap <Leader>d64 c<C-R>=system('base64 --decode', @")<CR><ESC>
vnoremap <Leader>e64 c<C-R>=system('base64 --encode', @")<CR><ESC>
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
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
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
" -------------------------------------------------------------- }}}