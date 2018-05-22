let $FZF_DEFAULT_COMMAND='rg --hidden --files --follow --glob "!.git" --glob "!*.png" --glob "!.PlayOnLinux" --glob "!PlayOnLinux' . "'" . 's virtual drives"'

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }


let g:fzf_files_options =
    \ '--preview "(highlight -s candy -O truecolor {} || cat {}) 2> /dev/null | head -'.&lines.'"'
let g:fzf_buffers_jump = 1

command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

function! s:fzf_current_project()
  let root = FindRootDirectory()
  execute 'Files ' . fnameescape(l:root)
endfunction

nnoremap <c-p> :<c-u>call <SID>fzf_current_project()<cr>
nnoremap <leader>b :<c-u>Buffers<cr>
nnoremap <leader>ff :<c-u>call <SID>fzf_current_project()<cr>
nnoremap <leader>fbl :<c-u>BLines<space>
nnoremap <leader>fl :<c-u>Lines<space>
nnoremap <leader>fc :<c-u>Commits<cr>
nnoremap <leader>ft :<c-u>Tags<space>
nnoremap <leader>fw :<c-u>Windows<cr>
nnoremap <leader>fr :<c-u>Rg<space>
