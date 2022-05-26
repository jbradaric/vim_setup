lua << EOF
  require('rooter').setup({
    patterns = {'.git', 'package.json', 'Cargo.toml', 'setup.cfg'},
    change_dir_for_non_project_files = 'current',
  })
EOF
