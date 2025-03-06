" Color settings
"
"

set termguicolors
if &termguicolors
    let g:solarized_termtrans = 1
    colorscheme solarized8_flat
    highlight SpecialKey guibg=NONE
endif
" highlight TabLineFill term=bold cterm=bold
" highlight TablineSel term=bold,underline cterm=bold,underline
" highlight TabLine term=bold,none cterm=bold,none ctermbg=none ctermfg=none gui=bold,none guibg=NONE
" highlight Folded guibg=NONE
highlight LineNr ctermfg=59 guifg=#555555
highlight SpecialKey ctermfg=59 guifg=#555555
highlight NonText ctermfg=59 guifg=#555555

