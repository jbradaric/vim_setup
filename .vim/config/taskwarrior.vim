let g:task_rc_override = 'rc.defaultwidth=0'

if &termguicolors
  highlight taskwarrior_urgency guifg=#77967f
  highlight taskwarrior_due guifg=#ff426e
  highlight taskwarrior_tablehead guifg=#f2db8f guibg=none gui=underline
endif
