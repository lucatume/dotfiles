" Start here and clone Vundle, then run :PluginInstall
command InstallVundle !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

" I've never used vi once in my life, before my time; it's ok to drop compatibility.
set nocompatible

" Disable swap files.
set noswapfile

" Enable syntax highlighting.
syntax enable

" Allow backspacing over auto-indent, end-of-line and to the start of insert.
set backspace=indent,eol,start

" Enable the built-in filetype plugin.
filetype plugin on

" Remap jj to Esc as it's my go-to way of getting out of insert mode.
:imap jj <Esc>
" Remap jk to Esc for even greater speed.
:imap jk <Esc>

" Recursively search from the root folder.
set path+=**

" Use a menu to find the files.
set wildmenu

" Show the line numbers.
set nu

" Type MakeTags in the vim command to create the `tags` for the current code base.
command! MakeTags !ctags -R .

" Auto-indent files.
filetype indent on
set smartindent

" Define a list of files that will be auto-indented.
" autocmd BufRead,BufWritePre *.php normal gg=G

" Set the tab width to 4 spaces.
set tabstop=4

" netrw tweaks.
"
" Disable the top banner.
let g:netrw_banner=0
" Open in prior window.
let g:netrw_browse_split=4
" Open splits to the right.
let g:netrw_altv=1
" Tree view.
let g:netrw_liststyle=3
" Ignore/hide settings.
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:netrw_browse_split = 4
" Set the horizontal size of the netrw tree explorer.
let g:netrw_winsize = 25

" GUI settings
set guifont=Monaco:16

" If Vundle is available, then load and use it.
" Install with: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" Then :PluginInstall to install the plugins below.
if isdirectory(expand('~/.vim/bundle/Vundle.vim'))
		" set the runtime path to include Vundle and initialize
		set rtp+=~/.vim/bundle/Vundle.vim
		call vundle#begin()
		" alternatively, pass a path where Vundle should install plugins
		"call vundle#begin('~/some/path/here')

		" let Vundle manage Vundle, required
		Plugin 'VundleVim/Vundle.vim'

		" Vundle managed plugins
		Plugin 'vim-airline/vim-airline'
		Plugin 'vim-airline/vim-airline-themes'
		Plugin 'arcticicestudio/nord-vim'
		Plugin 'ericbn/vim-solarized'
		Plugin 'lifepillar/vim-solarized8'
		Plugin 'herrbischoff/cobalt2.vim'
		Plugin 'gertjanreynaert/cobalt2-vim-theme'
		Plugin 'scrooloose/syntastic'
		Plugin 'tpope/vim-commentary'
		Plugin 'morhetz/gruvbox'
		Plugin 'tomtom/ttodo_vim'
		Plugin 'craigemery/vim-autotag'

		" All of your Plugins must be added before the following line
		call vundle#end()            " required
		filetype plugin indent on    " required
		" To ignore plugin indent changes, instead use:
		"filetye plugin on
		"
		" Brief help
		" :PluginList       - lists configured plugins
		" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
		" :PluginSearch foo - searches for foo; append `!` to refresh local cache
		" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
		"
		" see :h vundle for more details or wiki for FAQ
		" Put your non-Plugin stuff after this line

		" Activate the nord color scheme if Vundle is active.
		" colorscheme nord
		"
		" Or the solarized one.
		" https://github.com/ericbn/vim-solarized
		
		" morhetz/gruvbox specific settings	
		" See https://github.com/morhetz/gruvbox/wiki/Configuration#ggruvbox_contrast_darkj:w
		let g:gruvbox_contrast_light = "light"
		let g:gruvbox_contrast_dark = "light"
        let g:gruvbox_termcolors = 256

		colorscheme gruvbox 
		set background=dark
		set termguicolors
	
		" Set up some reasonable defaults for syntastic.
		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*

		let g:syntastic_always_populate_loc_list = 1
		let g:syntastic_auto_loc_list = 1
		let g:syntastic_check_on_open = 1
		let g:syntastic_check_on_wq = 0
		let g:syntastic_auto_jump = 1
endif

" Commands to manage and interact with todo.txt/taskpaper format files.
command Done s/^\(\t\+\)-/\1+/g | s/$/ @done/g
command Undone s/^\(\t\+\)+/\1-/g | s/\s*@done//g

" Find the configuration file for a sniffer/linter.
" Note: the `prefix` must contain required spaces, e.g. `-c ` for jscs.
function! FindCheckerConfig(prefix, what, where)
		let cfg = findfile(a:what, escape(a:where, '') . ';')
		return cfg !=# '' ? ' ' . a:prefix . shellescape(cfg) : ''
endfunction		

autocmd FileType php let b:syntastic_php_phpcs_args = 
	\ get(g:, 'syntastic_php_phpcs_args', '') .
	\ FindCheckerConfig('-s --standard=', 'phpcs.xml', expand('<afile>:p:h', 1))

" let g:syntastic_php_checkers = ["php", "phpcs", "phpmd"]
let g:syntastic_php_checkers = ["php", "phpcs"]

" Allow per-project configuration files.
set exrc
" But make sure we're not running unsafe commands from those files.
set secure

" If the dracula_pro theme is installed, then install it.
if isdirectory(expand('~/.vim/pack/themes/start/dracula_pro'))
		packadd! dracula_pro
		let g:dracula_colorterm = 0
		colorscheme dracula_pro_blade
endif

" Set up GUI versions of vim
set linespace=16
set guifont=Monaco:h15
