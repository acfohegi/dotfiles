" Netrw settings
"
"
" 3 is for tree-view. Commented out due to bugs.
" let g:netrw_liststyle=3
" Human-readable size style with 1024 base
let g:netrw_sizestyle="H"

" Turn off help banner
let g:netrw_banner=0

" Set vertical splitting for preview window ('p') and for previous window ('P') if there is only one window
let g:netrw_preview=1

" Set right splitting instead of left for ('v')
let g:netrw_alto=0

" Enable shrinking/expanding netrw with netrw-c-tab and remap it
let g:netrw_altv=1

" Unset above splitting instead of below for ('o').
" Unobvious but it is necessary for the preview windows to be on the right side.
let g:netrw_usetab=1

" nnoremap <> <Plug>NetrwShrink

" " Mapping for opening netrw in a directory of current file
" nnoremap <> :Lexplore %:p:h<CR>
" " Mapping for opening netrw in a working directory
" nnoremap <> :Lexplore<CR>

