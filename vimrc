" NOTE: something maybe outdated, e.g. for GVim, for Windows, for GVim in Windows

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

source $VIMRUNTIME/menu.vim

if has("win32")
  source $VIMRUNTIME/mswin.vim
  behave mswin

  source $VIM/vimmailr.vim
endif

set autoindent
set autoread
set backspace=indent,eol,start "set backspace=2
set nobackup
set nowritebackup
"set cmdheight=2
"set cpo-=<
set nocompatible
set nocursorline
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set nohidden
set history=5000
if has("gui_running")
  "set imdisable
  if ! has("win32")
    set iminsert=2
    set imsearch=2
  endif
  set noimcmdline
endif
set incsearch
set keywordprg=man\ -a
set laststatus=2
if has("gui_running")
  set lines=32
endif
"set linebreak
set maxmempattern=5000
if has("gui_running")
  set mouse=a
else
  set mouse=
endif
set modeline
set modelines=5 "" the default value
set redrawtime=5000
set ruler
set scrolloff=2 "like in emacs
set selectmode=key
if has("gui_running")
  set selectmode+=mouse
endif
set selection=inclusive
"set shiftwidth=4
set showcmd
set showmatch
"set softtabstop=4
set statusline=[%n]%<%f%y%h%m%r%=[%b\ 0x%B]\ %l\ of\ %L,%c%V\ Page\ %N\ %P
if has ("win32")
  set tags=./tags,./TAGS,tags,TAGS,../tags
else
  set tags=./tags,./TAGS,tags,TAGS,/usr/include/tags,../tags
endif
let &termencoding=&encoding
set viminfo='5000,\"50
set novisualbell t_vb=
set wildcharm=<C-Z>
set wildmenu
set wildmode=longest,list,full

let g:html_indent_inctags="html,body,head,tbody"

"language en_US

" Don't use Ex mode, use Q for formatting
noremap Q gq

nnoremap ,ge :%!gpg -eq -a -r FA45E8DAF25DA40EFBF7478E971613805F04A298 2>/dev/null<CR>
nnoremap ,gd :%!gpg -dq 2>/dev/null<CR>
nnoremap ,gpg :%!gpg
nnoremap <silent> ,f :set invfoldenable<CR>
nnoremap <silent> ,n :set invnumber<CR>
nnoremap <silent> ,p :set paste!<Bar>set paste?<CR>
nnoremap <silent> ,m :marks<CR>
nnoremap <silent> ,/ :let @/=""<CR>
" noremap <silent> ,s :Startify<CR>
nnoremap <silent> ,, ,

"see :help motion.txt
noremap <C-N>f f
noremap <C-N>F F
noremap <C-N>t t
noremap <C-N>T T

nnoremap ff <C-W>_
nnoremap fr <C-W>w<C-W>_
nnoremap fR <C-W>W<C-W>_
nnoremap f+ <C-W>+
nnoremap f- <C-W>-
nnoremap f< <C-W><
nnoremap f> <C-W>>
nnoremap f= <C-W>=
nnoremap fo <C-W>o
nnoremap fn <C-W>w
nnoremap fp <C-W>W
nnoremap fN <C-W>n
nnoremap <silent> fV :vertical new<CR>
nnoremap fs <C-W>s
nnoremap fv <C-W>v
nnoremap fx <C-W>x
nnoremap f] <C-W><C-]>
nnoremap f} <C-W>}

nnoremap <silent> fK <C-W>K
nnoremap <silent> fJ <C-W>J
nnoremap <silent> fH <C-W>H
nnoremap <silent> fL <C-W>L

nnoremap <silent> fk <C-W>k
nnoremap <silent> fj <C-W>j
nnoremap <silent> fh <C-W>h
nnoremap <silent> fl <C-W>l
nnoremap <silent> ft <C-W>T

nnoremap <silent> tN :tabnew<CR>
" Open a new tab page and edit the file name under the cursor
nnoremap <silent> tf <C-W>gf
" Open a new tab page and edit the file name under the cursor
"    and jump to the line number following the file name.
nnoremap <silent> tF <C-W>gF
nnoremap <silent> tc :tabclose<CR>
nnoremap <silent> to :tabonly<CR>
" go to the previous tab page, like gt
nnoremap <silent> tp :tabprevious<CR>
" go to the previous tab page, like gt
nnoremap <silent> th :tabprevious<CR>
" go to the next tab page, like gT
nnoremap <silent> tn :tabnext<CR>
" go to the next tab page, like gT
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> ts :tabs<CR>
nnoremap <silent> <A-Left> :tabprevious<CR>
nnoremap <silent> <A-Right> :tabnext<CR>
nnoremap <silent> tL :+tabmove<CR>
nnoremap <silent> tH :-tabmove<CR>
nnoremap <silent> t0 :tabfirst<CR>
nnoremap <silent> t$ :tablast<CR>
nnoremap <silent> tm0 :0tabmove<CR>
nnoremap <silent> tm$ :$tabmove<CR>
" move the tab page after the last accessed tab page
nnoremap <silent> tm# :tabmove #<CR>
" Go to the last accessed tab page.
nnoremap <silent> tt g<Tab>

nnoremap <silent> fbb :buffers<CR>
nnoremap <silent> fbd :bdelete<CR>
nnoremap <silent> fbp :bprevious<CR>
nnoremap <silent> fbn :bnext<CR>
nnoremap <silent> fbf :bfirst<CR>
nnoremap <silent> fbl :blast<CR>

nnoremap fcom0 I/* <Esc>A */<Esc>
nnoremap f*# kxjphxkP "Exchange the character under cursor with the one above

" Alt-Up & Alt-Down to scroll other window
if has("gui_running")
  noremap <silent> <M-Up> <C-W>p<C-Y><C-W>p
  noremap <silent> <M-Down> <C-W>p<C-E><C-W>p
"else
"  noremap <silent> OA <C-W>p<C-E><C-W>p
"  noremap <silent> OB <C-W>p<C-Y><C-W>p
endif

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w<C-W>_
inoremap <C-Tab> <C-O><C-W>w<C-W>_
cnoremap <C-Tab> <C-C><C-W>w<C-W>_

noremap <C-S-Tab> <C-W>W<C-W>_
inoremap <C-S-Tab> <C-O><C-W>W<C-W>_
cnoremap <C-S-Tab> <C-C><C-W>W<C-W>_

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c

" To use Mouse Wheel
"if has("gui_running")
"	:map <M-Esc>[62~ <MouseDown>
"	:map! <M-Esc>[62~ <MouseDown>
"	:map <M-Esc>[63~ <MouseUp>
"	:map! <M-Esc>[63~ <MouseUp>
"	:map <M-Esc>[64~ <S-MouseDown>
"	:map! <M-Esc>[64~ <S-MouseDown>
"	:map <M-Esc>[65~ <S-MouseUp>
"	:map! <M-Esc>[65~ <S-MouseUp>
"endif

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp
" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>


"""
" from https://stackoverflow.com/a/53930943/4917658
nnoremap <silent> <C-N>s :call ToggleSignColumn()<CR>

" Toggle signcolumn. Works on vim>=8.1 or NeoVim
function! ToggleSignColumn()
  if !exists("b:signcolumn_on") || b:signcolumn_on
    set signcolumn=no
    let b:signcolumn_on=0
  else
    set signcolumn=number
    let b:signcolumn_on=1
  endif
endfunction
"""

"iab xtime <C-R>=strftime("%m/%d/%y %H:%M:%S")<CR>
"iab xfulltime <C-R>=strftime("%a %d %b %Y %I:%M:%S %p")<CR>
"iab xdate <C-R>=strftime("%b %d, %Y")<CR>
"iab xdatestamp <C-R>=strftime("%m,%d,%Y")<CR>

if has("gui_running")
  set columns=112
  set lines=36

  " Make external commands work through a pipe instead of a pseudo-tty
  set guipty
  "set noguipty

  let &guioptions = substitute(&guioptions, "T", "", "g")
  let &guioptions = substitute(&guioptions, "m", "", "g")

  if has("win32")
    " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
    let &guioptions = substitute(&guioptions, "t", "", "g")

    map <C-N>X :simalt ~x<CR>
    map <C-N>N :simalt ~n<CR>
    map <C-N>R :simalt ~r<CR>
  endif

"  if has("win32")
"    set guifont=新宋体:h12:cGB2312
"  elseif has("gui_running")
"    set guifont=8x16
"    "set guifontwide=hanzigb16fs,hanzigb24fs
"    "set guifontset=hanzigb16fs,hanzigb24fs,8x16
"    "set guifont=-misc-simsun-medium-r-normal-*-*-160-*-*-p-80-gb2312.1980-0
"    "set guifontwide=-misc-simsun-medium-r-normal-*-*-160-*-*-p-80-gb2312.1980-0
"    "set guifont=8x16
"    set imactivatekey=C-space
"  endif
  set guioptions+=a
  set guicursor=n-v-c:hor15-Cursor/lCursor,ve:blank-Cursor,o:hor25-Cursor,i-ci:ver40-Cursor/lCursor,r-cr:hor100-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  if has("terminfo")
    set t_Co=256
    set t_AF=<Esc>[%?%p1%{8}%<%t22;%p1%{30}%+%e1;%p1%{22}%+%;%dm
    set t_AB=<Esc>[%?%p1%{8}%<%t25;%p1%{40}%+%e5;%p1%{32}%+%;%dm
    "set t_AF=<Esc>[%?%p1%{8}%<%t3%p1%d%e%p1%{22}%+%d;1%;m
    "set t_AB=<Esc>[%?%p1%{8}%<%t4%p1%d%e%p1%{32}%+%d;1%;m
    set term=xterm-256color
    set background=dark
  else
    set t_Co=16
    set t_Sf=<Esc>[3%dm
    set t_Sb=<Esc>[4%dm
    set background=dark
  endif
  set hlsearch
  syntax on
endif

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " For Win32 version, have "K" lookup the keyword in a help file
  if has("win32")
    let winhelpfile='windows.hlp'
    map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  endif

  " Hide the mouse pointer while typing
  if has("gui_running")
    set mouse=a
    set mousehide
  endif

  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green
  " Constants are not underlined but have a slightly lighter background
"  highlight Normal guibg=#000040 guifg=#ffffc0
"  highlight Cursor guibg=Yellow guifg=NONE
"  highlight NonText guibg=#000040
"  highlight Constant gui=NONE guibg=#000040
"  highlight Special gui=NONE guibg=#000040
"  highlight Comment gui=NONE guifg=#00ffff
"  highlight Folded gui=NONE guibg=Navy
"  highlight Todo guibg=Yellow guifg=#000040
"  highlight Search guibg=#8080ff
  highlight Normal guibg=#000000 guifg=#ffffc0
  highlight Cursor guibg=Yellow guifg=NONE
  highlight NonText guibg=#000000
  highlight Constant gui=NONE guibg=#000000
  highlight Special gui=NONE guibg=#000000
  highlight Comment gui=NONE guifg=#00ffff
  highlight Folded gui=NONE guibg=Navy
  highlight Todo guibg=Yellow guifg=#000000
  highlight Search guibg=#8080ff
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  if has("gui")
    set cursorline cursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
    autocmd WinLeave * set nocursorline nocursorcolumn
  else
    set cursorline cursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
    autocmd WinLeave * set nocursorline nocursorcolumn
  endif

  " Enable file type detection.

  " load view saved by the mkview command
  autocmd FileType * if @% != "" | loadview | endif
  autocmd FileType * set noexpandtab
  autocmd BufWinEnter * if @% != "" | loadview | endif

  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

 " In text files, always limit the width of text to 78 characters
  "autocmd BufEnter *.txt set filetype=text textwidth=78 expandtab shiftwidth=4 softtabstop=4
  autocmd FileType dot set shiftwidth=4 expandtab softtabstop=4
  "autocmd FileType text set textwidth=78 expandtab softtabstop=4
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
			  \ if line("'\"") > 0 && line("'\"") <= line("$") |
			  \   execute "normal g`\"" |
			  \ endif

  augroup prog
    " Remove all cprog autocommands
    autocmd!

    " When starting to edit a file:
    "   For C and C++ files set formatting of comments and set C-indenting on.
    "   For other files switch it off.
    "   Don't change the order, it's important that the line with * comes first.
    autocmd FileType *          set formatoptions=tcoql nocindent comments&

    autocmd FileType c,cpp      set omnifunc=syntaxcomplete#Complete
    autocmd FileType xhtml,html set omnifunc=syntaxcomplete#Complete
    autocmd FileType css        set omnifunc=syntaxcomplete#Complete
    autocmd FileType javascript set omnifunc=syntaxcomplete#Complete
    autocmd FileType php        set omnifunc=syntaxcomplete#Complete
    autocmd FileType python     set omnifunc=syntaxcomplete#Complete
    autocmd FileType ruby       set omnifunc=syntaxcomplete#Complete
    autocmd FileType sql        set omnifunc=syntaxcomplete#Complete
    autocmd FileType xml        set omnifunc=syntaxcomplete#Complete

    autocmd FileType go         set omnifunc=syntaxcomplete#Complete
    autocmd FileType sh         set omnifunc=syntaxcomplete#Complete
    autocmd FileType zsh        set omnifunc=syntaxcomplete#Complete
    autocmd FileType vue        set omnifunc=syntaxcomplete#Complete
    autocmd FileType perl       set omnifunc=syntaxcomplete#Complete
    autocmd FileType java,jsp   set omnifunc=syntaxcomplete#Complete

    "autocmd BufWinLeave *.sh,*.zsh,*.c,*.cpp,*.perl,*.py mkview
    "autocmd BufWinEnter *.sh,*.zsh,*.c,*.cpp,*.perl,*.py silent loadview

    function! CleverTab()
      if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
      else
        return "\<C-N>"
    endfunction

    autocmd FileType c,cpp,sh,zsh,perl,python set fileformat=unix

    autocmd FileType c,cpp  noremap! <S-Tab> <C-R>=CleverTab()<CR>
    "" " Tag completion
    "" autocmd FileType c,cpp  noremap! <C-]> <C-X><C-]>
    "" " Filename completion
    "" autocmd FileType c,cpp  noremap! <C-F> <C-X><C-F>
    "" " Search in the current and included files for the
    "" "     first definition (or macro) name that starts with
    "" "     the same characters as before the cursor.  The found
    "" "     definition name is inserted in front of the cursor.
    "" autocmd FileType c,cpp  noremap! <C-D> <C-X><C-D>
    "" " Search backwards for a line that starts with the
    "" "     same characters as those in the current line before
    "" "     the cursor.  Indent is ignored.  The matching line is
    "" "     inserted in front of the cursor.
    "" "     The 'complete' option is used to decide which buffers
    "" "     are searched for a match.  Both loaded and unloaded
    "" "     buffers are used.
    "" autocmd FileType c,cpp  noremap! <C-L> <C-X><C-L>

    "autocmd FileType sh     set formatoptions=croql cindent autoindent comments=b:#
    autocmd FileType sh     set expandtab tabstop=8 shiftwidth=4 expandtab softtabstop=4 autoindent smartindent
    autocmd FileType zsh     set expandtab tabstop=8 shiftwidth=4 expandtab softtabstop=4 autoindent smartindent

    autocmd FileType c,cpp  set formatoptions=croql autoindent cindent smartindent comments=sr:/*,mb:*,el:*/,://
    "autocmd FileType c,cpp  set foldmethod=marker foldmarker=--fb--{{{,--fe--}}} commentstring=\ //\ %s
    autocmd FileType c,cpp  set foldmethod=marker foldmarker={,} commentstring=\ //\ %s
    autocmd FileType c,cpp  set nowrap
    "autocmd FileType c,cpp  set shiftwidth=4 expandtab softtabstop=4
    autocmd FileType c,cpp  set shiftwidth=8 noexpandtab softtabstop=8
    "autocmd BufEnter *.h,*.c,*.cc,*.cpp set shiftwidth=4 expandtab softtabstop=4
    ""autocmd BufEnter *.h,*.c,*.cc,*.cpp set shiftwidth=8 noexpandtab softtabstop=8

    autocmd FileType markdown set nowrap shiftwidth=4 expandtab softtabstop=4 autoindent smartindent

    autocmd FileType go set shiftwidth=8 noexpandtab softtabstop=8 autoindent smartindent
    autocmd BufEnter *.go set shiftwidth=8 noexpandtab softtabstop=8 autoindent smartindent
    autocmd FileType vue set shiftwidth=2 expandtab smartindent
    autocmd BufEnter *.vue set shiftwidth=2 expandtab smartindent

    "autocmd FileType java,jsp set shiftwidth=4 expandtab softtabstop=8 softtabstop=4 autoindent smartindent
    autocmd FileType java,jsp set shiftwidth=8 noexpandtab softtabstop=8 softtabstop=8 autoindent smartindent
    "autocmd BufEnter *.java,*.jsp set shiftwidth=4 expandtab tabstop=8 softtabstop=4 autoindent smartindent
    autocmd BufEnter *.java,*.jsp set shiftwidth=8 noexpandtab tabstop=8 softtabstop=8 autoindent smartindent

    "autocmd BufEnter *.inc,*.php set filetype=php expandtab tabstop=8 shiftwidth=4 autoindent smartindent softtabstop=4
    autocmd FileType php set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent

    autocmd FileType typescriptreact set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent
    autocmd BufEnter *.tsx set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent

    autocmd FileType html,xml set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent
    "autocmd BufEnter *.html,*.xml set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent

    "autocmd FileType perl   set formatoptions=croql cindent comments=b:#
    autocmd FileType python set formatoptions=croql cindent comments=b:#
    autocmd FileType python set foldmethod=indent
    autocmd FileType python set nowrap
    autocmd FileType python set shiftwidth=4 expandtab softtabstop=4 tabstop=8

    autocmd FileType typescript,javascript,css,sass,less  set formatoptions=croql autoindent cindent smartindent comments=sr:/*,mb:*,el:*/,://
    autocmd FileType typescript,javascript,css,sass,less  set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent
    autocmd FileType javascript  set foldmethod=marker foldmarker={,} commentstring=\ //\ %s
    autocmd FileType typescript set regexpengine=0 " set re=0, to prevent typescript syntax highlighting slow
    autocmd FileType css,scss,sass,less  set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent
    autocmd BufEnter *.css,*.scss,*.sass,*.less  set shiftwidth=4 expandtab softtabstop=4 autoindent smartindent
    autocmd FileType json,jsonc set shiftwidth=2 expandtab softtabstop=2 autoindent smartindent
    autocmd BufEnter *.json  set shiftwidth=2 expandtab softtabstop=2 autoindent smartindent

    autocmd FileType yaml set shiftwidth=2 expandtab softtabstop=2
    "autocmd FileType ruby set shiftwidth=4 expandtab softtabstop=4
    "autocmd FileType eruby set shiftwidth=4 expandtab softtabstop=4
    "autocmd FileType sql set shiftwidth=8 expandtab softtabstop=4

    "" AdonisJS Edge template file
    autocmd BufEnter *.edge set shiftwidth=4 expandtab softtabstop=4
  augroup END

endif " has("autocmd")

"" function MyTabLine()
""   let s = ''
""   for i in range(tabpagenr('$'))
""     " select the highlighting
""     if i + 1 == tabpagenr()
""       let s .= '%#TabLineSel#'
""     else
""       let s .= '%#TabLine#'
""     endif
""
""     " set the tab page number (for mouse clicks)
""     let s .= '%' . (i + 1) . 'T'
""
""     " the label is made by MyTabLabel()
""     let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
""   endfor
""
""   " after the last tab fill with TabLineFill and reset tab page nr
""   let s .= '%#TabLineFill#%T'
""
""   " right-align the label to close the current tab page
""   if tabpagenr('$') > 1
""     let s .= '%=%#TabLine#%999Xclose'
""   endif
""
""   return s
"" endfunction

if has("gui")
  function GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
      if getbufvar(bufnr, "&modified")
        let label = '+'
        break
      endif
    endfor

    " Append the number of windows in the tab page if more than one
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
      let label .= wincount
    endif
    if label != ''
      let label .= ' '
    endif

    " Append the buffer name
    return label . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  endfunction

  set guitablabel=%{GuiTabLabel()}

endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
			  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"call plug#begin('~/.vim/bundle')
call plug#begin('~/.vim/plugged')
  " Code to execute when the plugin is lazily loaded on demand
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
  autocmd! User goyo.vim echom 'Goyo is now loaded!'
  
  "" " Any valid git URL is allowed
  "" "Plug 'https://github.com/junegunn/vim-github-dashboard.git'
  "" need ruby support for vim, to check this, execute :echo has('ruby')
  "" Plug 'junegunn/vim-github-dashboard'
  "" " Default configuration for public GitHub
  "" let g:github_dashboard = { 'username': 'harrozze' }
  
  "Plug 'tpope/vim-pathogen'
  "execute pathogen#infect()
  "call pathogen#helptags()

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  "let g:airline_section_b = '%-0.20{getcwd()}'
  autocmd VimEnter * let g:airline_section_z="[%b\ 0x%B]" . g:airline_section_z

  Plug 'preservim/nerdtree'
  nnoremap <silent> <C-T>n :NERDTree<CR>
  nnoremap <silent> <C-T>t :NERDTreeToggle<CR>
  
  Plug 'mileszs/ack.vim'
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
  
  Plug 'godlygeek/tabular'
  
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-fugitive'
  "Plug 'gregsexton/gitv', { 'on': ['Gitv'] }
  Plug 'mhinz/vim-signify'
  
  Plug 'skywind3000/vim-auto-popmenu'
  
  " enable this plugin for filetypes, '*' for all files.
  let g:apc_enable_ft = { 'text':1, 'markdown':1, 'php':1, 'python':1, 'c':1, 'javascript':1, }
  
  " source for dictionary, current or other loaded buffers, see ':help cpt'
  set cpt=.,k,w,b
  
  " don't select the first item.
  set completeopt=menu,menuone,noselect
  
  " suppress annoy messages.
  set shortmess+=c
  
  Plug 'skywind3000/vim-dict'

  Plug 'yegappan/taglist'
  nnoremap <silent> ftl :TlistToggle<CR>

  Plug 'skywind3000/asyncrun.vim'
  Plug 'dense-analysis/ale'
  let g:ale_fixers = {
        \ '*': ['remove_trailing_lines', 'trim_whitespace'],
        \ 'javascript': ['eslint']
        \ }
  let g:ale_python_flake8_options = '--ignore=E501'          " ignore E501: line too long

  Plug 'fatih/vim-go'
  Plug 'posva/vim-vue'
  Plug 'leafOfTree/vim-vue-plugin'

  Plug 'airblade/vim-gitgutter', { 'branch': 'main' }
  nnoremap ghs <Plug>(GitGutterStageHunk)
  nnoremap ghu <Plug>(GitGutterUndoHunk)
  "call gitgutter#highlight#line_enable()
  nnoremap <silent> ,h :GitGutterLineHighlightsToggle<CR>

  Plug 'wolfgangmehner/lua-support'

  Plug 'github/copilot.vim', { 'branch': 'release' }
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true

  if filereadable(glob('~/.vimrc.d/vimrc.plug.local'))
    source  ~/.vimrc.d/vimrc.plug.local
  endif

  Plug 'ziglang/zig.vim'
  let g:zig_fmt_autosave = 1

  Plug 'mcchrish/nnn.vim'
  nnoremap <C-N>e :NnnExplorer<CR>
  nnoremap <C-N>p :NnnPicker<CR>


  "Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
  "Plug 'voldikss/clap-floaterm'
  "Plug 'voldikss/vim-floaterm'

  Plug 'wakatime/vim-wakatime'

  Plug 'tpope/vim-obsession'
call plug#end()

" if !exists('g:airline_section_z')
"   if airline#util#winwidth() > 80
"     let g:airline_section_z = "[%b\ 0x%B]" . airline#section#create(['windowswap', 'obsession', '%3p%%'.spc, 'linenr', 'maxlinenr', spc.':%3v'])
"   else
"     let g:airline_section_z = "[%b\ 0x%B]" . airline#section#create(['%3p%%'.spc, 'linenr', ':%3v'])
"   endif
" endif

if filereadable(glob('~/.vimrc.d/vimrc.local'))
  source  ~/.vimrc.d/vimrc.local
endif

" vim: shiftwidth=2 expandtab softtabstop=8 tabstop=8
