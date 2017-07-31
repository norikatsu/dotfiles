
# SVN から Gitへの移行方法
---

## 概要
SVNリポジトリから git-svnでcloneを行い、
gitリモートリポジトリにpushする


#### SVNからの移行
$ git svn clone URL




#### リモートに Gitリポジトリ作成
リモートPCを準備
リモートPCへのsshログインができるようにしておく

$ mkdir git_repo (リポジトリ用のディレクトリ作成)
$ cd git_repo
$ git --bare git_repo  (リポジトリ作成）



#### ローカルの SVNからコピーしたgitリポジトリの リモートURLを変更してプッシュ

$ git remote add origin ssh://remote-PC/home/****/git_repo      (URLは上記でリモートPCに作成したディレクトリの絶対パス)
    (sshの設定ファイルでユーザ名入力を短縮していない場合には下記の様にURLを設定する）
　　　　　$ git remote add origin ssh://USERNAME@remote-PC/home/****/git_repo 
$ git push origin master


#### Config確認
$ git config --list

