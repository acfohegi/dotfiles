" Controls
"
"

let mapleader = " "
noremap <C-n> :call ToggleLineNumbers()<CR>
noremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>mt :MundoToggle<CR>

if executable('fzf')
  noremap <C-p> :Files<CR>
else
  noremap <C-p> :echo "FZF not installed!"<CR>
endif

" Backspace can delete indenting, end of line, start of line
set backspace=indent,eol,start

" Cursor keys, backspace and space can be used to move to next or previous
" line horizontally
set whichwrap=<,>,[,],b,s

" Persist selection after indenting
vnoremap > >gv
vnoremap < <gv

" Remap to <Esc> to fire InsertLeave event for
" correct XkbSwitch work and visual block mode
imap <C-c> <Esc>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Vimwiki
"
"
" Jump straight to editable properties
autocmd FileType vimwiki nnoremap <Leader>te :TaskWikiEdit<CR>24j
" https://github.com/vimwiki/vimwiki/issues/1449
autocmd FileType vimwiki nnoremap <silent><buffer> o A<C-o>:VimwikiReturn 1 1<CR>
autocmd FileType vimwiki nnoremap <silent><buffer> O A<C-o>:VimwikiReturn 1 1<CR><C-o>:m-2<CR><C-o>$

