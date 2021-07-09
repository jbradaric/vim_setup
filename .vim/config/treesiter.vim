if !has('nvim')
  finish
endif

lua require('utils').setup_treesitter()

hi link TSFuncBuiltin Function
hi link TSConstBuiltin MyConstant
hi link TSBoolean MyConstant
hi link TSOperator MyConstant
hi link TSInclude MyConditional
hi link TSConditional TSInclude
hi link TSRepeat TSInclude
hi link TSParameter FunctionParameter

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
