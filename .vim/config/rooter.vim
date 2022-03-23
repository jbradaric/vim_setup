" let g:rooter_change_directory_for_non_project_files = 'current'
" let g:rooter_patterns = ['.git', '.hg', 'package.json', '!Makefile']
" let g:rooter_cd_cmd = 'lcd'
" let g:rooter_silent_chdir = 0
" let g:rooter_resolve_links = 1
if has('nvim')
lua << EOF
  require('rooter').setup({
    patterns = {'.git', 'package.json', 'Cargo.toml', 'setup.cfg'},
    change_dir_for_non_project_files = 'current',
  })
EOF
endif
