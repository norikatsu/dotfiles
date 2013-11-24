"******************************************************************************
"
"  File Name :  .vimrc
"  Type      :  vim init file
"  Function  :  VIM Initial
"  Author    :  Yoshida Norikatsu
"               2013/11/17 Restart
"
"******************************************************************************

"========== neobundle Setting
" neobundle
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

filetype plugin indent on     " Required!

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

"neobundleを更新するための設定
"NeoBundleFetch 'Shougo/neobundle.vim'

"読み込みプラグインリスト
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'vimtaku/hl_matchit.vim.git'


"========== Backup
set backup
set backupdir=~/tmp/vimbackup,.


"========== Encoding
if has("win32") || has("win64")
    set encoding=cp932
    set fileformat=dos
else
    set encoding=utf-8
    set fileformat=unix
endif

set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos
set ambiwidth=double


"========= IME Setting

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
au InsertLeave * call s:ModeColor('darkblue','Leave')


"========== HighLight
set hlsearch


"========== Insert Mode & IME Mode Color
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

" 全角スペース処理
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

"========== Tab
set expandtab
set ts=4
set sw=4
set sts=4


"========== カレントディレクトリ移動コマンド定義 
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


"========== Keybind
"
"  モード切り替え系のキーバインドは ,XX に統一する

"カーソル移動
inoremap <C-e> <End>
inoremap <C-d> <Del>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"BackSpace
"     キーマップの解説
"     BSキーは GUIでは BSコードを出力,ターミナルでは DEL(^?)を出す
"     文字削除は ^H(C-h) コードだがすでに左移動に割り当てている
"     よって以下の設定を入れないと左に移動するだけになってしまう

noremap   
noremap!  
noremap  <BS> 
noremap! <BS> 
set backspace=indent,eol,start


"Filer Setting
nmap ,f :<C-u>Ex<CR>

"文字コード設定変更(ファイルオープンし直し)
nmap ,e :<C-u>e ++enc=euc-jp<CR>
nmap ,u :<C-u>e ++enc=utf-8<CR>
nmap ,s :<C-u>e ++enc=sjis<CR>

"文字コード設定変更(保存形式変更)
nmap ,ee :<C-u>set fileencoding=euc-jp fileformat=unix<CR>
nmap ,eu :<C-u>set fileencoding=utf-8 fileformat=unix<CR>
nmap ,es :<C-u>set fileencoding=sjis fileformat=dos<CR>


"検索時のハイライト消去
"nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nmap ,h :<C-u>set hlsearch<CR>
nmap ,l :<C-u>set nohlsearch<CR>


" コピペ処理(コピペバッファに unnamed バッファを使用する)
"nmap <C-b> "+gP
set clipboard=unnamed

" タブ操作
nnoremap <C-t> :tabedit<CR>
"nnoremap <C-x> :tabclose<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>


" タグ操作
nnoremap <C-@> :!ctags -R .<CR>
nnoremap <C-b> :pop<CR>



" 横分割

" 縦分割

" 分割ウィンド消去

" ウィンド移動

" make 関連
nnoremap :co :<C-u>copen<CR>
nnoremap :cq :<C-u>cclose<CR>
nnoremap :cn :<C-u>cnewer<CR>
nnoremap :cp :<C-u>colder<CR>


" git-vim 設定
"let g:git_no_map_default = 1
"let g:git_command_edit = 'rightbelow vnew'
"nnoremap ,gd :<C-u>GitDiff<Enter>
"nnoremap ,gD :<C-u>GitDiff --cached<Enter>
"nnoremap ,gs :<C-u>GitStatus<Enter>
"nnoremap ,gl :<C-u>GitLog<Enter>
"nnoremap ,gL :<C-u>GitLog -u \| head -10000<Enter>
"nnoremap ,ga :<C-u>GitAdd<Enter>
"nnoremap ,gA :<C-u>GitAdd <cfile><Enter>
"nnoremap ,gc :<C-u>GitCommit<Enter>
"nnoremap ,gC :<C-u>GitCommit --amend<Enter>
"nnoremap ,gp :<C-u>Git push


"VCScommand 設定
nnoremap ,cv :<C-u>VCSVimDiff<Enter>
nnoremap ,gv :<C-u>VCSVimDiff<Enter>

nnoremap ,ca :<C-u>VCSAdd<Enter>
nnoremap ,cc :<C-u>VCSCommit<Enter>
nnoremap ,cd :<C-u>VCSDiff<Enter>
nnoremap ,cs :<C-u>VCSStatus<Enter>
nnoremap ,cr :<C-u>VCSRevert
nnoremap ,cx :<C-u>VCSDelete





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


"========== Binary Mode
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



"RTL作成支援ツール用 (外部スクリプトを実行するので注意)
" ~/bin  or ~/julia/bin 等 パスの通った場所にスクリプトを置くこと

" ヘッダ部作成
map _rcs :r !rcs_gen %<CR>

" ls実行
map _ls  :!ls<CR>


" ***** for Verilog Source Edit Support
" Verilog FF Gen(basic)
map _lfb :r !vlog_ff.rb -t basic -w 1 <cword>

" Verilog FF Gen(if)
map _lfi :r !vlog_ff.rb -t if -w 1 <cword>

" Verilog FF Gen(case)
map _lfc :r !vlog_ff.rb -t case -w 1 -s 2 <cword>

" Verilog FF Gen(sreg)
map _lfs :r !vlog_ff.rb -t sreg -w 8 <cword>

" Verilog FF Gen(edge)
map _lfe :r !vlog_ff.rb -t edge <cword><CR>

" Verilog FF Gen(ucntr)
map _lfu :r !vlog_ff.rb -t cntr -w 8 -m cue <cword>

" Verilog FF Gen(dcntr)
map _lfd :r !vlog_ff.rb -t cntr -w 8 -m cde <cword>

" Verilog FF Gen(state machine)
map _lfm :r !vlog_ff.rb -t state -w 3 <cword>

" Verilog Module Instantiation
map _lmi :r !vlog_mod.rb -i <cword>.*v<CR>

" Verilog Module Drive Signals
map _lms :r !vlog_mod.rb -s <cword>.*v<CR>

" Verilog Module Output Assign
map _lmo :r !vlog_mod.rb -o <cword>.*v<CR>

" Verilog Signal Declaration(reg) & Read it!
map _lsr :r !vlog_sig.rb -t reg -w 8  <cword><CR>

" Verilog Signal Declaration(wire) & Read it!
map _lsw :r !vlog_sig.rb -t wire -w 8  <cword><CR>

" Verilog Top Input Buffer Instance & Read it!
map _lti :r !vlog_iob.rb -t i -w 1  <cword>

" Verilog Top Output Buffer Instance & Read it!
map _lto :r !vlog_iob.rb -t o -w 1  <cword>

" Verilog Top I/O Buffer Instance & Read it!
map _ltb :r !vlog_iob.rb -t b -w 1  <cword>


" *****  for Verilog/VHDL Source Compile & Make
" Save current file & Verilog Compile
map _vl  :w!<CR>:!vlog %<CR>

" Save current file & Verilog Compile with System Verilog option
map _vls :w!<CR>:!vlog -sv %<CR>

" Save current file & VHDL Compile
map _vc  :w!<CR>:!vcom %<CR>

" Save current file & Make Project
map _ma  :w!<CR>:!make<CR>

" Save current file & Kashi RTL Checker
map _kr  :w!<CR>:!krtl.sh %<CR>






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



"========== matchit.vim Setting (verilog begin-end関連づけ)
source $VIMRUNTIME/macros/matchit.vim



"========== AutoComplpop Setting

"neocomplcache を使うので無効化
let g:acp_enableAtStartup = 0




"========== neocomplete.vim Setting

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
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'



imap <C-s>     <Plug>(neosnippet_expand_or_jump)
smap <C-s>     <Plug>(neosnippet_expand_or_jump)
xmap <C-s>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


"========== Highlight match Setting
let g:hl_matchit_enable_on_vim_startup = 1
