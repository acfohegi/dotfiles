" General
"
"

set path+=**
set wildignore+=**/node_modules/**

" Use the system clipboard
set clipboard=unnamed

let bckp_dir = expand('$HOME/.vim/backup')
let swp_dir = expand('$HOME/.vim/swp')
if isdirectory(bckp_dir)
    " The double trailing slash will make vim store files using full paths.
    set backupdir=$HOME/.vim/backup//
    set backup
else
    set nobackup
    echo "Warning: Backup directory does not exist. Backup is disabled."
endif
if isdirectory(swp_dir)
    " The double trailing slash will make vim store files using full paths.
    set directory=$HOME/.vim/swp//
    set swapfile
else
    set noswapfile
    echo "Warning: Swap directory does not exist. Swap saving is disabled."
endif

