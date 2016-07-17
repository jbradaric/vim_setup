let g:deoplete#sources = {}
let g:deoplete#sources.python = ['jedi']
let g:deoplete#sources#jedi#python_path = join([$HOME, '.scripts/workenv-python'], '/')

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
let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsJumpForwardTrigger = "<nop>"
let g:UltiSnipsJumpBackwardTrigger = "<nop>"
function! s:autocomplete_move(direction)
  if pumvisible()
    return a:direction ==# 'n' ? "\<c-n>" : "\<c-p>"
  else
    if a:direction ==# 'n'
      return "\<c-r>=UltiSnips#ExpandSnippetOrJump()\<cr>"
    else
      return "\<s-tab>"
    endif
  endif
endfunction
inoremap <silent><expr> <tab> <SID>autocomplete_move('n')
inoremap <silent><expr> <s-tab> <SID>autocomplete_move('p')

set completeopt+=noinsert
