" Function to control line numbers display
function! ToggleLineNumbers()
    if(&relativenumber==1)
        set nonumber
        set norelativenumber
    elseif(&number==1)
        set relativenumber
    else
        set number
    endif
endfunction

" Functions for exploring syntax coloring.
" ':verbose highlight NAME' can tell where a color is defined.
function! InspectCharacterClass()
    :echo synIDattr(synID(line("."), col("."), 1), "name")
endfunction

function! InspectCharacterBackground()
    :echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "bg")
endfunction

function! InspectCharacterForeground()
    :echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")
endfunction

" Ability to delete buffers in vim.fzf
" From https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

