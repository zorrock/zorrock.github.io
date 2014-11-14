set nocompatible          "��Ҫ����vi
filetype off              "��������ã�

colorscheme torte

"Color Settings {
"set colorcolumn=85           "��ɫ��ʾ��85��
set t_Co=256                 "����256ɫ��ʾ
set background=dark          "ʹ��color solarized
set cursorline               "���ù�������ʾ
set cursorcolumn             "��괹ֱ����
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
"set number                                    "��ʾ�к�
"set undofile                                  "����undo
"set nowrap                                    "��ֹ�Զ�����
"autocmd! bufwritepost _vimrc source %         "�Զ����������ļ�����Ҫ����

"����к� Ҫ������к�������Ҫ������ʾ�кź���
"set relativenumber
"�Զ�����
set wrap
"GUI����������壬Ĭ���п����
set guifont=Consolas:h10
"��-���ӷ�Ҳ����Ϊ����
set isk+=-

set ignorecase "���ô�Сд���кʹ�����֪(Сдȫ�ѣ���д��ȫƥ��)
set smartcase
"set gdefault
set incsearch
set showmatch
set hlsearch

set numberwidth=4          "�к����Ŀ��
"set columns=135           "��ʼ���ڵĿ��
"set lines=50              "��ʼ���ڵĸ߶�
"winpos 620 45             "��ʼ���ڵ�λ��

set whichwrap=b,s,<,>,[,]  "���˸񣬿ո����¼�ͷ����������βʱ�Զ��Ƶ���һ�У�����insertģʽ��

"����ģʽ���ƶ�
imap <c-j> <down>
imap <c-k> <up>
imap <c-l> <right>
imap <c-h> <left>

"===================================================
"�޸�leader��Ϊ����
let mapleader=","
imap jj <esc>

"�޸�vim��������
nmap / /\v
vmap / /\v

"ʹ��tab��������%����ƥ����ת
nmap <tab> %
vmap <tab> %

"�۵�html��ǩ ,fold tag
nnoremap <leader>ft vatzf
"ʹ��,v��ѡ��ոո��ƵĶ��䣬����������������
nnoremap <leader>v v`]

"ʹ��,w����ֱ�ָ�ڣ���������ͬʱ�鿴����ļ�,�����ˮƽ�ָ���<c-w>s
nmap <leader>w <c-w>v<c-w>l
nmap <leader>wc <c-w>c
nmap <leader>ww <c-w>w

"tab�л�
nmap <leader>t gt
nmap <leader>r gT

"<leader>�ո���ٱ���
nmap <leader><space> :w<cr>

"ȡ����������
nmap <leader>n :noh<cr>

"html�е�js��ע�� ȡ��ע��
nmap <leader>h I//jj
nmap <leader>ch ^xx
"�л�����ǰĿ¼
nmap <leader>q :execute "cd" expand("%:h")<CR>
"�����滻
nmap <leader>s :,s///c

"ȡ��ճ������
nmap <leader>p :set paste<CR>
nmap <leader>pp :set nopaste<CR>

"�ļ������л�
"nmap <leader>fj :set ft=javascript<CR>
"nmap <leader>fc :set ft=css<CR>
"nmap <leader>fh :set ft=html<CR>
"nmap <leader>fm :set ft=mako<CR>

"��������gvim�Ĳ˵��͹����� F2�л�
"set guioptions-=m
"set guioptions-=T
"ȥ���������ߵĹ�����
set go-=r
set go-=L

"������Bundle�����ú󣬷�ֹ����BUG
filetype plugin indent on
syntax on
