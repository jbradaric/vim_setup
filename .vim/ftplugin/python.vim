setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
setlocal nowrap

setlocal list
setlocal listchars=tab:>.,trail:. " Show tabs and trailing spaces

setlocal foldmethod=indent
setlocal foldlevel=999

" only wrap comments at textwidth
setlocal formatoptions-=t
" insert comment leader when pressing <cr> in insert mode
setlocal formatoptions+=r
setlocal textwidth=79

let g:python_highlight_builtins = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_string_formatting = 1
let g:python_slow_sync = 1

let s:normal_text_width = &tw
let s:comment_text_width = 72
function! GetPythonTextWidth()
  let l:cur_syntax = synIDattr(synIDtrans(synID(line('.'), col('.'), 0)), "name")
  if l:cur_syntax ==# 'Comment'
    return s:comment_text_width
  else return s:normal_text_width
  endif
endfunction

let s:pytest_options = split('-m pytest -q --tb=native')

function! s:remove_escape_codes(idx, text)
  let new_text = substitute(a:text, '\e\[[0-9;]\+[mK]', '', 'g')
  return substitute(l:new_text, '$', '', '')
endfunction

function! s:OnStdout(run_data, job_id, data, event) dict
  let eof = (a:data == [''])
  " Complete the previous line
  let a:run_data.lines[-1] .= a:data[0]
  " Append (last item may be a partial line, until EOF)
  call extend(a:run_data.lines, a:data[1:])
endfunction

function! s:OnExit(run_data, job_id, data, event) dict
  " Remove escape codes
  call map(a:run_data.lines, function('s:remove_escape_codes'))
  " Write the file
  call writefile(a:run_data.lines, a:run_data.outfile)
  " Close the terminal
  call nvim_win_close(a:run_data.term_win, v:true)
  " Activate the window with the test file
  call nvim_set_current_win(a:run_data.curr_win)
  " Read error file
  silent! execute 'cfile ' . a:run_data.outfile
  " Open quickfix window
  belowright copen 20
  " Delete the temporary file
  call delete(a:run_data.outfile)
endfunction

function! RunPytest(pytest_runner)
  if &ft !=# 'python'
    echoerr expand('%:p') . ' is not a Python file'
    return
  endif
  compiler pytest
  let fname = expand('%:p')
  let runner_cmd = split(a:pytest_runner) + s:pytest_options

  let run_data = {}
  let run_data.lines = ['']
  let run_data.outfile = tempname()
  let run_data.curr_win = nvim_get_current_win()

  " Create a window for the terminal
  below split
  enew
  call nvim_win_set_height(0, 20)
  let run_data.term_win = nvim_get_current_win()

  let opts = {
      \ 'on_stdout': function('s:OnStdout', [run_data]),
      \ 'on_exit': function('s:OnExit', [run_data]),
      \ }
  let job_id = termopen(runner_cmd + [fname], opts)
endfunction
