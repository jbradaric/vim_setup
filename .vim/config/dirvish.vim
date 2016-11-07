" Don't need netrw
let g:loaded_netrwPlugin = 1

function! s:dirvish_toggle_hidden()
  if get(b:, 'dirvish_show_dot_files')
    keeppatterns g@\v/\.[^\/]+/?$@d
    let b:dirvish_show_dot_files = 0
  else
    let b:dirvish_show_dot_files = 1
    call dirvish#open(@%)
  endif
endfunction

function! s:escaped(first, last) abort
  let l:files = getline(a:first, a:last)
  call filter(l:files, 'v:val !~# "^\" "')
  call map(l:files, 'substitute(v:val, "[/*|@=]\\=\\%(\\t.*\\)\\=$", "", "")')
  return join(l:files, ' ')
endfunction

let s:escape_pattern = 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'

function! s:setup_dirvish()
  let b:dirvish_show_dot_files = 1

  " Make fugitive work
  call fugitive#detect(@%)

  " Hide ignored files
  for pattern in map(split(&wildignore, ','), s:escape_pattern)
    execute 'silent keeppatterns g/^' . pattern . '$/d'
  endfor

  " Toggle display of hidden files with `gh`
  nnoremap <buffer> <silent> gh :<c-u>call <SID>dirvish_toggle_hidden()<cr>

  " ~ displays the $HOME directory
  nnoremap <buffer> ~ :<c-u>Dirvish ~<cr>

  " . populates the file under the cursor on the command line
  nnoremap <buffer> . :<c-u> <c-r>=<SID>escaped(line('.'), line('.') - 1 + v:count1)<cr><Home>
  nmap <buffer> ! .!
endfunction

augroup my_dirvish_events
  autocmd!
  autocmd FileType dirvish call s:setup_dirvish()
augroup END
