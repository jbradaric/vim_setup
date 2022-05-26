function! GetBufferList()
  let buffer_list = ''
  redir =>> buffer_list
  ls
  redir END
  return buffer_list
endfunction

function! IsLocationList()
  if &ft != 'qf'
    return 0
  endif

  silent let buffer_list = GetBufferList()
  let l:quickfix_match = matchlist(buffer_list,
      \ '\n\s*\(\d\+\)[^\n]*Quickfix List')
  if empty(l:quickfix_match)
    return 1
  endif
  let quickfix_bufnr = l:quickfix_match[1]
  return quickfix_bufnr == bufnr('%') ? 0 : 1
endfunction

function! CloseListWindow()
  if IsLocationList()
    silent! execute 'lclose'
  else
    silent! execute 'cclose'
  endif
endfunction

nnoremap <silent><buffer> gq :<c-u>call CloseListWindow()<cr>
