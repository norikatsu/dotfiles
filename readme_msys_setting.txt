ConEmu �ł� msys �����

0. MinGw���� C:\MinGW �ɃC���X�g�[��
   Git for Windows �� C:\MinGW\Git �ɃC���X�g�[��

1. Windows�̊��ϐ��ݒ�
    WD = C:\MinGW\msys\1.0\\bin\
    COMSPEC = C:\WINDOWS\SysWOW64\cmd.exe
      (32bit�łł� COMSPEC = %SystemRoot%\system32\cmd.exe )
    MSYSCON = sh.exe
    MSYSTEM = MINGW32

2. ���L��t�H���_���쐬
  "C:\MinGW\msys\1.0\mingw\" 


3. C:\MinGW\msys\1.0\etc\fstab ��p�Ӊ��L�ݒ�

    c:/MinGW        /mingw

4. C:\MinGW\msys\1.0\etc\profile �ɉ��L�ݒ�ǋL

    export LOCATIONTYPE="MYHOME"
                or 
    export LOCATIONTYPE="OFFICE"

4. ConEmu �� Commands�ݒ蕔�ɉ��L���L��
    C:\MinGW\msys\1.0\bin\bash.exe --login -i
    (�X�^�[�g�A�b�v�f�B���N�g���͊��ϐ�HOME�Ō��܂�j 


5. Cygwin�̐ݒ� Commands�ݒ蕔�ɉ��L���L��

   %SystemDrive%\Cygwin64\bin\bash.exe --login -i

    HOME�f�B���N�g�����}�E���g����
    �Ecygwin/home/nori �f�B���N�g�����쐬
    �E/etc/fstab�ɉ��L�s�L��
        C:/Users/Norikatsu/Documents /home/nori ntfs override,binary,auto 0 0

        
