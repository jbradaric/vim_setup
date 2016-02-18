let g:fzf_command_prefix = 'Fzf'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

" function! s:fzf_in_vcs_root()
"   let dir = fnamemodify(expand('%'), ':p:h')
"   for vcs in ['.git', '.hg', '.bzr', '.svn']
"     let root = finddir(vcs, dir . ';')
"     if !empty(root)
"       execute ':FzfFiles ' . fnamemodify(root, ':h')
"       return
"     else
"       execute ':FzfFiles ' . dir
"     endif
"   endfor
" endfunction
" nnoremap <c-p> :<c-u>call s:fzf_in_vcs_root()<cr>

nnoremap <leader>b :<c-u>FzfBuffers<cr>
