" Autocommands
"-------------------------------------------------------------------------"{{{
if has('autocmd')
    autocmd FileType c,cpp,h,hpp setlocal comments=sl:/**,mb:\ *,elx:\ */
    autocmd FileType txt setlocal spell spelllang=en_gb textwidth=72 wrap formatoptions+=t
    autocmd FileType vimrc set filetype=vim
    autocmd FileType py set filetype=python
    autocmd! BufRead,BufWrite,BufWritePost,BufNewFile *.org
    autocmd BufWinLeave *.py mkview
    autocmd BufWinEnter *.py silent loadview
endif
"-------------------------------------------------------------------------"}}}
