"""""""""""""
" Functions "
"""""""""""""

" highlight the current search match by blinking for `blinktime` seconds
function! functions#HighlightNext(blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#\%('.@/.'\)'
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

" renames the current file
function! functions#RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" move the cursor to the line it was on and center file
function! functions#SetLastCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exec "normal! g`\""
      normal! zz
    endif
  endif
endfunction

" moves the current buffer to a new tab if it's a helpfile
function! functions#HelpInNewTab()
  if &buftype == 'help'
    exec "normal \<C-W>T"
  endif
endfunction

" closes the current buffer or exits vim if the current buffer is empty
function! functions#DeleteBufferOrExit()
  if line('$') == 1 && getline(1) == ''
    q
  else
    " close location list
    lclose
    " just doing `bd` seems to close two buffers (?)
    exec "normal! :bd<CR>"
  endif
endfunction

function! functions#HighlightColumns(delimiter, colors)
  if len(a:colors) < 2
    return
  endif

  for groupid in range(len(a:colors))
    let match = 'column' . groupid
    let nextgroup = groupid + 1 % len(a:colors)

    " match with nextgroup if we haven't already matched for all a:colors
    if nextgroup
      let cmd = 'syntax match %s /%s[^%s]*/ nextgroup=column%d'
      exec printf(cmd, match, a:delimiter, a:delimiter, nextgroup)
    else
      let cmd = 'syntax match %s /%s[^%s]*/'
      exec printf(cmd, match, a:delimiter, a:delimiter)
    endif

    " add color for match
    let cmd = 'highlight %s ctermfg=%s guifg=%s'
    exec printf(cmd, match, a:colors[groupid][0], a:colors[groupid][1])
  endfor

  let cmd = 'syntax match startcolumn /^[^%s]*/ nextgroup=column1'
  exec printf(cmd, a:delimiter)
  let cmd = 'highlight startcolumn ctermfg=%s guifg=%s'
  exec printf(cmd, a:colors[0][0], a:colors[0][1])
endfunction

" returns true if the current buffer is a special buffer
" eg quickfix, preview, location list
function! functions#IsSpecialBuffer()
  return (&filetype =~ 'qf')
endfunction

" returns true if the current buffer is NOT a special buffer
function! functions#IsNonspecialBuffer()
  return ! functions#IsSpecialBuffer()
endfunction

" close all quickfix, preview, location list OR open location list (syntastic)
" NOTE: Currently unused
" http://stackoverflow.com/questions/17512794/toggle-error-location-panel-in-syntastic/17515778#17515778
function! functions#ToggleErrors()
  if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
    " no location/quickfix list shown, open syntastic error location panel
    " NOTE: This means you can't close preview/quickfix if current window has no errors
    Errors
  else
    " remember current window number
    let current_window = winnr()
    " close preview, quickfix, and ALL location lists
    pclose
    cclose
    " http://superuser.com/questions/355325/close-all-locations-list-or-quick-fix-windows-in-vim/764500#764500
    windo if &buftype == "quickfix" || &buftype == "locationlist" | lclose | endif

    " move to previously active window
    let windows_off = (current_window - winnr() + winnr('$')) % winnr('$')
    if windows_off
      execute windows_off . "wincmd w"
    endif
  endif
endfunction

function! functions#TurnOnMathematicMode()
  if &keymap ==# 'mathematic'
    return
  endif

  set keymap=mathematic
  set timeoutlen=2000
  echo 'Turned on mathematic mode!'
endfunction
function! functions#TurnOffMathematicMode()
  if &keymap !=# 'mathematic'
    return
  endif

  set keymap=
  set timeoutlen=500
  echo 'Turned off mathematic mode!'
endfunction

