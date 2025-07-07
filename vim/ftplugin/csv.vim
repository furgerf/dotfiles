" convert excel paste to CSV
" - paste from system clipboard
" - select to beginning of paste
" - replace:
"   - Remove carriage returns
"   - Replace tabs with separators
" with nonprintable characters: let @q = 'o^["+pv''[:s/^V^M// | ''<,''>s/	/,/^M'
let @q = 'o"+pv''[:s/// | ''<,''>s/	/,/'
