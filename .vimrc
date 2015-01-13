"******************************************************************************
"
"  File Name :  .vimrc
"  Type      :  vim init file
"  Function  :  VIM Initial
"  Author    :  Yoshida Norikatsu
"               2013/11/17 Restart
"
"******************************************************************************


"**********************************************************************
"* Runtimepath
"**********************************************************************
set runtimepath+=$HOME/.vim,$HOME/.vim/after



"**********************************************************************
"* Neobundle Setting
"**********************************************************************
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))


" Installation check.
if neobundle#exists_not_installed_bundles()
    echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
    echomsg 'Please execute ":NeoBundleInstall" command.'
    "finish
endif

"neobundleを更新するための設定
" インストール  :NeoBundleInstall
" アップデート  :NeoBundleUpdate
" 削除          :NeoBundleClean( vimrc該当行を削除したのち実行)
"NeoBundleFetch 'Shougo/neobundle.vim'

"読み込みプラグインリスト
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'vimtaku/hl_matchit.vim.git'
NeoBundle 'vcscommand.vim'
NeoBundle 'motemen/git-vim'
NeoBundle 'norikatsu/verilog_instance.vim'
NeoBundle 'norikatsu/headder_module.vim'


" インデントに色を付けて見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'

NeoBundle 'Shougo/vimproc.vim'
"Vim\plugins\vimproc\autoload\vimproc_win64.dll  // 同梱されているDLL
"    ---> $HOME\.vim\bundle\vimproc.vim\autoload // ここにコピーする

" vimshell
NeoBundle 'Shougo/vimshell.vim'

filetype plugin indent on     " Required!

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
    "Windowsではデフォルト IMEOFFに設定
    set iminsert=0
    set imsearch=-1

    "挿入モード終了時にIMEOFF
    inoremap <silent> <ESC> <ESC>
    inoremap <silent> <C-[> <ESC>

else
    "Linux では 挿入モードを出たときIMEをOFFにする
    "   この処理には "xvkbd"が必要なのでインストールすること
    "   IMEのオフ設定に <Ctrl>+<Shift>+<Space> を設定しておく
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
"* 全角スペース処理
"**********************************************************************
if has("syntax")
    syntax on

    " PODバグ対策
    syn sync fromstart

    function! ActivateInvisibleIndicator()
        " 下の行の"　"は全角スペース
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
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
"* カレントディレクトリ移動コマンド定義 
"**********************************************************************
" -> :CD で開いているファイルのディレクトリに移動
" -> :CD! で移動先を表示して確認できる
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
"* コンパイラ設定(make実行時)
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

"========== 不可視属性文字の可視化
set list
set listchars=tab:>.,trail:-,eol:$,extends:>,precedes:<,nbsp:%

"========== Tab
set expandtab
set ts=4
set sw=4
set sts=4

"========== コピペ処理(コピペバッファに unnamed バッファを使用する)
"nmap <C-b> "+gP
set clipboard=unnamed

"========== matchit.vim Setting (verilog begin-end関連づけ)
source $VIMRUNTIME/macros/matchit.vim

"**********************************************************************
"* Keybind
"**********************************************************************
"
"========== rebuild
nnoremap <silent> <Space>re :<C-u>!./rebuild.sh<CR>


"========== カーソル移動
"inoremap <C-h> <Left>
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
"inoremap <C-l> <Right>

"========== BackSpace
"     キーマップの解説
"     BSキーは GUIでは BSコードを出力,ターミナルでは DEL(^?)を出す
"     文字削除は ^H(C-h) コードだがすでに左移動に割り当てている
"     よって以下の設定を入れないと左に移動するだけになってしまう
noremap   
noremap!  
noremap  <BS> 
noremap! <BS> 
set backspace=indent,eol,start


"========== Filer 
nmap <Space>f :<C-u>Ex<CR>


"========== 文字コード設定変更(保存形式変更)
nmap <Space>ee :<C-u>set fileencoding=euc-jp fileformat=unix<CR>
nmap <Space>eu :<C-u>set fileencoding=utf-8 fileformat=unix<CR>
nmap <Space>es :<C-u>set fileencoding=sjis fileformat=dos<CR>

"========== 文字コード設定変更(ファイルオープンし直し)
nmap <Space>oe :<C-u>e ++enc=euc-jp<CR>
nmap <Space>ou :<C-u>e ++enc=utf-8<CR>
nmap <Space>os :<C-u>e ++enc=sjis<CR>

"========== 検索時のハイライト消去
"nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nmap <Space>ho :<C-u>set hlsearch<CR>
nmap <Space>hn :<C-u>set nohlsearch<CR>


"========== タブ操作
nnoremap <C-t> :tabedit<CR>
"nnoremap <C-x> :tabclose<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nmap <Space>t :<C-u>tabnew<CR>:<C-u>Ex<CR>

"========== Window操作
nnoremap <Space>ww :<C-u>split<CR>
nnoremap <Space>wv :<C-u>vsplit<CR>
nnoremap <Space>wc :<C-u>close<CR>


"========== make 関連
nnoremap <Space>co :<C-u>copen<CR>
nnoremap <Space>cq :<C-u>cclose<CR>
nnoremap <Space>cn :<C-u>cnewer<CR>
nnoremap <Space>cp :<C-u>colder<CR>



"========== VCScommand 設定
nnoremap <Space>cv :<C-u>VCSVimDiff<Enter>
nnoremap <Space>ca :<C-u>VCSAdd<Enter>
nnoremap <Space>cc :<C-u>VCSCommit<Enter>
"nnoremap <Space>cd :<C-u>VCSDiff<Enter>
nnoremap <Space>cs :<C-u>VCSStatus<Enter>
nnoremap <Space>cr :<C-u>VCSRevert
nnoremap <Space>cx :<C-u>VCSDelete


"========== VimDiff 設定
"前の変更の先頭へ移動
nmap <F7> [c
"次の変更の先頭へ移動
nmap <F8> ]c

"差分モード開始
nmap ,d :vert diffs

"差分モードを終了
"nmap <Leader>dq :winc l<CR>:bw<CR>:diffoff<CR>
nmap ,cq :winc l<CR>:bw<CR>:diffoff<CR>
nmap ,gq :winc l<CR>:bw<CR>:diffoff<CR>
nmap ,q :winc l<CR>:bw<CR>:diffoff<CR>



"========== vim-indent-guides
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1


"========== VimShell設定
nnoremap <Space>vv :<C-u>VimShell<CR>
nnoremap <Space>vp :<C-u>VimShell python<CR>

let g:vimshell_prompt_expr = 'getcwd()." > "'
let g:vimshell_prompt_pattern = '^\f\+ > '



"**********************************************************************
"* Plugin Setting
"**********************************************************************


"========== neocomplete.vim Setting

"neocomplcache を使うので無効化
let g:acp_enableAtStartup = 0

" Use neocomplete.vim
let g:neocomplete#enable_at_startup = 1

""スイッチ設定
nmap ,y :NeoCompleteEnable <CR>
nmap ,n :NeoCompleteDisable <CR>

" Use smartcase. 大文字入力まで大文字小文字を区別しない
let g:neocompete#enable_smart_case = 1

" Tabで補完
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

"
"" Use auto select 補完候補を出すときに、自動的に一番上の候補を選択 
""let g:neocomplcache_enable_auto_select = 1
"
"" Use camel case completion. 大文字を区切りとしたワイルドカードのように振る舞うという機能
"let g:neocomplcache_enable_camel_case_completion = 1
"
"" Use underbar completion. _区切りの補完を有効化
"let g:neocomplcache_enable_underbar_completion = 1
"
"" Set minimum syntax keyword length. シンタックスをキャッシュするときの最小文字長
"let g:neocomplcache_min_syntax_length = 3
"
"" Set manual completion length.
"let g:neocomplcache_manual_completion_start_length = 0
"

"" ポップアップ削除
""inoremap <expr><C-x> neocomplcache#smart_close_popup().”\<C-h>”
"
"" 選択候補確定
"inoremap <expr><C-y> neocomplcache#close_popup()
"
"" 選択候補キャンセル ＆ ポップアップ削除
"inoremap <expr><C-x> neocomplcache#cancel_popup()
"
"" 前回行われた補完をキャンセル
"inoremap <expr><C-g> neocomplcache#undo_completion()
"


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


"========== Highlight match Setting
let g:hl_matchit_enable_on_vim_startup = 1



"========== TextWidth (Filetype) Setting
autocmd FileType verilog setlocal textwidth=0

