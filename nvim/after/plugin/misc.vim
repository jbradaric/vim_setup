" Miscellaneous options
" -------------------------------------------------------------- {{{
set viewoptions=cursor
nnoremap <C-s> :Git<CR>

" Don't use Ex mode, use Q for formatting.
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Show the effects of a command incrementally, while typing.
if exists('&inccommand')
  set inccommand=nosplit
endif
" -------------------------------------------------------------- }}}
" Use rg
" -------------------------------------------------------------- {{{
" nnoremap <Space>/ :<C-U>Rooter<CR>:Rg<CR>

if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
endif
set grepformat=%f:%l:%c:%m
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
if !has('nvim')
  set laststatus=2
endif
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

inoremap <A-h> <Esc><C-w>h
inoremap <A-j> <Esc><C-w>j
inoremap <A-k> <Esc><C-w>k
inoremap <A-l> <Esc><C-w>l

if has('nvim')
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif
" -------------------------------------------------------------- }}}
" Make gj/gk behave like j/k
" -------------------------------------------------------------- {{{
nnoremap j gj
nnoremap k gk
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

cabbrev <expr> %% expand('%:p:h')

augroup go_to_last_cursor_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=150, on_visual=false}
