if !has('nvim')
  finish
endif

let s:python_ignore = "E123,E126,E128,E261,E265,E266,E301,E302,E402,E731,E701"
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
    \ 'pipe': 1,
    \ 'args':
        \ [
        \  '--ignore=' . s:python_ignore,
        \  '--max-line-length=' . s:python_max_line_length,
        \  '--config=' . s:flake8_config,
        \  '--stdin-display-name', '%:p', '-'
        \ ],
    \ 'postprocess': function('SetWarningType'),
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#'
    \ }

let g:neomake_javascript_jshint_maker = {
    \ 'pipe': 1,
    \ 'args': ['--verbose', '--filename', '%:p', '-'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_verbose = 0

let g:neomake_javascript_enabled_makers = ['eslint', 'jshint']

" Update neomake data every 2 seconds
let s:neomake_update_interval = 2
let s:neomake_enabled_fts = ['python', 'javascript']

function s:neomake_setup()
  if index(s:neomake_enabled_fts, &ft) < 0
    return
  endif
  sign define neomake_dummy
  execute 'sign place 9999 line=1 name=neomake_dummy buffer=' . bufnr('')
  let b:neomake_last_changetick = b:changedtick
endfunction

function s:neomake_running()
  let l:current_buffer = bufnr('')
  let l:jobs = neomake#GetJobs()
  for jobinfo in values(l:jobs)
    if jobinfo.bufnr == current_buffer
      return 1
    endif
  endfor
  return 0
endfunction

function! s:neomake_buffer()
  if index(s:neomake_enabled_fts, &ft) < 0
    return
  endif

  if get(b:, 'neomake_buffer_disable_automatic', 0)
    return
  endif
  if get(b:, 'neomake_last_changedtick', -1) == b:changedtick
    return
  endif

  let last_change = get(b:, 'neomake_last_run_time', -1)
  if last_change == -1
    let s:neomake_running = 1
    exe 'Neomake'
    return
  endif

  if b:changedtick == b:neomake_last_changetick
    return
  endif

  let current_time = localtime()
  let last_change = get(b:, 'neomake_last_run_time', -1)
  if last_change != -1 && l:current_time - l:last_change < s:neomake_update_interval
    return
  endif

  if s:neomake_running()
    return
  endif

  let b:neomake_last_changedtick = b:changedtick
  let b:neomake_last_run_time = current_time
  execute 'Neomake'
endfunction

augroup MyNeomakeAutocommands
  autocmd!
  autocmd BufEnter * call s:neomake_setup()
  autocmd BufEnter,CursorHold,CursorHoldI,TextChanged,InsertLeave * call s:neomake_buffer()
augroup END

nnoremap ]k :<c-u>let b:neomake_buffer_disable_automatic=1<cr>
nnoremap [k :<c-u>let b:neomake_buffer_disable_automatic=0<cr>
