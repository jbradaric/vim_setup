if !has('nvim')
  finish
endif


" Useful terminal mode mappings
tnoremap <C-\><C-m> <C-\><C-n>
tnoremap <C-]> <C-\><C-n><C-w>q
tnoremap <C-^> <C-\><C-n><C-^>
tnoremap <Esc><Esc> <C-\><C-n>

" Also redraw neovim when clearing the terminal
tnoremap <C-l> <C-l><C-\><C-n><C-l>i

" Make Alt+. work again
tnoremap ® .

" Paste selection into terminal using the Insert key
tnoremap <Insert> <C-\><C-n>"*pi

augroup terminal_mappings
  autocmd!
  autocmd BufEnter term://* nnoremap <buffer> <C-]> <C-W>q
augroup END

augroup make_autoread_work
  autocmd!
  autocmd BufEnter * checktime
augroup END

" Reuse the same terminal buffer for tmux
" -------------------------------------------------------------- {{{
let g:work_term = {}
let g:work_term.last_id = -1

function! g:work_term.new()
  silent! execute 'edit term://' . $HOME . '/.scripts/nvim-work-term.sh'
  silent! setlocal bufhidden=hide
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

nnoremap <leader>t :call g:work_term.run(0)<CR>
nnoremap <leader>T :call g:work_term.run(1)<CR>
" -------------------------------------------------------------- }}}