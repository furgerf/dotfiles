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
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <C-j>/<C-k> to navigate popup if shown, otherwise use other maps (navigate windows)
imap <expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
imap <expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

" trigger completion - NOTE: conflicts with expand-snippet
" inoremap <silent><expr> <C-@> pumvisible() ? coc#_select_confirm() : coc#refresh()

" auto-select the first completion item and notify coc.nvim to format on enter
" inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" inoremap <silent><expr> <C-y> pumvisible() ? coc#_select_confirm() : "\<C-y>"

" navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" code navigation
" nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gdd <Plug>(coc-definition)
nmap <silent> gds :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> gdv :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation) " TODO get working
nmap <silent> gr <Plug>(coc-references)

" show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
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
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <silent> <leader>qa :CocCommand eslint.executeAutofix<CR>

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

imap <silent><script><expr> <C-h> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" coc-snippets {{{
" trigger snippet expand
imap <C-n> <Plug>(coc-snippets-expand)

" use selected text as visual placeholder of snippet
" vmap <C-j> <Plug>(coc-snippets-select)

" (default values for jumping to next/previous placeholder)
" let g:coc_snippet_next = '<C-j>'
" let g:coc_snippet_prev = '<C-k>'

" expand and jump (make expand higher priority)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

let g:ultisnips_python_style = "google"
" }}}

