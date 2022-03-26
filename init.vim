command Config :sp ~/.config/nvim/init.vim
 
nmap ,wc :! wc -w % <Enter>

" SynStack shows the highlight groups under the cursor
nmap ,i :call <SID>SynStack()<CR>

syntax enable " syntax on may overwrite custom rules
set number " line numbers
set hidden " allow jumping buffers without save

" sensible splits
set splitbelow
set splitright


" prints the active highlight groups under the cursor
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

set title

" polyglot overrides the sizes of tabs on a filetype basis actually
set expandtab
set shiftwidth=2
set softtabstop=2
 
"_______window switching shortcuts
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>
map <C-j> <C-w><Down>
map <C-k> <C-w><Up>

call plug#begin()
  Plug 'tpope/vim-sensible'             " some sensible defaults
  Plug 'sheerun/vim-polyglot'           " improved syntax highlight
  Plug 'itchyny/lightline.vim'
  Plug 'mileszs/ack.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'morhetz/gruvbox'
  Plug '~/Dropbox/repos/zett.vim'       " dev version of zettel functionality
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " Plug 'vim-airline/vim-airline'
  " Plug 'altercation/vim-colors-solarized'
  Plug 'junegunn/limelight.vim'       " highlights current § 
call plug#end()


set background=dark

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark="soft"
let g:gruvbox_contrast_light="soft"
let g:lightline = {'colorscheme': 'gruvbox'}


colorscheme gruvbox

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

