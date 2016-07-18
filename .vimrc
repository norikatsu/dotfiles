"******************************************************************************
"
"  File Name :  .vimrc
"  Type      :  vim init file
"  Function  :  VIM Initial
"  Author    :  Yoshida Norikatsu
"               2016/07/18 Restart (dein.vim Version)
"
"******************************************************************************

"**********************************************************************
"* dein Setting
"**********************************************************************

" Flags
let s:use_dein = 1

" vi compatibility
if !&compatible
    set nocompatible
endif

" Prepare .vim dir
let s:vimdir = $HOME . "/.vim"
if has("vim_starting")
    if ! isdirectory(s:vimdir)
        call system("mkdir " . s:vimdir)
    endif
endif

" dein
let s:dein_enabled  = 0
if s:use_dein && v:version >= 704
    let s:dein_enabled = 1

    " Set dein paths
    let s:dein_dir = s:vimdir . '/dein'
    let s:dein_github = s:dein_dir . '/repos/github.com'
    let s:dein_repo_name = "Shougo/dein.vim"
    let s:dein_repo_dir = s:dein_github . '/' . s:dein_repo_name

    " Check dein has been installed or not.
    if !isdirectory(s:dein_repo_dir)
        echo "dein is not installed, install now "
        let s:dein_repo = "https://github.com/" . s:dein_repo_name
        echo "git clone " . s:dein_repo . " " . s:dein_repo_dir
        call system("git clone " . s:dein_repo . " " . s:dein_repo_dir)
    endif
    let &runtimepath = &runtimepath . "," . s:dein_repo_dir


    " Check cache
    if dein#load_state(s:dein_dir)
        " Begin plugin part
        call dein#begin(s:dein_dir)

        call dein#add('Shougo/dein.vim')

        "�ȉ���2�̃t�@�C�����R�s�[����
        "Vim\plugins\vimproc\autoload\vimproc_win64.dll  // ��������Ă���DLL
        "    ---> $HOME\.vim\dein\repos\github.com\Shougo\vimproc.vim\autoload // �����ɃR�s�[����
        "Vim\plugins\vimproc\lib\vimproc_win64.dll  // ��������Ă���DLL
        "    ---> $HOME\.vim\dein\repos\github.com\Shougo\vimproc.vim\lib // �����ɃR�s�[����
        call dein#add('Shougo/vimproc', {
              \ 'build': {
              \     'windows': 'tools\\update-dll-mingw',
              \     'cygwin': 'make -f make_cygwin.mak',
              \     'mac': 'make -f make_mac.mak',
              \     'linux': 'make',
              \     'unix': 'gmake'}})

        call dein#add('Shougo/unite.vim', {
              \ 'depends': ['vimproc'],
              \ 'on_cmd': ['Unite'],
              \ 'lazy': 1})

        " vimshell
        call dein#add('Shougo/vimshell.vim')

        if has('lua')
            call dein#add('Shougo/neocomplete.vim', {
                    \ 'on_i': 1,
                    \ 'lazy': 1})

            call dein#add('Shougo/neosnippet.vim')

            call dein#add('Shougo/neosnippet-snippets')

            call dein#add('ujihisa/neco-look', {
                    \ 'depends': ['neocomplete.vim']})
        endif

        "call dein#add('tyru/open-browser.vim', {
        "      \ 'on_map': ['<Plug>(openbrowser-smart-search)'],
        "      \ 'lazy': 1})


        call dein#add('vimtaku/hl_matchit.vim.git')

        call dein#add('vcscommand.vim')
        call dein#add('taglist.vim')
        call dein#add('motemen/git-vim')
        call dein#add('norikatsu/verilog_instance.vim')
        call dein#add('norikatsu/headder_module.vim')
        call dein#add('scrooloose/syntastic')
        call dein#add('h1mesuke/vim-alignta')

        " �C���f���g�ɐF��t���Č��₷������
        call dein#add('nathanaelkane/vim-indent-guides')


        " vim�ŊJ���Ă��鎞��tag�̒ǉ�
        call dein#add('szw/vim-tags')

        " Markdown �֘A
        call dein#add('kannokanno/previm')
        call dein#add('tyru/open-browser.vim')
        call dein#add('glidenote/memolist.vim')

        call dein#end()
        call dein#save_state()
    endif


    " Installation check.
    if dein#check_install()
        call dein#install()
    endif
endif

if s:dein_enabled && dein#tap("unite.vim")
    nnoremap [unite] <Nop>
    nmap <Leader>u [unite]
    nnoremap <silent> [unite]b :Unite buffer<CR>
endif



"**********************************************************************
"* Backup
"**********************************************************************
set backup
set backupdir=~/tmp/vimbackup,.



"**********************************************************************
"* Encoding
"**********************************************************************
"if has("win32") || has("win64")
"    set encoding=cp932
"    set fileformat=dos
"else
"    set encoding=utf-8
"    set fileformat=unix
"endif

set encoding=utf-8
set fileformat=unix
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos
set ambiwidth=double


"**********************************************************************
"* IME Setting
"**********************************************************************

if has("win32") || has("win64")
    "Windows�ł̓f�t�H���g IMEOFF�ɐݒ�
    set iminsert=0
    set imsearch=-1

    "�}�����[�h�I������IMEOFF
    inoremap <silent> <ESC> <ESC>
    inoremap <silent> <C-[> <ESC>

else
    "Linux �ł� �}�����[�h���o���Ƃ�IME��OFF�ɂ���
    "   ���̏����ɂ� "xvkbd"���K�v�Ȃ̂ŃC���X�g�[�����邱��
    "   IME�̃I�t�ݒ�� <Ctrl>+<Shift>+<Space> ��ݒ肵�Ă���
    inoremap <silent> <esc> <esc>:call ForceImeOff()<cr>
    function! ForceImeOff()
        let imeoff = system('xvkbd -text "\[Control]\[Shift]\[space]" > /dev/null 2>&1')
    endfunction
endif



"**********************************************************************
"* Insert Mode & IME Mode Color
"**********************************************************************
function! s:ModeColor(colorschemein, status)
    if has('syntax')
        "---------- Set Colorscheme 
        exec 'colorscheme ' a:colorschemein
        "---------- Set StatuLine Color
        if a:status == 'Enter'
            call s:StatusLine('Enter')
        else
            call s:StatusLine('Leave')
        endif
        "---------- IME color setting
        if has('multi_byte_ime') ||has('xim')
            highlight Cursor guifg=NONE guibg=Green
            highlight CursorIM guifg=NONE guibg=Orange
        endif
    endif
endfunction


let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=lightmagenta gui=none ctermfg=blue ctermbg=lightmagenta cterm=none'
let s:slhlcmd = ''
function! s:StatusLine(mode)
    if a:mode == 'Enter'
        silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
        silent exec g:hi_insert
    else
        highlight clear StatusLine
        silent exec s:slhlcmd
    endif
endfunction

function! s:GetHighlight(hi)
    redir => hl
    exec 'highlight '.a:hi
    redir END
    let hl = substitute(hl, '[\r\n]', '', 'g')
    let hl = substitute(hl, 'xxx', '', '')
    return hl
endfunction



"**********************************************************************
"* �S�p�X�y�[�X����
"**********************************************************************
if has("syntax")
    syntax on

    " POD�o�O�΍�
    syn sync fromstart

    function! ActivateInvisibleIndicator()
        " ���̍s��"�@"�͑S�p�X�y�[�X
        syntax match InvisibleJISX0208Space "�@" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
        syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
        highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=NONE gui=undercurl guisp=darkorange
        syntax match InvisibleTab "\t" display containedin=ALL
        highlight InvisibleTab term=underline ctermbg=white gui=undercurl guisp=darkslategray
    endf
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif



"**********************************************************************
"* �J�����g�f�B���N�g���ړ��R�}���h��` 
"**********************************************************************
" -> :CD �ŊJ���Ă���t�@�C���̃f�B���N�g���Ɉړ�
" -> :CD! �ňړ����\�����Ċm�F�ł���
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" Change current directory.
nnoremap <silent> <Space>cd :<C-u>CD<CR>



"**********************************************************************
"* Binary Mode
"**********************************************************************
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r
    autocmd BufWritePre * endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END



"**********************************************************************
"* �R���p�C���ݒ�(make���s��)
"**********************************************************************
"========== Compiler (Setting File Type)
autocmd FileType verilog :compiler verilog


"========== Make
" Setting is in ~/vim/compiler/***.vim

" command link is.....
"      ";" : bash
"      "&" : dos
"set makeprg=rm\ -rf\ work\&vlib\ work\&vlog\ %
"set makeprg=rm\ -rf\ work\;vlib\ work\;vlog\ %

"set errorformat=**\ Warning:\ %f(%l):\ %m,**\ Error:\ %f(%l):\ %m




"**********************************************************************
"* Other Environment Setting
"**********************************************************************
"========== Text Width
set textwidth=0

"========== Use Mouse
set mouse=a
set ttymouse=xterm2

"========== Start Up Message
set shortmess+=I

"========== Syntax
syntax on

"========== Colorscheme
set t_Co=256
colorscheme darkblue

au InsertEnter * call s:ModeColor('desert','Enter')
au InsertEnter * IndentGuidesEnable
au InsertLeave * call s:ModeColor('darkblue','Leave')
au InsertLeave * IndentGuidesEnable

"========== HighLight
set hlsearch

"========== Bell
set visualbell

"========== LineNumber
set number

"========== Diff
set diffopt=filler,vertical

"========== StatusLine
set laststatus=2
set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%Y]%=\ (%v,%l)/%L%8P\

"========== �s�����������̉���
set list
set listchars=tab:>.,trail:-,eol:$,extends:>,precedes:<,nbsp:%

"========== Tab
set expandtab
set ts=4
set sw=4
set sts=4

"========== �R�s�y����(�R�s�y�o�b�t�@�� unnamed �o�b�t�@���g�p����)
"nmap <C-b> "+gP
set clipboard=unnamed

"========== matchit.vim Setting (verilog begin-end�֘A�Â�)
source $VIMRUNTIME/macros/matchit.vim

"**********************************************************************
"* Keybind
"**********************************************************************
"
"========== rebuild
nnoremap <silent> <Space>re :<C-u>!./rebuild.sh<CR>


"========== �J�[�\���ړ�
"inoremap <C-h> <Left>
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
"inoremap <C-l> <Right>

"========== BackSpace
"     �L�[�}�b�v�̉��
"     BS�L�[�� GUI�ł� BS�R�[�h���o��,�^�[�~�i���ł� DEL(^?)���o��
"     �����폜�� ^H(C-h) �R�[�h�������łɍ��ړ��Ɋ��蓖�ĂĂ���
"     ����Ĉȉ��̐ݒ�����Ȃ��ƍ��Ɉړ����邾���ɂȂ��Ă��܂�
noremap   
noremap!  
noremap  <BS> 
noremap! <BS> 
set backspace=indent,eol,start


"========== Filer 
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:newrw_altv = 1
function! ToggleVExplorer()
    if !exists("t:netrw_bufnr")
        exec '1wincmd w'
        25Vexplore
        let t:netrw_bufnr = bufnr("%")
        return
    endif
    let win = bufwinnr(t:netrw_bufnr)
    if win != -1
        let cur = winnr()
        exe win . 'wincmd w'
        close
        exe cur . 'wincmd w'
    endif
    unlet t:netrw_bufnr
endfunction


"nmap <Space>f :<C-u>Ex<CR>
nmap <Space>e :call ToggleVExplorer()<CR><c-w>p


"========== �����R�[�h�ݒ�ύX(�ۑ��`���ύX)
nmap <Space>ee :<C-u>set fileencoding=euc-jp fileformat=unix<CR>
nmap <Space>eu :<C-u>set fileencoding=utf-8 fileformat=unix<CR>
nmap <Space>es :<C-u>set fileencoding=sjis fileformat=dos<CR>

"========== �����R�[�h�ݒ�ύX(�t�@�C���I�[�v��������)
nmap <Space>oe :<C-u>e ++enc=euc-jp<CR>
nmap <Space>ou :<C-u>e ++enc=utf-8<CR>
nmap <Space>os :<C-u>e ++enc=sjis<CR>

"========== �������̃n�C���C�g����
"nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nmap <Space>ho :<C-u>set hlsearch<CR>
nmap <Space>hn :<C-u>set nohlsearch<CR>


"========== �^�u����
nnoremap <Space>t :<C-u>tabnew<CR>
"nnoremap <C-t> :tabedit<CR>
"nnoremap <C-x> :tabclose<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>

"========== Window����
nnoremap <Space>ww :<C-u>split<CR>
nnoremap <Space>wv :<C-u>vsplit<CR>
nnoremap <Space>wc :<C-u>close<CR>


"========== make �֘A
nnoremap <Space>co :<C-u>copen<CR>
nnoremap <Space>cq :<C-u>cclose<CR>
nnoremap <Space>cn :<C-u>cnewer<CR>
nnoremap <Space>cp :<C-u>colder<CR>



"========== VCScommand �ݒ�
nnoremap <Space>cv :<C-u>VCSVimDiff<Enter>
nnoremap <Space>ca :<C-u>VCSAdd<Enter>
nnoremap <Space>cc :<C-u>VCSCommit<Enter>
"nnoremap <Space>cd :<C-u>VCSDiff<Enter>
nnoremap <Space>cs :<C-u>VCSStatus<Enter>
nnoremap <Space>cr :<C-u>VCSRevert
nnoremap <Space>cx :<C-u>VCSDelete
nnoremap <Space>cl :<C-u>VCSLog<Enter>
nnoremap <Space>cn :<C-u>VSCAnnotate<Enter>


"========== VimDiff �ݒ�
"�O�̕ύX�̐擪�ֈړ�
nmap <F7> [c
"���̕ύX�̐擪�ֈړ�
nmap <F8> ]c

"�������[�h�J�n
nmap ,d :vert diffs

"�������[�h���I��
"nmap <Leader>dq :winc l<CR>:bw<CR>:diffoff<CR>
nmap ,cq :winc l<CR>:bw<CR>:diffoff<CR>
nmap ,gq :winc l<CR>:bw<CR>:diffoff<CR>
nmap ,q :winc l<CR>:bw<CR>:diffoff<CR>



"========== vim-indent-guides
" vim�𗧂��グ���Ƃ��ɁA�����I��vim-indent-guides���I���ɂ���
let g:indent_guides_enable_on_vim_startup = 1


"========== VimShell�ݒ�
nnoremap <Space>vv :<C-u>VimShell<CR>
nnoremap <Space>vp :<C-u>VimShell python<CR>

let g:vimshell_prompt_expr = 'getcwd()." > "'
let g:vimshell_prompt_pattern = '^\f\+ > '


"========== Unite�ݒ�
nnoremap <Space>fu :<C-u>Unite -no-split<CR>
nnoremap <Space>ff :<C-u>Unite<Space>buffer<CR>
nnoremap <Space>fb :<C-u>Unite<Space>bookmark<CR>
nnoremap <Space>fm :<C-u>Unite<Space>file_mru<CR>
nnoremap <Space>fr :<C-u>UniteWithBufferDir file<CR>
"nnoremap <Space>fr :<C-u>UniteResume<CR>
 
" vinarise
let g:vinarise_enable_auto_detect = 1
 
" unite-build map
nnoremap <silent> ,vb :Unite build<CR>
nnoremap <silent> ,vcb :Unite build:!<CR>
nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>


"========== �^�O�ݒ�
" 2�K�w��܂Ŋm�F����
set tags=./tags,tags,../tags,../../tags

" TagList
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1

map <Space>E :TlistToggle<CR>
nnoremap <C-]> g<C-]>


"========== neocomplete.vim Setting

"neocomplcache ���g���̂Ŗ�����
let g:acp_enableAtStartup = 0

" Use neocomplete.vim
let g:neocomplete#enable_at_startup = 1

""�X�C�b�`�ݒ�
nmap ,y :NeoCompleteEnable <CR>
nmap ,n :NeoCompleteDisable <CR>

" Use smartcase. �啶�����͂܂ő啶������������ʂ��Ȃ�
let g:neocompete#enable_smart_case = 1

" Tab�ŕ⊮
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"


"========== neosnippet.vim Setting
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/snippets'

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif


"========== Syntastic �ݒ�
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0
" C
let g:syntastic_c_check_header = 1
" C++
let g:syntastic_cpp_check_header = 1

nnoremap <Space>sy :<C-u>SyntasticCheck<CR>
nnoremap <Space>se :<C-u>Errors<CR>


"========== Markdown �ݒ�
nnoremap <Space>mp :<C-u>PrevimOpen<CR>
" md as markdown, instead of modula2
autocmd  BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown


"========== Memo
nmap <Space>mn :MemoNew<CR>
nmap <Space>ml :MemoList<CR>
nmap <Space>mg :MemoGrep<CR>
let g:memolist_memo_suffix = "md"
let g:memolist_template_dir_path = "~/.vim/template"





"========== Highlight match Setting
let g:hl_matchit_enable_on_vim_startup = 1



"========== TextWidth (Filetype) Setting
autocmd FileType verilog setlocal textwidth=0


