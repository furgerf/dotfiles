"""""""""""""""""""""""""""""""""
" Various plugins configuration "
"""""""""""""""""""""""""""""""""

" fzf "{{{
" layout of the popup
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" [Buffers] jup to existing window if possible
let g:fzf_buffers_jump = 1

" load marked items in quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

" change `split` to ctrl+s and load marks to quickfix with ctrl+q
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-q':function('s:build_quickfix_list'),
  \ 'ctrl-v': 'vsplit' }

" improved path completion
imap <c-x><c-f> <plug>(fzf-complete-path)

" mappings - for more see https://github.com/junegunn/fzf.vim#commands
nnoremap <silent> <Leader>fb :Buffers<CR>
nnoremap <silent> <Leader>fw :Window<CR>

nnoremap <silent> <Leader>fo :GFiles<CR>
nnoremap <silent> <Leader>fa :Files<CR>

nnoremap <silent> <Leader>fr :Rg<CR>
nnoremap <silent> <Leader>fta :Tags<CR>
nnoremap <silent> <Leader>ftb :BTags<CR>
nnoremap <silent> <Leader>fl :BLines<CR>

nnoremap <silent> <Leader>fha :Commits<CR>
nnoremap <silent> <Leader>fhb :BCommits<CR>

nnoremap <silent> <Leader>fm :Maps<CR>
"}}}

" vim-test "{{{
" setup mappings
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>tt :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
"}}}

" CamelCaseMotion "{{{
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
"}}}

" expand-region "{{{
" expand region by hitting `v`
vmap v <Plug>(expand_region_expand)
" reduce region by hitting `<C-v>`
vmap <C-v> <Plug>(expand_region_shrink)
"}}}

" vim-interestingwords "{{{
" use random colors
" let g:interestingWordsRandomiseColors = 1
" use gruvbox color palette
let g:interestingWordsTermColors = [
      \ 124,
      \ 106,
      \ 166,
      \ 66,
      \ 132,
      \ 72,
      \ 242,
      \ 229,
      \
      \ 167,
      \ 142,
      \ 208,
      \ 109,
      \ 175,
      \ 108,
      \ 244,
      \ 223,
      \
      \ 172,
      \ 250,
      \ ]
" call the actual function directly in normal mode to avoid a strange delay
nnoremap <silent> <leader>k :call InterestingWords('n')<CR>
" use the plugin command in visual mode
" NOTE: If there's no map for the plugin command at all, the plugin adds its
"       own mappings, overwriting `n` and `N` too in the process...
vmap <leader>k <Plug>(InterestingWords)
nmap <leader>K <Plug>(InterestingWordsClear)
" could also map these to cycle through interesting words but that is tricky
" to get right with the match highlighting and it doesn't work reliably anyway
" nmap n <Plug>(InterestingWordsForeward)
" nmap N <Plug>(InterestingWordsBackward)
"}}}

" vim-obsession "{{{
" start tracking session
" nnoremap <Leader>o :Obsess<CR>
" start/stop tracking session (and delete session file)
nnoremap <Leader>O :Obsess!<CR>
"}}}

" tagbar "{{{
" toggle tagbar
nnoremap <Leader>tt :TagbarToggle<CR>
nnoremap <Leader>tp :TagbarTogglePause<CR>
nnoremap <Leader>tj :TagbarOpenAutoClose<CR>
"}}}

" startify "{{{
" don't CD when opening file
let g:startify_change_to_dir=0
"}}}

" rainbow_csv "{{{
" don't map any keys
let g:rcsv_map_keys=0
"}}}

" colorizer "{{{
" disable colorizer for large files - it makes startup reeeeally slow
let g:colorizer_maxlines=200
"}}}

" syntastic "{{{
" keep updating the location list
let g:syntastic_always_populate_loc_list = 1

" open location list when there are errors and close when there are none
" let g:syntastic_auto_loc_list = 1

" check for errors when opening file and don't check when writing AND closing
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" aggregate errors from different checkers
let g:syntastic_aggregate_errors = 1

" allow shellcheck to follow external source files
let g:syntastic_sh_shellcheck_args = "-x"

" configure python checking
let g:syntastic_python_checkers = []

" TODO statusline
" TODO priority of messages greater than gitgutter?

" syntastic mappings
nnoremap <Leader>se :Errors<CR>
nnoremap <Leader>sm :SyntasticToggleMode<CR>
nnoremap <Leader>sc :SyntasticCheck<CR>
nnoremap <Leader>si :SyntasticInfo<CR>
"}}}

" vim-notes "{{{
" by default, use parent directory
" but also use subdirectories (and their index notes)
let g:notes_directories = [
      \ '~/SynologyDrive/fabian/Misc/Notes'
      \ ]

" append .txt for windows
let g:notes_suffix = '.txt'

" prompt about renaming file/changing title (for now)
" let g:notes_title_sync = 'one of: no|change_title|rename_file'

" DON'T disable the ugly 'smart' quotes because that also disables the bullet
" points, arrows, etc.
" let g:notes_smart_quotes = 0

" change the ruler to something that makes a bit more sense
let g:notes_ruler_text = repeat("*", 80)

" don't (un-)indent with alt-left/right
let g:notes_alt_indents = 0

nnoremap <Leader>no :Note 
nnoremap <Leader>nn viw:SplitNoteFromSelectedText<CR>
nnoremap <Leader>ns :SearchNotes 
nnoremap <Leader>nr :RelatedNotes<CR>
nnoremap <Leader>nm :RecentNotes<CR>
nnoremap <Leader>ni :ShowTaggedNotes<CR> " 'notes index'
"}}}

" mathematic.vim "{{{
" turn on mathematic keymap and increase timeoutlen
noremap <silent> <LocalLeader>mm :call functions#TurnOnMathematicMode()<CR>
" turn off mathematic keymap and decrease timeoutlen
noremap <silent> <LocalLeader>mn :call functions#TurnOffMathematicMode()<CR>
" show keymaps
noremap <LocalLeader>ms :sp ~/git/dotfiles/vim/bundle/mathematic.vim/keymap/mathematic.vim<CR>
" run key helper (to insert single special key)
nnoremap <LocalLeader>kh :KeyHelper<CR>
inoremap <LocalLeader>kh <Esc>:KeyHelper<CR>
"}}}

" vim-mundo "{{{
" if has('python3')
"   let g:gundo_prefer_python3 = 1
" endif
noremap <Leader>u :MundoToggle<CR>
"}}}

" vim-asterisk "{{{
" regular */#: use smartcase
" g */#: use selection instead of word
" z */#: stay on first match
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
let g:asterisk#keeppos = 0
"}}}

" coc.nvim {{{
" TODO extra stuff to check out
" - https://github.com/neoclide/coc-sources
" - (https://github.com/jsfaint/coc-neoinclude)
" - https://github.com/neoclide/coc-yaml
" - https://github.com/yaegassy/coc-ansible
" - https://github.com/yaegassy/coc-pydocstring
" - prioritize/disable certain sources
" - go through/unify snippets
" - detailed pyright configuration https://github.com/microsoft/pyright/blob/main/docs/configuration.md
" - install https://github.com/python-rope/rope
"   -> https://github.com/python-rope/ropevim seems bad
"   -> https://github.com/python-mode/python-mode could be better but does tons of other stuff

" TODO check if those are obsolete:
" - vim-json
" - vim-isort
" - vim-grepper
" - vim-black

" navigate completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" trigger completion - NOTE: conflicts with expand-snippet
" inoremap <silent><expr> <C-@> pumvisible() ? coc#_select_confirm() : coc#refresh()

" auto-select the first completion item and notify coc.nvim to format on enter
" inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-y> pumvisible() ? coc#_select_confirm() : "\<C-y>"

" navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" code navigation
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition) " TODO get working
" nmap <silent> gi <Plug>(coc-implementation) " TODO get working
nmap <silent> gr <Plug>(coc-references)

" show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" rename symbol
nmap <leader>rn <Plug>(coc-rename)

" format selected code
xmap <leader>ff  <Plug>(coc-format-selected)
nmap <leader>ff  <Plug>(coc-format)

" apply codeAction to the selected region
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-line)
" apply codeAction to the current buffer
nmap <leader>A  <Plug>(coc-codeaction)

" apply AutoFix to problem on the current line
" TODO get this working
nmap <leader>qf  <Plug>(coc-fix-current)

" map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" scroll through float windows/popups
nnoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-n>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-n>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges. TODO set up or remove
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" add coc status to status line
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" mappings for CoCList
nnoremap         <nowait> <leader>cl  :<C-u>CocList 
nnoremap <silent><nowait> <leader>ca  :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <leader>cp  :<C-u>CocListResume<CR>
" }}}

" coc-snippets {{{
" trigger snippet expand
imap <C-@> <Plug>(coc-snippets-expand)

" use selected text as visual placeholder of snippet
" vmap <C-j> <Plug>(coc-snippets-select)

" (default values for jumping to next/previous placeholder)
" let g:coc_snippet_next = '<C-j>'
" let g:coc_snippet_prev = '<C-k>'

" expand and jump (make expand higher priority)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

let g:ultisnips_python_style = "google"
" }}}

