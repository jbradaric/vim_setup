if has('nvim')
  finish
endif

let g:khuno_max_line_length=100
let g:khuno_ignore="E123,E126,E128,E265,E266,E301,E302,E731,E701"
let g:khuno_automagic = 1

nnoremap <silent><Leader>x :<C-U>Khuno show<CR>
nnoremap <silent>[k :<C-U>Khuno on<CR>
nnoremap <silent>]k :<C-U>Khuno off<CR>
