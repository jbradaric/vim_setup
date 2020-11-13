let $FZF_DEFAULT_COMMAND='rg --hidden --files --follow --glob "!.git" --glob "!*.png" --glob "!*.jpg" --glob "!*.pdf" --glob "!*.pptx" --glob "!*.doc" --glob "!share/help/streetmap" --glob "!.PlayOnLinux" --glob "!PlayOnLinux' . "'" . 's virtual drives"'

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }


let g:fzf_files_options = '--preview "bat --theme="OneHalfDark" --style=numbers,changes --color=always {} | head -'.&lines.'"'
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

if has('nvim')
  let $FZF_DEFAULT_OPTS='--color=dark --color=bg:#444444,bg+:#444444 --color=info:#444444,prompt:-1,pointer:#e21d7d,marker:#e21d7d,spinner:11,header:#444444 --layout=reverse --margin=1,4'
  let g:fzf_layout = {'window': 'call FloatingFZF()'}
endif

hi FloatingBorder guibg=#333333
let s:float_border_win = 0

function! s:create_border_win(opts)
  let border_opts = {
      \ 'relative': 'editor',
      \ 'row': a:opts['row'] - 1,
      \ 'col': a:opts['col'] - 1,
      \ 'width': a:opts['width'] + 2,
      \ 'height': a:opts['height'] + 2,
      \ 'style': 'minimal',
      \ }
  let border_buf = nvim_create_buf(v:false, v:true)
  let border_win = nvim_open_win(border_buf, v:true, border_opts)
  call setwinvar(border_win, '&winhl', 'Normal:FloatingBorder,EndOfBuffer:FloatingBorder')
endfunction

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  let height = float2nr(&lines * 0.4)
  let width = float2nr(&columns * 0.6)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = float2nr((&lines - height) / 2)
  let opts = {
      \ 'relative': 'editor',
      \ 'row': vertical,
      \ 'col': horizontal,
      \ 'width': width,
      \ 'height': height
      \ }
  " Open a floating window in the background to simulate padding
  let s:float_border_win = s:create_border_win(opts)
  " Open the new window, floating, and activate it
  call nvim_open_win(buf, v:true, opts)

  " Close border window when fzf window closes
  autocmd CursorMoved * ++once call nvim_win_close(s:float_border_win, v:true)
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
