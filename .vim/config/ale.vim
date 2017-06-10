let s:user_config_path = substitute(system('systemd-path user-configuration'), '\n\+$', '', '')
let s:flake8_config = join([s:user_config_path, 'flake8'], '/')

let s:python_ignore = 'E123,E126,E128,E261,E265,E266,E301,E302,E305,E306,E402,E731,E701,W602'
let s:python_max_line_length = 100

let g:ale_python_flake8_executable = 'flake8-python2'
let g:ale_python_flake8_options = '--ignore=' . s:python_ignore
let g:ale_python_flake8_options .= ' --max-line-length=' . s:python_max_line_length
let g:ale_python_flake8_options .= ' --config=' . s:flake8_config

let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'javascript': ['eslint', 'jshint'],
    \ 'cpp': ['clang'],
    \ 'c': ['clang'],
    \ }

let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'

function s:setup_compiler_flags()
  if has_key(b:, 'ale_cpp_clang_options') || has_key(b:, 'ale_c_clang_options')
    return
  endif
  if !has_key(b:, 'compile_commands_path')
    let l:project_root = FindRootDirectory()
    if l:project_root ==# ''
      return
    endif
    let b:compile_commands_path = l:project_root . '/compile_commands.json'
  endif
  if !filereadable(b:compile_commands_path)
    return
  endif

  lua << EOF
  local json = require 'json'
  local buf = vim.api.nvim_get_current_buf()
  local f = io.open(vim.api.nvim_buf_get_var(buf, 'compile_commands_path'), 'rb')
  local contents = f:read '*a'
  f:close()
  local t = json.decode(contents)
  local buf_name = vim.api.nvim_buf_get_name(buf)
  for _, v in pairs(t) do
    if v['file'] == buf_name then
      local arr = {}
      local arg_count = 0
      for arg in string.gmatch(v['command'], '%S+') do
        if arg_count >= 4 then
          table.insert(arr, arg)
        end
        arg_count = arg_count + 1
      end
      table.remove(arr, #arr)
      table.insert(arr, '-Wno-tautological-constant-out-of-range-compare')
      local options = table.concat(arr, ' ')
      if vim.api.nvim_buf_get_option(buf, 'filetype') == 'c' then
        vim.api.nvim_buf_set_var(buf, 'ale_c_clang_options', options)
      else
        vim.api.nvim_buf_set_var(buf, 'ale_cpp_clang_options', options)
      end
    end
  end
EOF
endfunction

augroup my_ale_highlights
  autocmd!
  autocmd ColorScheme *
      \ hi ALEErrorSign guibg=none guifg=#ff0000
      \ hi ALEWarningSign guibg=none guifg=#ffff00
      \ hi link NeomakeError SpellBad |
      \ hi link NeomakeWarning SpellCap
  autocmd BufReadPost act/*.cpp call s:setup_compiler_flags()
  autocmd BufReadPost act/*.c call s:setup_compiler_flags()
augroup END
