" Plugins
"
"

" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
packadd! matchit

call plug#begin('~/.vim/plugged')
" Language support plugins
Plug 'preservim/vim-markdown', { 'for': 'markdown' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'digitaltoad/vim-pug', { 'for': 'pug' }
Plug 'MTDL9/vim-log-highlighting', { 'for': 'log' }
Plug 'tbastos/vim-lua', { 'for': 'lua' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'lunacookies/vim-sh', { 'for': 'sh' }
Plug 'slim-template/vim-slim', { 'for': 'slim' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
Plug 'amadeus/vim-xml', { 'for': 'xml' }
Plug 'pearofducks/ansible-vim', { 'for': 'yaml.ansible' }
Plug 'vim-jp/vim-cpp', { 'for': ['cpp', 'c'] }
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'dockerfile' }
Plug 'ericpruitt/tmux.vim', { 'rtp': 'vim/', 'for': 'tmux' }
Plug 'dense-analysis/ale'
" Other plugins
Plug 'tpope/vim-surround'
Plug 'wellle/context.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'simnalamburt/vim-mundo'
Plug 'lambdalisue/readablefold.vim'
Plug 'tpope/vim-vinegar'
Plug 'godlygeek/tabular'
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
if executable('fzf')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
endif
if executable('task')
  Plug 'vimwiki/vimwiki', { 'for': ['vimwiki', 'markdown'] }
  Plug 'tools-life/taskwiki', { 'for': ['vimwiki', 'markdown'] }
 endif
if executable('xkbswitch')
  Plug 'lyokha/vim-xkbswitch'
endif
call plug#end()

" Vimwiki settings
"
"
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/notes/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" Using md syntax for vimwiki. Changes folding and highlighting to ones
" provided by markdown plugin.
" Vimwiki by default allows folding only within a list and by indents that are
" equal to shiftwidth. Vimwiki highlighting has some trade-offs too.
au BufRead,BufWinEnter,BufNewFile *.md setlocal syntax=markdown
" No effect was found by this option. Vimwiki docs say that it should
" 'Allow folding options to be set by another plugin or a vim configuration
" file'. https://github.com/vimwiki/vimwiki/issues/1449
let g:vimwiki_folding = 'custom'

" Ale settings
"
"
let g:ale_virtualtext_cursor = 'current'
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_linters_ignore = ['cspell']
let g:ale_sign_column_always = 1

" Other settings
"
"
let g:XkbSwitchEnabled=1
let NERDTreeMinimalUI=1

