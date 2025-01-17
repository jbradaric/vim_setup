if exists("g:loaded_unimpaired")
  finish
endif
let g:loaded_unimpaired = 1

function! s:putline(how, map) abort
  let [body, type] = [getreg(v:register), getregtype(v:register)]
  if type ==# 'V'
    exe 'normal! "'.v:register.a:how
  else
    call setreg(v:register, body, 'l')
    exe 'normal! "'.v:register.a:how
    call setreg(v:register, body, type)
  endif
  silent! call repeat#set("\<Plug>(unimpaired-put-".a:map.")")
endfunction

nnoremap <silent> <Plug>(unimpaired-put-above) :call <SID>putline('[p', 'above')<CR>
nnoremap <silent> <Plug>(unimpaired-put-below) :call <SID>putline(']p', 'below')<CR>
nnoremap <silent> <Plug>unimpairedPutAbove :call <SID>putline('[p', 'above')<CR>
nnoremap <silent> <Plug>unimpairedPutBelow :call <SID>putline(']p', 'below')<CR>

nmap [p <Plug>(unimpaired-put-above)
nmap ]p <Plug>(unimpaired-put-below)
nmap [P <Plug>(unimpaired-put-above)
nmap ]P <Plug>(unimpaired-put-below)

nnoremap ]q <cmd>execute v:count1 . "cnext"<CR>
nnoremap [q <cmd>execute v:count1 . "cprevious"<CR>
nnoremap ]Q <cmd>execute v:count1 . "clast"<CR>
nnoremap [Q <cmd>execute v:count1 . "cprevious"<CR>

nnoremap ]l <cmd>execute v:count1 . "lnext"<CR>
nnoremap [l <cmd>execute v:count1 . "lprevious"<CR>
nnoremap ]L <cmd>execute v:count1 . "llast"<CR>
nnoremap [L <cmd>execute v:count1 . "lfirst"<CR>
