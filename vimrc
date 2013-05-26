"
""""""""""""""""""""""""""""""""""""""""" Generic VIM settings
set ts=2
set tm=500
set t_vb=
set autoindent
set autoread
set lbr
set showcmd
set nocompatible
set backspace=indent,eol,start
set history=100
set showtabline=2
set ruler                " show cursor
set nohidden
set nowrap
set number
set shiftwidth=2         " number of spaces to use for autoindenting
set softtabstop=2
set shiftround           " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch            " set show matching parenthesis
set ignorecase           " ignore case when searching
set smartcase            " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab             " insert tabs on the start of a line according to shiftwidth, not tabstop
set expandtab            " spaces instead tabs
set title                " change the terminal's title
set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70
set visualbell           " don't beep
set noerrorbells         " don't beep
set showcmd              " show incomplete cmds down the bottom
set showmode             " show current mode down the bottom
set incsearch            " find the next match as we type the search
set hlsearch             " hilight searches by default
set ttyfast              " more characters will be sent to the screen for redrawing
set scrolloff=3          " keep this number of lines below and above cursor
set clipboard=unnamed    " all operations work with the OS clipboard
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:. " highlight problematic whitespace
set viminfo='20,<50,s10,h,%                   " remember some stuff after quiting vim: marks, registers, searches, buffer list
set sessionoptions=curdir,buffers,tabpages
set wildignore=*.swp,*.bak,*.pyc,*.class
set cindent
set modeline
set lazyredraw
set magic
set cul
if exists("+undofile")
  set undolevels=256
  set undoreload=10000
  set undodir=./.vim/
  set undofile
endif
"set autochdir " NOTE: disabled, otherwise savesassion sometimes doesn't work!
"set mouse=a   " NOTE: disabled, otherwise it is imposible to copy text using mouse

syntax on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Vundle
filetype on                    " required on MacOSX only
filetype plugin off            " required by Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'vcscommand.vim'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
Bundle 'Shougo/neocomplcache'
Bundle 'xolox/vim-session'
Bundle 'kien/ctrlp.vim'
Bundle 'OmniCppComplete'
Bundle 'majutsushi/tagbar'
Bundle 'cpp.vim'
Bundle 'c.vim'
Bundle 'a.vim'
Bundle 'SearchComplete'
Bundle 'ShowMarks'
Bundle 'nathanaelkane/vim-indent-guides.git'
Bundle 'jimenezrick/vimerl'
Bundle 'msanders/snipmate.vim'
Bundle 'sudo.vim'
Bundle 'tpope/vim-repeat'
Bundle 'marcinbiegun/vim-escript'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'RelOps'

filetype plugin indent on      " required by Vundle

""""""""""""""""""""""""""""""""""""""""""""""" vimerl
set runtimepath+=$HOME/.vim/bundle/Vimerl
autocmd Filetype erlang setlocal omnifunc=erlang_complete#Complete
let g:erlang_skel_header = {"author": "Taras Shapovalov"}
let g:erlang_keywordprg = "erl -man"

""""""""""""""""""""""""""""""""""""""""""""""" IndexedSearch
let g:indexed_search_plugin = 0
let g:indexed_search_colors = 1
let g:indexed_search_shortmess = 1
let g:search_index_maxhit = 100

""""""""""""""""""""""""""""""""""""""""""""""" Syntastic
let g:syntastic_auto_jump = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_enable_signs = 0
let g:syntastic_echo_current_error = 0
let g:syntastic_check_on_open = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_quiet_warnings = 0
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_c_no_include_search = 1
let g:syntastic_cpp_check_header = 0
let g:syntastic_c_check_header = 0
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_cpp_auto_refresh_includes = 0
let g:syntastic_c_auto_refresh_includes = 0
let g:syntastic_stl_format = '%E{ line: %fe | col: %e }'
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['ruby', 'php'],
                           \ 'passive_filetypes': ['puppet'] }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""" Format the statusline
let g:gitinfo = ''
function! GitInfo()
  let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
  if branch != ''
    let g:gitinfo = 'git ↱ ' . substitute(branch, '\n', '', 'g')
  endif
endfun
au BufRead * call GitInfo()

let g:svninfo = ''
function! SVNInfo()
  let rev = system("svn info 2> /dev/null | grep -i revision | awk '{print $2}'")
  if rev != ''
    let branch = system("svn info | grep URL | awk '{print $2}' | awk  -F '/' '{print $5}'")
    if branch != ''
      let g:svninfo = 'svn ↱ ' . substitute(branch, '\n', '', 'g') . '/' . substitute(rev, '\n', '', 'g')
    endif
  endif
endfun
au BufRead * call SVNInfo()

function! FileSize()
 let bytes = getfsize(expand("%:p"))
 if bytes <= 0
   return ""
 endif
 if bytes < 1024
   return bytes . " B"
 else
   return (bytes / 1024) . " K"
 endif
endfunction

function! s:Get_file_perm()
  let a=getfperm(expand('%:p'))
  if strlen(a)
    return a
  else
    let b=printf("%o", xor(0777,system("umask")))
    let c=""
    for d in [0, 1, 2]
      let c.=and(b[d], 4) ? "r" : "-"
      let c.=and(b[d], 2) ? "w" : "-"
      let c.=and(b[d], 1) ? "x" : "-"
    endfor
    return c
  endif
endfunction

augroup Get_file_perm
  autocmd!
  autocmd BufWinEnter,FileChangedShell * let w:file_perm=<sid>Get_file_perm()
augroup END

set statusline= " clear the statusline for when vimrc is reloaded
set statusline+=\ \ %<%F\ 

set statusline+=%#VisualDelimeterWhite#
set statusline+=%*
set statusline+=%{getfsize(expand('%:p'))>0?'┃\ ':''}
set statusline+=%{FileSize()}
set statusline+=%#VisualDelimeterWhite#\ ┃%*
set statusline+=\ %{w:file_perm}
set statusline+=%#VisualDelimeterWhite#\ ┃%*

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'\['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%1*
set statusline+=%h      "help file flag
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag
set statusline+=%w

set statusline+=%#warningmsg#
set statusline+=%*

set statusline+=\ %#error#
set statusline+=%{&paste?'paste':''}
set statusline+=%*

set statusline+=\ %#error#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


set statusline+=%=                  "left/right separator ⤦
set statusline+=%#VisualDelimeterWhite#\ ┃%*\ 
set statusline+=%{g:svninfo}
set statusline+=%{g:gitinfo}

set statusline+=%#VisualDelimeterWhite#\ ┃%*

set statusline+=\ line:\ %l/%L   "cursor line/total lines

set statusline+=%#VisualDelimeterWhite#\ ┃%*

set statusline+=\ col:\ %c       "cursor column

set statusline+=%#VisualDelimeterWhite#\ ┃%*

set statusline+=\ %P\             "percent through file

set statusline+=%#VisualDelimeterBlock#┃%*

set laststatus=2

" Recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"""""""""""""""""""""""""""""""""""""""""""""""""""""""" tags, swp and backup
" Create ./.vim in a buffer directory on write:
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h').'/.vim'
        echo dir
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
au BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))

set tags=./.vim/tags
set tags+=~/.vim/tags/cpp

set directory=./.vim//
set directory+=.

set backupdir=./.vim//
set backup

""""""""""""""""""""""""""""""""""""""""""""""""""""""" OmniCppComplete
set nocp
"filetype plugin on
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1      " autocomplete after .
let OmniCpp_MayCompleteArrow = 1    " autocomplete after ->
let OmniCpp_MayCompleteScope = 1    " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main

"""""""""""""""""""""""""""""""""""""""""""""""NeoComplCache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

""""""""""""""""""""""""""""""""""""""""" Cursor
function SetVisibleCursorLine()
  hi CursorLine cterm=none ctermbg=7
endfunction

function SetInvisibleCursorLine()
  hi CursorLine cterm=none ctermbg=15
endfunction

" Change a cursor shape (Gnome terminal only):
if has("autocmd")
  "au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  "au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  "au VimLeave    * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
  au BufEnter __Tagbar__ silent call SetVisibleCursorLine()
  au BufLeave __Tagbar__ silent call SetInvisibleCursorLine()
  au BufEnter NERD_tree* silent call SetVisibleCursorLine()
  au BufLeave NERD_tree* silent call SetInvisibleCursorLine()
  au WinLeave * setlocal nocursorline
  au WinEnter * setlocal cursorline
endif

""""""""""""""""""""""""""""""""""""""""" Tabs
function MyTabLine()
  let tabline = '%#TabLine#'
  let tabline .= repeat(' ', &numberwidth)
  for i in range(tabpagenr('$'))
    let buflist = tabpagebuflist(i + 1)
    if i + 1 == tabpagenr()
      let tabline .= '%#TabLineSel#'
      for b in range(len(buflist))
        if getbufvar(buflist[b], "&modified")
          let tabline .= '%#TabLineModifiedSel#'
          break
        endif
      endfor
    else
      let tabline .= '%#TabLine#'
      for b in range(len(buflist))
        if getbufvar(buflist[b], "&modified")
          let tabline .= '%#TabLineModified#'
          break
        endif
      endfor
    endif
    let tabline .= '%' . (i + 1) . 'T'
    let tabline .= ' %{MyTabLabel(' . (i + 1) . ')} ' . '%{MyTabNum(' . (i + 1) . ')}'
    if i + 1 == tabpagenr()
      let tabline .= '%#TabLineSel#'
    else
      let tabline .= '%#TabLine#'
    endif
    if i + 1 != tabpagenr() && i+2 != tabpagenr()
      let tabline .= '%#VisualDelimeter#'
      let tabline .= '│'
    endif
  endfor
  let tabline .= '%#TabLineFill#%T'
  return tabline
endfunction

function MyTabNum(n)
  if a:n == 0
    return '₀'
  elseif a:n == 1
    return '₁'
  elseif a:n == 2
    return '₂'
  elseif a:n == 3
    return '₃'
  elseif a:n == 4
    return '₄'
  elseif a:n == 5
    return '₅'
  elseif a:n == 6
    return '₆'
  elseif a:n == 7
    return '₇'
  elseif a:n == 8
    return '₈'
  elseif a:n == 9
    return '₉'
  elseif a:n == 10
    return '₁₀'
  elseif a:n == 11
    return '₁₁'
  elseif a:n == 12
    return '₁₂'
  elseif a:n == 13
    return '₁₃'
  elseif a:n == 14
    return '₁₄'
  elseif a:n == 15
    return '₁₅'
  elseif a:n == 16
    return '₁₆'
  elseif a:n == 17
    return '₁₇'
  elseif a:n == 18
    return '₁₈'
  elseif a:n == 19
    return '₁₉'
  elseif a:n == 20
    return '₂₀'
  elseif a:n == 21
    return '₂₁'
  elseif a:n == 22
    return '₂₂'
  elseif a:n == 23
    return '₂₃'
  elseif a:n == 24
    return '₂₄'
  elseif a:n == 25
    return '₂₅'
  elseif a:n == 26
    return '₂₆'
  elseif a:n == 27
    return '₂₇'
  elseif a:n == 28
    return '₂₈'
  elseif a:n == 29
    return '₂₉'
  elseif a:n == 30
    return '₃₀'
  elseif a:n == 31
    return '₃₁'
  elseif a:n == 32
    return '₃₂'
  else
    return ''
endfunction

function MyTabLabel(n)
  let label = ''
  let buflist = tabpagebuflist(a:n)
  let label = substitute(bufname(buflist[tabpagewinnr(a:n) - 1]), '.*/', '', '')
  if label == ''
    let label = '[No Name]'
  endif
  return label
endfunction

function MyGuiTabLabel()
  return '%{MyTabLabel(' . tabpagenr() . ')}'
endfunction

set tabline=%!MyTabLine()
set guitablabel=%!MyGuiTabLabel()

""""""""""""""""""""""""""""""""""""""""" CtrlP
set wildignore+=*/tmp/*,*.o,*.so,*.swp,*.zip
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
let g:ctrlp_by_filename = 1
let g:ctrlp_max_height = 99
let g:ctrlp_switch_buffer = 2
let g:ctrlp_reuse_window = 'NERD_tree'
let g:ctrlp_tabpage_position = 'ac'
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_open_new_file = 't'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_lazy_update = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let ctrlp_filter_greps = "".
    \ "egrep -iv '\\.(" .
    \ "jar|class|swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
    \ ")$' | " .
    \ "egrep -v '^(\\./)?(" .
    \ "deploy/|lib/|classes/|libs/|deploy/vendor/|.git/|.hg/|.svn/|.*migrations/" .
    \ ")'"
 
let my_ctrlp_git_command = "" .
    \ "cd %s && git ls-files | " .
    \ ctrlp_filter_greps
 
if has("unix")
    let my_ctrlp_user_command = "" .
    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
    \ ctrlp_filter_greps
endif
 
let g:ctrlp_user_command = ['.git/', my_ctrlp_git_command, my_ctrlp_user_command]
"let g:ctrlp_buffer_func = {
"  \ 'enter': 'SetVisibleCursorLine',
"  \ 'exit':  'SetInvisibleCursorLine',
"  \ }

""""""""""""""""""""""""""""""""""""""""" EasyMotion
let g:EasyMotion_leader_key = ','

""""""""""""""""""""""""""""""""""""""""" ShowMarks
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let g:showmarks_enable = 1
let showmarks_ignore_type="hqrm"
let g:showmarks_textlower=" "

""""""""""""""""""""""""""""""""""""""""" NERD tree
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeChDirMode=1
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeShowHidden=1
let g:NERDTreeKeepTreeInNewTab=1

"""""""""""""""""""""""""""""""""""""""" TagBar
let g:tagbar_width = 60
let g:tagbar_compact = 1
let g:tagbar_iconchars = ['➱', '➢']

if has("autocmd")
  au FileType c,cpp nested :TagbarOpen

  au FileType qf
    \ if &buftype == "quickfix" |
    \     setlocal statusline=%2*%-3.3n%0* |
    \     setlocal statusline+=\ \[Compiler\ Messages\] |
    \     setlocal statusline+=%=%2*\ %<%P |
    \ endif

  fun! <SID>FixMiniBufExplorerTitle()
    if "-MiniBufExplorer-" == bufname("%")
      setlocal statusline=%2*%-3.3n\ %0*\[MiniBufExplorer\]
    elseif "__Tagbar__" == bufname("%")
      setlocal statusline=%0*
      setlocal statusline+=Tagbar
      setlocal statusline+=%=\ %<%P
      setlocal cursorline
    endif
  endfun

  au BufWinEnter *
    \ let oldwinnr=winnr() |
    \ windo call <SID>FixMiniBufExplorerTitle() |
    \ exec oldwinnr . " wincmd w" 

endif

"""""""""""""""""""""""""""""""""""""""" Restore last session
let g:session_autosave = 1
let g:session_autoload = 1
let g:session_default_to_last = 1
let g:session_directory = ".vim"

au VimLeavePre * SaveSession()

""""""""""""""""""""""""""""""""""""""""" Colors
set t_Co=256
colo taras256

" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"   :VimColorTest    "(for console/terminal Vim)
"   :GvimColorTest   "(for GUI gvim)
function! VimColorTest(outfile, fgend, bgend)
  let result = []
  for fg in range(a:fgend)
    for bg in range(a:bgend)
      let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
      let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! VimColorTest call VimColorTest('vim-color-test.tmp', 12, 16)

function! GvimColorTest(outfile)
  let result = []
  for red in range(0, 255, 16)
    for green in range(0, 255, 16)
      for blue in range(0, 255, 16)
        let kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
        let fg = printf('#%02x%02x%02x', red, green, blue)
        let bg = '#fafafa'
        let h = printf('hi %s guifg=%s guibg=%s', kw, fg, bg)
        let s = printf('syn keyword %s %s', kw, kw)
        call add(result, printf('%s | %s', h, s))
      endfor
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! GvimColorTest call GvimColorTest('gvim-color-test.tmp')

""""""""""""""""""""""""""""""""""""""""" Include keys map
source ~/.vim/keys.vim

" Use local vimrc if available 
if filereadable(expand("./.vim/vimrc-custom"))
  source ./.vim/vimrc-custom
endif

