let s:user_config_path = substitute(system('systemd-path user-configuration'), '\n\+$', '', '')
let s:flake8_config = join([s:user_config_path, 'flake8'], '/')

let s:python_ignore = 'E123,E126,E128,E261,E265,E266,E301,E302,E305,E306,E402,E701,E731,E741,W602,F811,W503,W504'
let s:python_max_line_length = 100

let g:ale_python_flake8_options = '--ignore=' . s:python_ignore
let g:ale_python_flake8_options .= ' --max-line-length=' . s:python_max_line_length
let g:ale_python_flake8_options .= ' --config=' . s:flake8_config

let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'javascript': ['eslint', 'jshint'],
    \ 'cpp': ['clang'],
    \ 'c': ['clang'],
    \ 'tex': [],
    \ }
let g:ale_disable_lsp = 1

let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_style_error = g:ale_sign_warning
let g:ale_set_signs = 1

let g:ale_virtualtext_cursor = 1

function s:setup_compiler_flags()
  if !has('nvim')
    return
  endif
  lua require'utils'.init_ale()
endfunction

augroup my_ale_highlights
  autocmd!
  autocmd ColorScheme *
      \ hi ALEErrorSign guibg=none guifg=#ff0000 |
      \ hi ALEWarningSign guibg=none guifg=#ffff00 |
      \ hi AleVirtualTextError guifg=#8a02020 |
      \ hi link NeomakeError SpellBad |
      \ hi link NeomakeWarning SpellCap
  autocmd BufReadPost *.cpp call s:setup_compiler_flags()
  autocmd BufReadPost *.c call s:setup_compiler_flags()
augroup END
