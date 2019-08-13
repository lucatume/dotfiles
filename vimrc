" I've never used vi once in my life, before my time; it's ok to drop compatibility.
set nocompatible

" Disable swap files.
set noswapfile

" Enable syntax highlighting
syntax enable

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
