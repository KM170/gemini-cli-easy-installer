@echo off
SETLOCAL EnableDelayedExpansion

:: ������Node.js�̕W���p�X��ʂ��Ă���
set "PATH=%ProgramFiles%\nodejs;%PATH%"

echo ================================================================
echo     Gemini CLI �ȒP�C���X�g�[���[ for Windows �o�b�`�t�@�C��
echo ================================================================
echo.

:: --- Node.js��PC�ɃC���X�g�[������Ă��邩�m�F ---
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
  rem --- Node.js��PC�ɖ����ꍇ�̏��� ---
  echo Node.js��������܂���ł����B�C���X�g�[�����J�n���܂��B
  echo.
  
  where winget >nul 2>&1 || (
    echo [�G���[] winget �R�}���h��������܂���B
    echo Windows 10/11�̍ŐV�ł������p�����������AMicrosoft Store����
    echo �u�A�v�� �C���X�g�[���[�v���C���X�g�[�����Ă��������B
    echo.
    pause
    exit /b 1
  )

  echo [�i��] Node.js LTS�ł��C���X�g�[�����ł�...
  echo ���̏����ɂ͐���������ꍇ������܂��B���΂炭���҂���������...
  winget install OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements
  
  echo.
  echo ==============================�y�d�v�z==============================
  echo   Node.js�̃C���X�g�[�����������܂����B
  echo.
  echo   �Z�b�g�A�b�v�𑱂���ɂ́A�V�����ݒ���V�X�e���ɔ��f������
  echo   �K�v������܂��B
  echo.
  echo   ���萔�ł����A��x���̃E�B���h�E���y���āz����A
  echo   ������x���̃t�@�C�������s���Ă��������B
  echo ====================================================================
  echo.
  pause
  exit /b
)

:: --- �������牺�̏����́ANode.js������PC�ɓ����Ă���ꍇ�̂ݎ��s����� ---

echo --- [�X�e�b�v 1/3] Node.js �̏�Ԃ��m�F��...
echo   �C���X�g�[���ς݂̃o�[�W����:
node -v

rem --- v1.0�̊m���ȍX�V�`�F�b�N�����𕜊� ---
rem �X�V�O�̃o�[�W�������L�^
for /f "tokens=*" %%v in ('node -v') do set "ver_before=%%v"

rem �o�[�W�����Ɋւ�炸�A�K���X�V�����݂�
winget upgrade OpenJS.NodeJS.LTS --silent >nul 2>&1

rem �X�V��̃o�[�W�������ēx�擾
for /f "tokens=*" %%v in ('node -v') do set "ver_after=%%v"

rem �X�V�O��Ńo�[�W�������ω���������r
if "!ver_before!" NEQ "!ver_after!" (
  echo   OK. �X�V���K�p����A�ŐV�łɂȂ�܂����B
) else (
  echo   OK. ���ɍŐV�̃o�[�W�������C���X�g�[������Ă��܂��B
)
echo.

echo --- [�X�e�b�v 2/3] Gemini CLI �̃C���X�g�[��/�X�V��...
echo   (���̏����ɂ�1-2���قǂ�����ꍇ������܂�)
echo.

call npm install -g @google/gemini-cli

rem --- �C���X�g�[���̐��ۂ��A�R�}���h�̑��ݗL���Ŋm���ɔ��� ---
where gemini >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
  echo.
  echo [�G���[] Gemini CLI�̃C���X�g�[���Ɏ��s���܂����B
  echo.
  echo   �� �l�����錴���ƑΏ��@
  echo   --------------------------------------------------------
  echo    1. �l�b�g���[�N�ڑ��̖��
  echo       �� �C���^�[�l�b�g�ڑ����m�F���Ă��������B
  echo.
  echo    2. �����̖��
  echo       �� ���̃o�b�`�t�@�C�����u�Ǘ��҂Ƃ��Ď��s�v�ōĎ��s���Ă��������B
  echo.
  echo    3. npm �L���b�V���̖��
  echo       �� �Ǘ��Ҍ����̃R�}���h�v�����v�g�ňȉ������s��A�Ď��s���Ă�������:
  echo          npm cache clean --force
  echo   --------------------------------------------------------
  echo.
  pause
  exit /b 1
)
echo   OK. Gemini CLI �̃C���X�g�[��/�X�V���������܂����B
echo.

echo --- [�X�e�b�v 3/3] �d�グ�ƋN��...
echo   �f�X�N�g�b�v�ɃV���[�g�J�b�g���쐬���Ă��܂�...

set "SHORTCUT_PATH=%USERPROFILE%\Desktop\Gemini CLI.lnk"
powershell -ExecutionPolicy Bypass -Command "$WshShell = New-Object -ComObject WScript.Shell; try { $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = 'powershell.exe'; $Shortcut.Arguments = '-ExecutionPolicy Bypass -NoExit -Command \"gemini\"'; $Shortcut.WorkingDirectory = '%USERPROFILE%'; $Shortcut.IconLocation = 'powershell.exe,0'; $Shortcut.Description = 'Gemini CLI ���N�����܂�'; $Shortcut.Save() } catch {}" >nul 2>&1

if exist "%SHORTCUT_PATH%" (
  echo   OK. �f�X�N�g�b�v�ɁuGemini CLI.lnk�v�V���[�g�J�b�g���쐬���܂����B
) else (
  echo   [�x��] �V���[�g�J�b�g�̍쐬�Ɏ��s���܂����B
)
echo.
echo ======================================================================
echo   �� �Z�b�g�A�b�v���������܂����I ��
echo ======================================================================
echo.
echo   �� �d�v�F����N�����̎菇
echo   ----------------------------------------------------------------
echo   ���̌�A�N������PowerShell�ŁA����݈̂ȉ��̐ݒ���s���Ă��������B
echo.
echo    (1) �e�[�}�̑I�� (Select Theme)
echo        �� �����ڂ̐ݒ�ł��B������肪�Ȃ���΁A���̂܂܁yEnter�L�[�z�B
echo.
echo    (2) �F�ؕ��@�̑I�� (Select Auth Method)
echo        ���uLogin with Google�v���I�����ꂽ��ԂŁyEnter�L�[�z�B
echo.
echo   �u���E�U���N��������A��ʂɏ]��Google�A�J�E���g�Ń��O�C�����Ă��������B
echo.
echo.
echo   �� ����̎g����
echo   ----------------------------------------------------------------
echo   �f�X�N�g�b�v�́uGemini CLI�v�V���[�g�J�b�g����N������̂�
echo   �ł��m���ŁA�S�Ă̋@�\�������p���������܂��B
echo.
echo ======================================================================
echo.
echo �����L�[�������ƁA�V�����E�B���h�E(PowerShell)�� Gemini CLI ���N�����܂�...
pause >nul

start "Gemini CLI" powershell -ExecutionPolicy Bypass -NoExit -Command "gemini"
exit /b

ENDLOCAL