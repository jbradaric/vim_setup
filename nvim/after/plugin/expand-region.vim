xmap m <Plug>(expand_region_expand)
xmap <m-m> <Plug>(expand_region_shrink)
call expand_region#custom_text_objects({
      \ 'a]' :1,
      \ 'ab' :1,
      \ 'aB' :1,
      \ 'ii' :0,
      \ 'ai' :0,
      \ })
