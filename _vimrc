set nocompatible          "不要兼容vi
filetype off              "必须的设置：

colorscheme torte

"Color Settings {
"set colorcolumn=85           "彩色显示第85行
set t_Co=256                 "设置256色显示
set background=dark          "使用color solarized
set cursorline               "设置光标高亮显示
set cursorcolumn             "光标垂直高亮
set ttyfast
set ruler
set backspace=indent,eol,start

"}

"tab setting {
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"}

set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set scrolloff=3
set fenc=utf-8
set autoindent
set hidden
set noswapfile
set nowritebackup
"set encoding=utf-8

"set laststatus=2
"set number                                    "显示行号
"set undofile                                  "无限undo
"set nowrap                                    "禁止自动换行
"autocmd! bufwritepost _vimrc source %         "自动载入配置文件不需要重启

"相对行号 要想相对行号起作用要放在显示行号后面
"set relativenumber
"自动换行
set wrap
"GUI界面里的字体，默认有抗锯齿
set guifont=Consolas:h10
"将-连接符也设置为单词
set isk+=-

set ignorecase "设置大小写敏感和聪明感知(小写全搜，大写完全匹配)
set smartcase
"set gdefault
set incsearch
set showmatch
set hlsearch

set numberwidth=4          "行号栏的宽度
"set columns=135           "初始窗口的宽度
"set lines=50              "初始窗口的高度
"winpos 620 45             "初始窗口的位置

set whichwrap=b,s,<,>,[,]  "让退格，空格，上下箭头遇到行首行尾时自动移到下一行（包括insert模式）

"插入模式下移动
imap <c-j> <down>
imap <c-k> <up>
imap <c-l> <right>
imap <c-h> <left>

"===================================================
"修改leader键为逗号
let mapleader=","
imap jj <esc>

"修改vim的正则表达
nmap / /\v
vmap / /\v

"使用tab键来代替%进行匹配跳转
nmap <tab> %
vmap <tab> %

"折叠html标签 ,fold tag
nnoremap <leader>ft vatzf
"使用,v来选择刚刚复制的段落，这样可以用来缩进
nnoremap <leader>v v`]

"使用,w来垂直分割窗口，这样可以同时查看多个文件,如果想水平分割则<c-w>s
nmap <leader>w <c-w>v<c-w>l
nmap <leader>wc <c-w>c
nmap <leader>ww <c-w>w

"tab切换
nmap <leader>t gt
nmap <leader>r gT

"<leader>空格快速保存
nmap <leader><space> :w<cr>

"取消搜索高亮
nmap <leader>n :noh<cr>

"html中的js加注释 取消注释
nmap <leader>h I//jj
nmap <leader>ch ^xx
"切换到当前目录
nmap <leader>q :execute "cd" expand("%:h")<CR>
"搜索替换
nmap <leader>s :,s///c

"取消粘贴缩进
nmap <leader>p :set paste<CR>
nmap <leader>pp :set nopaste<CR>

"文件类型切换
"nmap <leader>fj :set ft=javascript<CR>
"nmap <leader>fc :set ft=css<CR>
"nmap <leader>fh :set ft=html<CR>
"nmap <leader>fm :set ft=mako<CR>

"设置隐藏gvim的菜单和工具栏 F2切换
"set guioptions-=m
"set guioptions-=T
"去除左右两边的滚动条
set go-=r
set go-=L

"放置在Bundle的设置后，防止意外BUG
filetype plugin indent on
syntax on
