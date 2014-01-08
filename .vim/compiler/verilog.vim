" Vim compiler file
" Compiler:         ModelSim vlog
" Maintainer:       Yoshida Norikatsu
" Latest Revision:  2011-05-08
"
" Function:         Verilog File Error Check
"                     1. rm work (Delete existing work dir)
"                     2. vlib work
"                     3. vlog RTL (error check)

if exists("current_compiler")
  finish
endif
let current_compiler = "vlog"

let s:cpo_save = &cpo
set cpo-=C

" command link is.....
"      ";" : bash
"      "&" : dos
CompilerSet makeprg=rm\ -rf\ work\;vlib\ work\;vlog\ %
"CompilerSet makeprg=rm\ -rf\ work\&vlib\ work\&vlog\ %

CompilerSet errorformat=**\ Warning:\ %f(%l):\ %m,**\ Error:\ %f(%l):\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
