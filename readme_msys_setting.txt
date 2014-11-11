ConEmu での msys 環境作り

0. MinGw環境を C:\MinGW にインストール
   Git for Windows を C:\MinGW\Git にインストール

1. Windowsの環境変数設定
    WD = C:\MinGW\msys\1.0\\bin\
    COMSPEC = C:\WINDOWS\SysWOW64\cmd.exe
      (32bit版では COMSPEC = %SystemRoot%\system32\cmd.exe )
    MSYSCON = sh.exe
    MSYSTEM = MINGW32

2. 下記空フォルダを作成
  "C:\MinGW\msys\1.0\mingw\" 


3. C:\MinGW\msys\1.0\etc\fstab を用意下記設定

    c:/MinGW        /mingw

4. C:\MinGW\msys\1.0\etc\profile に下記設定追記

    export LOCATIONTYPE="MYHOME"
                or 
    export LOCATIONTYPE="OFFICE"

4. ConEmu の Commands設定部に下記を記載
    C:\MinGW\msys\1.0\bin\bash.exe --login -i
    (スタートアップディレクトリは環境変数HOMEで決まる） 


5. Cygwinの設定 Commands設定部に下記を記載

   %SystemDrive%\Cygwin64\bin\bash.exe --login -i

    HOMEディレクトリをマウントする
    ・cygwin/home/nori ディレクトリを作成
    ・/etc/fstabに下記行記載
        C:/Users/Norikatsu/Documents /home/nori ntfs override,binary,auto 0 0

        
