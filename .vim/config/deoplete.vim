let g:deoplete#sources = {}
let g:deoplete#sources.python = ['ultisnips', 'jedi']
let g:deoplete#sources#jedi#python_path = join([$HOME, '.scripts/workenv-python'], '/')

" <C-h>, <BS>: close popup and delete backward char
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function() abort
"   return deoplete#mappings#close_popup() : "\<CR>"
" endfunction

let g:deoplete#disable_auto_complete = 1
inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()
inoremap <silent><expr><NUL> deoplete#mappings#manual_complete()

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

set completeopt+=noinsert
