" Miscellaneous options
" -------------------------------------------------------------- {{{
set viewoptions=cursor
set gdefault
nnoremap <C-s> :Gstatus<CR>
nnoremap <silent><Leader><CR> :nohl<CR>
nnoremap <Leader>c \\
nnoremap <Leader>l :silent! redraw!<CR>
" Make Q more useful
nnoremap Q q:
" -------------------------------------------------------------- }}}
" Use ag for Ack/grep
" -------------------------------------------------------------- {{{
" let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ackprg = 'ag -s'
let g:ack_wildignore = 0

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
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
" Python syntax settings
" -------------------------------------------------------------- {{{
" let g:python_highlight_exceptions = 1
" let g:python_highlight_builtin_funcs = 1
" let g:python_highlight_string_format = 1
" let g:python_highlight_string_formatting = 1
" let g:python_highlight_builtin_objs = 1
" -------------------------------------------------------------- }}}
" NVim settings
" -------------------------------------------------------------- {{{
if has('nvim')
    tmap <Esc> <C-\><C-n>
    tmap <C-\><C-m> <C-\><C-n>
    nnoremap <leader>t :vsp term:///home/jurica/.scripts/nvim-work-term.sh<CR>
endif
