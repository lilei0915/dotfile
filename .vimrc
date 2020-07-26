" debug function: echo echom
"echom ">^.^<"
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/LeaderF'
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'davidhalter/jedi-vim'
Plug 'w0rp/ale'
Plug 'Shougo/neocomplete.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ludovicchabant/vim-gutentags'
Plug 'inkarkat/vim-mark'
Plug 'vim-scripts/ingo-library'
call plug#end()

syntax on
filetype on
set ignorecase
set ruler
set laststatus=2
" statusline:file name
set statusline=%F
" statusline:start from right
set statusline+=%= 
" statusline:filetype
set statusline+=Filetype:\ %y\ 
" statusline:current linenum and collum
set statusline+=cur_pos:%l,%c\ 
" statusline:total linenum
set statusline+=total_line:%L\ 
set hlsearch
set incsearch
set showmatch
set matchtime=5
set nu
set tabstop=4 
set expandtab
set autoindent  
set smartindent
set shiftwidth=4
"autocmd VimEnter * NERDTree
let g:neocomplete#enable_at_startup = 1

"===========================nerd tree ======================{{{
"开启/关闭nerdtree快捷键
map <C-n> :NERDTreeToggle<CR>
"打开vim时如果没有文件自动打开NERDTree
autocmd vimenter * if !argc()|NERDTree|endif
"当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"设置树的显示图标
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeIgnore = ['\.pyc$']  " 过滤所有.pyc文件不显示
"let g:NERDTreeShowLineNumbers=1  " 是否显示行号
let g:NERDTreeHidden=0     "不显示隐藏文件
"Making it prettier
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
"===========================nerd tree ======================}}}

"===========================gutentags========================{{{
" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" 所生成的数据文件的名称 "
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 "
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"===========================gutentags========================}}}

"================taglist=================
map <silent> <F8> :TlistToggle<cr> 

let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口
"================taglist=================

" LeaderF configure ---------{{{
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

"noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
"noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap go :<C-U>Leaderf! rg --recall<CR>

" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
" LeaderF configure end}}}

" cscope configure {{{
if has("cscope")
	  set csprg=/usr/bin/cscope
	  set csto=0
	  set cst
	  set nocsverb
	  " add any database in current directory
	  if filereadable("cscope.out")
		  cs add cscope.out
	  " else add database pointed to by environment
	  elseif $CSCOPE_DB != ""
		  cs add $CSCOPE_DB
	  endif
	  set csverb
endif
    nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nnoremap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    " cscope configure end }}}
    
" vim-mark configure {{{
" 1: Cyan  2:Green  3:Yellow  4:Red  5:Magenta  6:Blue
let g:mwIgnoreCase = 0
let g:mwAutoSaveMarks = 0
nnoremap <Leader>M <Plug>MarkToggle
nnoremap <Leader>N <Plug>MarkAllClear
" vim-mark configure end}}}

" vim script practice --------------{{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" change word captial in insertmode 
inoremap <c-u> <esc>vawUea
inoremap <c-l> <esc>vawuea
inoremap jk <esc>
inoremap <esc> <nop>
iabbrev @@ plumnutlee@163.com 
iabbrev adn and
iabbrev waht what 
iabbrev tehn then
" }}}

" vimscript file settings ----------------{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
