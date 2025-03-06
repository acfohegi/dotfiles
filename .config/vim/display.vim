" Indentation, folding, text display
"
"

set list
set listchars=tab:▸\ ,trail:·,leadmultispace:┊\ 
set foldmethod=indent
set foldlevel=100
set foldtext=trim(getline(v:foldstart),&commentstring.&foldmarker.1234567890)
set expandtab smarttab autoindent smartindent
set shiftwidth=4
set showmatch
set relativenumber
set number

autocmd FileType make setlocal noexpandtab
autocmd FileType ruby,javascript,cjs,mjs,typescript,pug,json
    \ setlocal shiftwidth=2

augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" Change vertical splitting from left to right.
" Change horizontal splitting from above to below.
set splitright
set splitbelow

