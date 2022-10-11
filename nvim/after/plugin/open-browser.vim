let g:openbrowser_browser_commands = [
    \ {'name': '/usr/bin/firefox',
    \ 'args': ['{browser}', '-P', 'work', '--new-tab', '{uri}']}
    \ ]
nmap gx <Plug>(openbrowser-smart-search)

" Get selected text in visual mode.
function! s:_get_last_selected()
    let save_z = getreg('z', 1)
    let save_z_type = getregtype('z')

    try
        normal! gv"zy
        return @z
    finally
        call setreg('z', save_z, save_z_type)
    endtry
endfunction

function! s:_get_selected_text() abort
  let selected_text = s:_get_last_selected()
  let text = substitute(selected_text, '[\n\r]\+', '', 'g')
  return substitute(text, '^\s*\|\s*$', '', 'g')
endfunction

function! s:open_selected_url()
  let text = s:_get_selected_text()
  call openbrowser#open(text)
endfunction

vmap gx :<c-u>silent! call <sid>open_selected_url()<cr>
