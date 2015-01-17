
# Linux & Windows環境のソフトの簡単な使い方説明
---

## 概要
Linux環境は CentOS5 64bit をメインに想定。  


## アプリ使い方
#### Gitの使い方

Git簡単な構成の説明
+ ワーキングツリー(作業中のファイル)  
+ インデックス(ステージング)  
+ コミットツリー(HEAD)  (.git フォルダ内に全て記録される)  

#### Gitコマンド

```
$ git init          ローカルリポジトリ作成
$ git clone URL     既存リポジトリからクローン
  -sオプションは trunk/ branches/ tags/ などがある場合に、 trunk をmasterに割り当ててくれる

$ git commmit   インデックスをコミット

$ git reset         元に戻す （使うときには注意！)
$ git reset HEAD            インデックスを戻す (addの取り消し)
$ git reset --hard HEAD     インデックスもワーキングも戻す

$ git reset HEAD^           コミットを一つ前に戻す
$ git reset HEAD^^          コミットを二つ前に戻す

$ git revert (コミットハッシュ) 特定のコミットだけ取り消す
```

リポジトリの取り消し（複数コミットを取り消すとき）
```
$ git revert -nオプションを使う  (巻き戻す変更をいったんステージングにのせて、コミットはしないでおくオプション)

$ git revert -n (コミットハッシュ)
$ git revert -n (コミットハッシュ)
$ git revert -n (コミットハッシュ)
$ git commit

$ git push          ローカルからリモートリポジトリへ
$ git svn dcommit   ローカルからリモートリポジトリへ (git svn)
```

```
$ git checkout -b mywork  (これは myworkブランチを作ってcheckoutしている)
このブランチが不要なら 削除
$ git checkout master
$ git branch -D mywork

ブランチを採用するならマージ(コミットは個別のまま)
$ git checkout master
$ git merge mywork  →(  --squash を追加するとコミットは1つにまとまる)
$ git svn dcommit
$ git branch -d mywork
```

コミットをまとめる その1
```
$ git rebase -i HEAD~3  (直近三回のコミットを対象にする)
以下のような表示がでるので、まとめる対象を pick-> squash に書き換える
（先頭の一つは pickのままにすること！)   → するとまとめのコメント入力画面になる
---------------------------
pick 0000000 fixed a bug
pick 1111111 edited POD
pick 2222222 changed Feature
```


コミットをまとめる方法 その2
別ブランチにマージするときにまとめてしまう
```
$ git merge --squash BRANCH
→ これは インデックス 状態になって反映されるのでこの後コミットすること！
```


#### Linuxコマンドの使い方
直接マウント

```
$ mount /マウント元 /マウント先
```

Windows共有のマウント
```
$ mount //WindowsPCのIPアドレス/共有ディレクトリ /mnt/tmp -o  user=winuser,password=winpassword
```

fstabの記述  
IPアドレスは統合ファイルサーバのアドレス  
/mnt/tmpは任意の場所  
ID パスワードは統合ファイルサーバのもの  
```
//10.69.84.141/sav1$    /mnt/tmp    cifs   user=統合ファイルサーバのID,password=統合ファイルサーバのパスワード,file_mode=0777 dir_mode=0777 0 0
```

#### link
```
$ ln -s リンク元 リンク先
```

#### sudo
有効にするため root になって 下記コマンド実行
```
visudo
```

viが起動するので、以下の設定を記入する

```
username ALL=(ALL) ALL     
```
username はsudoの権限を与えるユーザ  これでusenameは全てのroot権限を持つことになる



## その他
### Xwindow あんちょこ
sshで リモート端末にログインし、そこから Windows上の Xmingに飛ばしたい場合の設定
#### Xming の設定
Xming インストールディレクトリにある "X0.hosts"ファイルに sshでログインする リモートPC の IPアドレスを追記

#### リモート端末の設定
sshでログインした端末内で DISPLAY変数に WindowsのIPアドレスと ウィンド番号を設定  
    ex. export DISPLAY=10.64.221.255:0.0

#### Windows側で Xming 起動

以上で リモート側から xterm等を起動すると Windows上にウィンドウを飛ばせる


### Subverson あんちょこ
ブランチ、タグ等コピーのしかた
```
$ svn copy -r [リビジョン番号] [作成元のURL] [タグまたはブランチのURL]
```
