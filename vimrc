" I've never used vi once in my life, before my time; it's ok to drop compatibility.
set nocompatible

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

" Map nerd-tree open/close to the ,nt key shortcut.
map ,nt :NERDTreeToggle<CR>

" Open nerd-tree automatically when Vim starts w/o specifying a directory.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endi

" Open nerd-tree automatically when Vim starts specifying a directory.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Close nerd-tree if the only window left open is nerd-tree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Change nerd-tree arrows.
let g:NERDTreeDirArrowExpandable = '˃'
let g:NERDTreeDirArrowCollapsible = '˅'

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" Auto-indent files.
filetype indent on
set smartindent

" Define a list of files that will be auto-indented.
autocmd BufRead,BufWritePre *.php normal gg=G

" Set the tab width to 4 spaces.
set tabstop=4

" Added by apt-vim, https://github.com/egalpin/apt-vim 
execute pathogen#infect()
call pathogen#helptags()
