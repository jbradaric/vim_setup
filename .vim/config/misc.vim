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

nnoremap <Space>/ :<C-U>Rooter<cr>:Rg<Space>

if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
else
  set grepprg=ag\ --vimgrep\ $*
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

" -------------------------------------------------------------- }}}
" Python syntax settings
" -------------------------------------------------------------- {{{
" let g:python_highlight_exceptions = 1
" let g:python_highlight_builtin_funcs = 1
" let g:python_highlight_string_format = 1
" let g:python_highlight_string_formatting = 1
" let g:python_highlight_builtin_objs = 1

function! s:accordion()
  if !get(w:, 'accordion', v:false)
    return
  endif
  wincmd _
endfunction

function! s:toggle_accordion()
  let curr_win = winnr()

  " to to the top-most window
  let nr = curr_win
  wincmd k
  while nr != winnr()
    let nr = winnr()
    wincmd k
  endwhile

  let new_val = get(w:, 'accordion', v:false) ? v:false : v:true
  let w:accordion = new_val
  let nr = winnr()
  wincmd j
  while nr != winnr()
    let w:accordion = new_val
    let nr = winnr()
    wincmd j
  endwhile

  let nr = winnr()
  while nr != curr_win
    wincmd k
    let nr = winnr()
  endwhile
  if w:accordion
    wincmd _
  else
    wincmd =
  endif
endfunction

nnoremap <silent> ]k :call <sid>toggle_accordion()<cr>

augroup horizontal_accordion
  autocmd!
  autocmd WinEnter * call s:accordion()
augroup END

function! HighlightGlobal()
  if &filetype == "" || &filetype == "text"
    syn match alphanumeric  "[A-Za-z0-9_]"
    " Copy from $VIM/syntax/lua.vim
    " integer number
    syn match txtNumber     "\<\d\+\>"
    " floating point number, with dot, optional exponent
    syn match txtNumber     "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
    " floating point number, starting with a dot, optional exponent
    syn match txtNumber     "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
    " floating point number, without dot, with exponent
    syn match txtNumber     "\<\d\+[eE][-+]\=\d\+\>"
    " Wide characters and non-ascii characters
    syn match nonalphabet   "[\u0021-\u002F]"
    syn match nonalphabet   "[\u003A-\u0040]"
    syn match nonalphabet   "[\u005B-\u0060]"
    syn match nonalphabet   "[\u007B-\u007E]"
    syn match nonalphabet   "[^\u0000-\u007F]"
    syn match lineURL       /\(https\?\|ftps\?\|git\|ssh\):\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
    hi def link alphanumeric  Normal
    hi def link txtNumber	    Define
    hi def link lineURL	      Number
    hi def link nonalphabet   Conditional
  endif
endfunction

function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
