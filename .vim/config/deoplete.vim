if !has('nvim')
  finish
endif

let g:deoplete#sources = {}
let g:deoplete#sources.python = ['jedi', 'ultisnips']
let g:deoplete#sources#jedi#python_path = join([$HOME, '.scripts/local_workenv.sh'], '/')

let g:deoplete#sources#jedi#use_filesystem_cache = 1
let g:deoplete#sources#jedi#auto_imports = ['gtk', 'gtk.gdk', 'cStringIO', 'age']

" <C-h>, <BS>: close popup and delete backward char
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function() abort
"   return deoplete#mappings#close_popup() : "\<CR>"
" endfunction

" let g:deoplete#disable_auto_complete = 1
inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()
inoremap <silent><expr><NUL> deoplete#mappings#manual_complete()

" Use <tab>/<s-tab> to move through the completion menu if it is visible.
" If it is not visible, try to expand a snippet.
" let g:UltiSnipsExpandTrigger = "<nop>"
" let g:UltiSnipsJumpForwardTrigger = "<nop>"
" let g:UltiSnipsJumpBackwardTrigger = "<nop>"
function! s:autocomplete_move(direction)
  if pumvisible()
    return a:direction ==# 'n' ? "\<c-n>" : "\<c-p>"
  else
    if a:direction ==# 'n'
        return "\<tab>"
    else
      return "\<s-tab>"
    endif
  endif
endfunction
inoremap <silent><expr> <tab> <SID>autocomplete_move('n')
inoremap <silent><expr> <s-tab> <SID>autocomplete_move('p')

set completeopt+=noselect

" deoplete-clang
let g:deoplete#sources#clang#debug = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang'
let g:deoplete#sources#clang#std = {"c": "c89", "cpp": "c++98"}
let g:deoplete#sources#clang#clang_complete_database = '/home/jurica/sources/actual_work/local_env/act'