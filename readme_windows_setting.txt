1. ProgramFiles�̃R�s�[
    1.1 vim, 7zip ��32bit�A64bit�ňقȂ�̂Œ���
    1.2 TortusSVN, WinMerge, VLC �̃C���X�g�[���i64,32�Ƃ� �f�t�H���g��"Program Files"�ɃC���X�g�[��



2. MinGW�̃C���X�g�[��

    2.1 MinGw���� C:\MinGW �ɃC���X�g�[��
        msys �����
            ##�s�v? Windows�̊��ϐ��ݒ�
            ##�s�v?    WD = C:\MinGW\msys\1.0\\bin\
            ##�s�v?    COMSPEC = C:\WINDOWS\SysWOW64\cmd.exe
            ##�s�v?      (32bit�łł� COMSPEC = %SystemRoot%\system32\cmd.exe )
            ##�s�v?    MSYSCON = sh.exe
            ##�s�v?    MSYSTEM = MINGW32

    2.2 Git for Windows �� C:\MinGW\Git �ɃC���X�g�[��
        �����R�[�h�͂��̂܂܂�I��

    2.3 ���L��t�H���_���쐬
        "C:\MinGW\msys\1.0\mingw\" 

    2.4 C:\MinGW\msys\1.0\etc\fstab ��p�Ӊ��L�ݒ�
        c:/MinGW        /mingw

    2.5 C:\MinGW\msys\1.0\etc\profile �ɉ��L�ݒ�ǋL

        export LOCATIONTYPE="MYHOME"
                or 
        export LOCATIONTYPE="OFFICE"

    2.6 ConEmu �� Commands�ݒ蕔�ɉ��L���L��
    C:\MinGW\msys\1.0\bin\bash.exe --login -i
    (�X�^�[�g�A�b�v�f�B���N�g���͊��ϐ�HOME�Ō��܂�j 


3. Cygwin�̃C���X�g�[��
    3.1 �f�t�H���g�ŃC���X�g�[��

    3.2 �ݒ� Commands�ݒ蕔�ɉ��L���L��

        %SystemDrive%\Cygwin64\bin\bash.exe --login -i
            or
        %SystemDrive%\Cygwin\bin\bash.exe --login -i

    3.3HOME�f�B���N�g�����}�E���g����
        �Ecygwin/home/nori �f�B���N�g�����쐬
        �E/etc/fstab�ɉ��L�s�L��
            C:/Users/Norikatsu/Documents /home/nori ntfs override,binary,auto 0 0


4. Putty�̐ݒ�
    conoha�ւ̐ڑ��ݒ�
    �@�ڑ� keepalive ��60�ɐݒ肷�邱�Ƃ�Y�ꂸ��
    

5. �����[�g�T�[�o�ւ̌��A�b�v
    codebreak  -> id_rsa.pub ���A�b�v
    conoha     -> id_rsa.pub ��putty������ Pub�L�[���A�b�v


6. dotfiles�̐ݒ�
    6.1 �T�[�o����N���[��
        msys �z�[���ɂ�
        git clone ssh://norikatsu@git.codebreak.com/norikatsu/dotfiles.git

    6.2 �e�ݒ�t�@�C���ւ̃����N�𒣂�
        �Ǘ��Ҍ�����CMD���N��
        mklink .bashrc .\dotfiles\.bashrc
        mklink /D .vim .\dotfiles\.vim\
        ......



7. Vagrant�C���X�g�[��
    7.1 VirtualBox, Vagrant�C���X�g�[���̓f�t�H���g�p�X
    7.2 bash_profile�� VirtualBox�̃p�X�ǉ��i���łɋL�ڍς݁j


    7.3 �g����
        a. vagrant box add NAME URL
            cd �C�ӂ̃t�H���_
            vagrant box list          -> ���݂�box�̃��X�g���\�������
            vagrant box remove NAME   -> box�̍폜

        b. vagrant init NAME    �J�����g��Vagrantfile���쐬�����@�����ҏW����

        c.  vagrant up  �@�@�@�@�@�N��
            vagrant ssh           ���O�C��
            vagrant halt          �I��

        d.  ��Ƃ������C�ӂ̃t�H���_�ŉ��L�R�}���h���s
            vagrant package --output PACKNAME

             ��L�p�b�P�[�W�̎g������
            vagrant box add NAME PACKNAME



