let $FZF_DEFAULT_COMMAND='rg --files --follow --glob "!*.png" --glob "!.PlayOnLinux" --glob "!PlayOnLinux' . "'" . 's virtual drives"'

let g:fzf_command_prefix = 'Fzf'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }


let g:fzf_files_options = 
    \ '--preview "(highlight -s candy -O truecolor {} || cat {}) 2> /dev/null | head -'.&lines.'"'
let g:fzf_buffers_jump = 1

command! -bang -nargs=* FzfRg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

function! s:fzf_current_project()
  let git_root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error != 0
    execute 'FzfFiles'
  else
    execute 'FzfFiles ' . fnameescape(git_root)
  endif
endfunction

nnoremap <c-p> :<c-u>call <SID>fzf_current_project()<cr>
nnoremap <leader>b :<c-u>FzfBuffers<cr>
nnoremap <leader>ff :<c-u>call <SID>fzf_current_project()<cr>
nnoremap <leader>fbl :<c-u>FzfBLines<space>
nnoremap <leader>fl :<c-u>FzfLines<space>
nnoremap <leader>fc :<c-u>FzfCommits<cr>
nnoremap <leader>ft :<c-u>FzfTags<space>
nnoremap <leader>fw :<c-u>FzfWindows<cr>
nnoremap <leader>fr :<c-u>FzfRg<space>
