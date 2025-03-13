command Config :e ~/.config/nvim/init.vim
 
" more quickly make a checkbox
let logpath = '/Users/einar/Library/CloudStorage/Dropbox/knowledge/log.txt'
function Logsettings()
  iabbrev [  [ ]
  call search('LOG')
endfunction
execute 'autocmd BufRead,BufNewFile ' . logpath . ' call Logsettings()'

" even more quickly make a checkbox
nmap ,[ A<CR><Esc>C[ ] 
"
" check a checkbox
nmap ,c :silent! s/\[ \]/\[x\]/g<CR>:noh<CR>:echo ''<CR>j

" wordcount
nmap ,wc :! wc -w % <Enter>

" SynStack shows the highlight groups under the cursor
nmap ,i :call <SID>SynStack()<CR>

" huge protip by Anders
imap jj <Esc>

" don't treat broken lines as one thing when moving in norm mode
nmap j gj
nmap k gk

" if you want to yank to clipboard insteaed of the "* buffer
"set clipboard+=unnamed

set number            " line numbers
set hidden            " allow jumping buffers without save

" sensible splits
set splitbelow
set splitright

" line 80 marker; don't seem to work with miasma
set colorcolumn=80


" prints the active highlight groups under the cursor
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

set title

" might want to have this on a filetype basis
set expandtab
set shiftwidth=2
set softtabstop=2
 
"_______window switching shortcuts
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>
map <C-j> <C-w><Down>
map <C-k> <C-w><Up>

call plug#begin()
"   Plug 'morhetz/gruvbox'                " color schemes
"   Plug 'xero/miasma.nvim'
"   Plug 'savq/melange-nvim'
"   Plug 'rebelot/kanagawa.nvim'
"   Plug 'jaredgorski/fogbell.vim'
"   Plug 'jeffkreeftmeijer/vim-dim'       " dim and noctu use the 16 terminal cols
"   Plug 'noahfrederick/vim-noctu'
"   Plug 'Matsuuu/pinkmare'
"   Plug 'zenbones-theme/zenbones.nvim'   " https://vimcolorschemes.com/zenbones-theme/zenbones.nvim
"   Plug 'rktjmp/lush.nvim',
"   Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'sainnhe/everforest'


  Plug 'tpope/vim-sensible'             " some sensible defaults
  Plug 'junegunn/goyo.vim'              " focus mode
  Plug 'junegunn/limelight.vim'         " highlights current §
  Plug '~/Dropbox/repos/zett.vim'       " dev version of zettel functionality
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'               " search of various sorts
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}   " R.nvim needs this
  Plug 'David-Kunz/treesitter-unit'
  Plug 'karoliskoncevicius/vim-sendtowindow'
  " Plug 'Olical/conjure'    " looks nice for lisps. can we get it to do R?
call plug#end()

" To map <Esc> to exit terminal-mode: 
tnoremap <Esc> <C-\><C-n>

" autocmd TermOpen * let g:last_term=&channel
"

" treesitter units
xnoremap iu :lua require"treesitter-unit".select()<CR>
xnoremap au :lua require"treesitter-unit".select(true)<CR>
onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>

" treesitter takes its config in lua apparently
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = '<CR>',
    scope_incremental = false,
    node_incremental = '<CR>',
    node_decremental = '<S-CR>',
  },
},
}

EOF

" add stan parser to treesitter. note that you have to get the query files
" from that repo and put them in ~/.config/nvim/queries/stan/
lua << EOF
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.stan = {
  install_info = {
    url = 'https://github.com/WardBrian/tree-sitter-stan',
    files = { 'src/parser.c' }, 
    branch = 'main',
  },
}

vim.filetype.add {
  extension = { stan = 'stan' },
} 
EOF

lua << EOF
vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})
EOF

colorscheme everforest

" need to think about this: I use J for joining text lines
" nmap L <Plug>SendRight
" xmap L <Plug>SendRightV
" nmap H <Plug>SendLeft
" xmap H <Plug>SendLeftV
" nmap K <Plug>SendUp
" xmap K <Plug>SendUpV
" nmap J <Plug>SendDown
" xmap J <Plug>SendDownV
nmap <Space><Space> V<Space>j

" I don't like getting into the jump list of previous sessions
autocmd VimEnter * :clearjumps

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

