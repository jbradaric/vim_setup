"-------------------------------------------------------------------------"}}}
" CtrlP settings
"-------------------------------------------------------------------------"{{{
let g:ctrlp_working_path_mode = 2
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_custom_ignore = {
  \ 'dir': '\.git$\|doc$',
  \ 'file': '\v\.(os|o|so|pyc|pdf|png|txt|xml)$'
  \ }
nnoremap <Leader>p :CtrlPBuffer<CR>

if executable("ag")
    let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif
