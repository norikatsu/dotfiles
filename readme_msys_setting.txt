Console2 での msys 環境作り

1. Windowsの環境変数設定
    WD = C:\MinGW\msys\1.0\\bin\
    COMSPEC = C:\WINDOWS\SysWOW64\cmd.exe
    MSYSCON = sh.exe
    MSYSTEM = MINGW32

2. 下記空フォルダを作成
  "C:\MinGW\msys\1.0\mingw\" 


3. C:\MinGW\msys\1.0\etc\fstab を用意下記設定

    c:/MinGW        /mingw

4. C:\MinGW\msys\1.0\etc\profile に下記設定追記

    export LOCATIONTYPE="MYHOME"

4. Console2 の新しいタブ追加
   シェルとして下記設定記入(アイコン等は任意)
    shell : C:\MinGW\msys\1.0\bin\bash.exe --login -i
    Startup dir : D:\nori_mydoc


 
