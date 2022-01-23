" disable shared data for git rebases
if has('nvim')
  setlocal shada="NONE"
else
  setlocal viminfo="NONE"
endif

