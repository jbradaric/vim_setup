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

if !has('nvim') && has('python')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    let g:ctrlp_lazy_update = 50
    let g:ctrlp_max_files = 0
endif

if executable("ag")
    " let g:ctrlp_user_command = 'ag %s --nocolor --hidden -g ""'
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --hidden -g ""'
endif
