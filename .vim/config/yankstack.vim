" let g:yankstack_map_keys = 0
" nmap <A-p> <Plug>yankstack_substitute_older_paste
" xmap <A-p> <Plug>yankstack_substitute_older_paste
" nmap <A-n> <Plug>yankstack_substitute_newer_paste
" xmap <A-n> <Plug>yankstack_substitute_newer_paste
"
" call yankstack#setup()
" nmap Y y$
finish
if has('nvim')
  map p <Plug>(miniyank-autoput)
  map P <Plug>(miniyank-autoPut)

  map <A-p> <Plug>(miniyank-cycle)
endif
