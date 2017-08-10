" Miscellaneous options
" -------------------------------------------------------------- {{{
set viewoptions=cursor
nnoremap <C-s> :Gstatus<CR>

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

" -------------------------------------------------------------- }}}
" Python syntax settings
" -------------------------------------------------------------- {{{
" let g:python_highlight_exceptions = 1
" let g:python_highlight_builtin_funcs = 1
" let g:python_highlight_string_format = 1
" let g:python_highlight_string_formatting = 1
" let g:python_highlight_builtin_objs = 1

function! s:accordion()
  if !get(w:, 'accordion', 0)
    return
  endif
  wincmd _
endfunction

function! s:toggle_accordion()
  if !get(w:, 'accordion', 0)
    let w:accordion = 1
    wincmd _
    return
  else
    let w:accordion = 0
    wincmd =
    return
  endif
endfunction

nnoremap <silent> ]k :call <sid>toggle_accordion()<cr>

augroup horizontal_accordion
  autocmd!
  autocmd WinEnter * call s:accordion()
augroup END
