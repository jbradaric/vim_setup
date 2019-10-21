" Vim compiler file
" Compiler:	Unit testing tool for Python
" Maintainer:	Ali Aliev <ali@aliev.me>
" Last Change: 2015 Nov 2

if exists("current_compiler")
  finish
endif

let current_compiler = "pytest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" Disable Python warnings
if !exists('$PYTHONWARNINGS')
  let $PYTHONWARNINGS="ignore"
endif

" py.test errors begin with  ____ test_name ____
CompilerSet efm =%+G_%\\+%.%#

" Python errors are multi-lined. They often start with 'Traceback', so
" we want to capture that (with +G) and show it in the quickfix window
" because it explains the order of error messages.

" CompilerSet efm +=%+GTraceback%.%#,

" The error message itself starts with a line with 'File' in it. There
" are a couple of variations, and we need to process a line beginning
" with whitespace followed by File, the filename in "", a line number,
" and optional further text. %E here indicates the start of a multi-line
" error message. The %\C at the end means that a case-sensitive search is
" required.
CompilerSet efm +=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m%\\C,
CompilerSet efm +=%E\ \ File\ \"%f\"\\,\ line\ %l%\\C,

" The possible continutation lines are idenitifed to Vim by %C. We deal
" with these in order of most to least specific to ensure a proper
" match. A pointer (^) identifies the column in which the error occurs
" (but will not be entirely accurate due to indention of Python code).
CompilerSet efm +=%C%p^,

" Any text, indented by more than two spaces contain useful information.
" We want this to appear in the quickfix window, hence %+.
CompilerSet efm +=%+G\ \ \ \ %.%#,
CompilerSet efm +=%+G\ \ %.%#,

" The last line (%Z) does not begin with any whitespace. We use a zero
" width lookahead (\&) to check this. The line contains the error
" message itself (%m)
CompilerSet efm +=%Z%\\S%\\&%m,

" We can ignore any other lines (%-G)
CompilerSet efm +=%-G%.%#

" vim:foldmethod=marker:foldlevel=0
