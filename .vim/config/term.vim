if !has('nvim')
  finish
endif


" Useful terminal mode mappings
tnoremap <C-]> <C-\><C-n><C-w>q
tnoremap <C-^> <C-\><C-n><C-^>

" Exit terminal mode and go to the last cursor position
tnoremap <C-\><C-\> <C-\><C-n>

" Also redraw neovim when clearing the terminal
tnoremap <C-l> <C-l><C-\><C-n><C-l>i

" Make Alt+. work again
tnoremap ® .

" Paste selection into terminal using the Insert key
tnoremap <Insert> <C-\><C-n>"*pi

" Stay in insert mode after pasting with middle click
tnoremap <MiddleMouse> <C-\><C-n>"*pa
tnoremap <MiddleRelease> <Nop>
tnoremap <M-MiddleDrag> <Nop>

function! s:close_term()
  call feedkeys('i<cr>')
endfunction

function! s:setup_term_mappings(bufnum)
  if bufname(a:bufnum) =~ 'nvim-work-term.sh$'
    return
  endif
  nnoremap <buffer> <silent> q :<c-u>call <sid>close_term()<cr>
endfunction

augroup terminal_mappings
  autocmd!
  autocmd BufEnter term://* nnoremap <buffer> <C-]> <C-W>q
  autocmd TermOpen * call s:setup_term_mappings(0+expand('<abuf>'))
  autocmd TermOpen * call s:set_term_settings(0+expand('<abuf>'))
augroup END

function! s:fix_autoread()
  if filereadable(expand('%:p'))
    silent! checktime
  endif
  " try
  "   silent! execute 'checktime'
  " catch /E211/
  " endtry
  " silent! execute 'lcd ' . expand('%:p:h')
endfunction

function! s:quit_nvr()
  write
  for client in get(b:, 'nvr', [])
    call rpcnotify(client, 'Exit', 0)
  endfor
  bdelete
  if &buftype ==# 'terminal'
    startinsert
  endif
endfunction

command! Wq call s:quit_nvr()

augroup make_autoread_work
  autocmd!
  autocmd BufEnter * call s:fix_autoread()
  " autocmd BufEnter * silent! lcd %:p:h
augroup END

" Reuse the same terminal buffer for tmux
" -------------------------------------------------------------- {{{
let g:work_term = {}
let g:work_term.last_id = -1

function s:set_term_settings(bufnum)
  silent! setlocal bufhidden=hide
  silent! setlocal nonumber
  silent! setlocal signcolumn=no
endfunction

function! g:work_term.new()
  silent! execute 'edit term://' . $HOME . '/.scripts/nvim-work-term.sh'
  let self.last_id = bufnr('')
endfunction

function! g:work_term.open()
  silent! execute 'buffer ' . self.last_id
endfunction

function! g:work_term.run(same_buffer)
  if a:same_buffer == 0
    vnew
  endif

  if !bufexists(self.last_id)
    call self.new()
  else
    call self.open()
  endif

  normal i
endfunction

nnoremap \t :call g:work_term.run(0)<CR>
nnoremap \T :call g:work_term.run(1)<CR>
" -------------------------------------------------------------- }}}
