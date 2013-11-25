"******************************************************************************
"
"  File Name : .gvimrc
"  Type      : gvim init file
"  Function  : GVIM Initial
"  Author    : Yoshida Norikatsu
"              2011/05/11 Start
"              2011/05/11 Add guifont
"              2011/05/30 Mod IME Color Setting
"              2011/06/07 Mod Colorscheme (Switch Input Mode / Normal Mode)
"              2011/06/07 Colorscheme setting go to .vimrc
"              2011/06/07 Add Save Window Size Function
"
"******************************************************************************

"========== Colorscheme
" Set same colorscheme as ~/.vimrc 
colorscheme darkblue


""========== IME color setting
"if has('multi_byte_ime') ||has('xim')
"    highlight Cursor guifg=NONE guibg=Green
"    highlight CursorIM guifg=NONE guibg=Orange
"endif


"========== Font
if has("win32") || has("win64")
    set guifont=Ricty:h13:cSHIFTJIS
else
    set guifont=monospace\ 12
end


"========== Save Window Size
let g:save_window_file = expand('~/.vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
      \ 'set columns=' . &columns,
      \ 'set lines=' . &lines,
      \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
      \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif


