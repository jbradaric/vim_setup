if !has('nvim')
  finish
endif

let s:python_ignore = 'E123,E126,E128,E261,E265,E266,E301,E302,E305,E306,E402,E731,E701'
let s:python_max_line_length = 100
let s:python_error_types_override = {
    \ '127': 'W',
    \ '124': 'W',
    \ '203': 'W',
    \ '221': 'W',
    \ '225': 'W',
    \ '226': 'W',
    \ '231': 'W',
    \ '251': 'W',
    \ '241': 'W',
    \ '262': 'W',
    \ '303': 'W',
    \ '501': 'W',
    \ '502': 'W',
    \ '702': 'W',
    \ '713': 'W',
    \ '841': 'W',
    \ }

let s:user_config_path = substitute(system('systemd-path user-configuration'), '\n\+$', '', '')
let s:flake8_config = join([s:user_config_path, 'flake8'], '/')

function! SetWarningType(entry)
    if has_key(s:python_error_types_override, a:entry.nr)
        let a:entry.type = s:python_error_types_override[a:entry.nr]
    endif
    if a:entry.type ==# 'F'
        let a:entry.type = 'E'
    endif
endfunction

let g:neomake_python_flake8_maker = {
    \ 'exe': 'flake8-python2',
    \ 'args':
        \ [
        \  '--ignore=' . s:python_ignore,
        \  '--max-line-length=' . s:python_max_line_length,
        \  '--config=' . s:flake8_config,
        \ ],
    \ 'postprocess': function('SetWarningType'),
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#'
    \ }

let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose', '--filename', '%:p', '-'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_verbose = 0

let g:neomake_javascript_enabled_makers = ['eslint', 'jshint']

let g:neomake_autolint_sign_column_always = 1
nnoremap ]k :<c-u>NeomakeAutolintToggle<cr>

function! s:find_compile_commands(file_path)
  let l:dir = fnamemodify(a:file_path, ':p:h')
  let l:path_components = xolox#misc#path#split(l:dir)
  while len(l:path_components) > 0
    let l:curpath = add(copy(l:path_components), 'compile_commands.json')
    let l:db_path = xolox#misc#path#join(l:curpath)
    if filereadable(l:db_path)
      return l:db_path
    endif
    call remove(l:path_components, len(l:path_components) - 1)
  endwhile
  return ''
endfunction

function! s:remove_item(list, item, include_next)
  let l:idx = index(a:list, a:item)
  if l:idx !=# -1
    if a:include_next
      call remove(a:list, l:idx, l:idx + 1)
    else
      call remove(a:list, l:idx)
    endif
  endif
endfunction

function! s:parse_compile_args(cmd)
  let l:args = split(a:cmd, '\s\+')
  call remove(l:args, 0)  " compiler executable
  call s:remove_item(l:args, '-c', 0)
  call s:remove_item(l:args, '-o', 1)
  call remove(l:args, len(l:args) - 1)
  return l:args
endfunction

function! s:get_compile_commands(db_path, file_path)
  if !filereadable(a:db_path)
    return []
  endif
  for l:data in json_decode(readfile(a:db_path))
    if l:data.file ==# a:file_path
      let l:foo = s:parse_compile_args(l:data.command)
      call s:remove_item(l:foo, a:file_path, 0)  " remove the file name

      let l:file_dir = fnamemodify(a:file_path, ':p:h')
      if index(l:foo, l:file_dir) == -1
        let l:foo = add(l:foo, '-I' . l:file_dir)
      endif
      return add(l:foo, '-fsyntax-only')
    endif
  endfor
  return []
endfunction

" autolint hooks {{{
function! s:setup_compiler_flags(jobinfo) dict
  if self.ft !=# 'cpp' && self.ft !=# 'c'
    return 0
  endif
  let l:filename = fnamemodify(bufname(a:jobinfo.bufnr), ':p')
  let l:db_path = s:find_compile_commands(l:filename)
  let l:commands = s:get_compile_commands(l:db_path, l:filename)
  let self.args = extend(self.args, l:commands)
  return self
endfunction

function! s:setup_clangcheck_flags(jobinfo) dict
  let l:filename = fnamemodify(bufname(a:jobinfo.bufnr), ':p')
  let l:db_path = s:find_compile_commands(l:filename)
  if l:db_path ==# ''
    return 0
  endif
  let self.args = extend(self.args, ['-p', l:db_path])
endfunction

let g:neomake_cpp_gcc_maker = {
    \ 'fn': function('s:setup_compiler_flags'),
    \ }
let g:neomake_c_gcc_maker = {
    \ 'fn': function('s:setup_compiler_flags'),
    \ }
let g:neomake_cpp_clang_maker = {
    \ 'fn': function('s:setup_compiler_flags'),
    \ }
let g:neomake_c_clang_maker = {
    \ 'fn': function('s:setup_compiler_flags'),
    \ }
let g:neomake_cpp_clangcheck_maker = {
    \ 'fn': function('s:setup_clangcheck_flags')
    \ }
let g:neomake_c_clangcheck_maker = {
    \ 'fn': function('s:setup_clangcheck_flags')
    \ }
" }}}

" Make errors and warning more distinguishable
let g:neomake_highlight_lines = 1
augroup my_neomake_highlights
  autocmd!
  autocmd ColorScheme *
      \ hi link NeomakeError SpellBad |
      \ hi link NeomakeWarning SpellCap
augroup END
