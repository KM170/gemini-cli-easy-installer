@echo off
SETLOCAL EnableDelayedExpansion

:: 既存のNode.jsの標準パスを通しておく
set "PATH=%ProgramFiles%\nodejs;%PATH%"

echo ================================================================
echo     Gemini CLI 簡単インストーラー for Windows バッチファイル
echo ================================================================
echo.

:: --- Node.jsがPCにインストールされているか確認 ---
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
  rem --- Node.jsがPCに無い場合の処理 ---
  echo Node.jsが見つかりませんでした。インストールを開始します。
  echo.
  
  where winget >nul 2>&1 || (
    echo [エラー] winget コマンドが見つかりません。
    echo Windows 10/11の最新版をご利用いただくか、Microsoft Storeから
    echo 「アプリ インストーラー」をインストールしてください。
    echo.
    pause
    exit /b 1
  )

  echo [進捗] Node.js LTS版をインストール中です...
  echo この処理には数分かかる場合があります。しばらくお待ちください...
  winget install OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements
  
  echo.
  echo ==============================【重要】==============================
  echo   Node.jsのインストールが完了しました。
  echo.
  echo   セットアップを続けるには、新しい設定をシステムに反映させる
  echo   必要があります。
  echo.
  echo   お手数ですが、一度このウィンドウを【閉じて】から、
  echo   もう一度このファイルを実行してください。
  echo ====================================================================
  echo.
  pause
  exit /b
)

:: --- ここから下の処理は、Node.jsが既にPCに入っている場合のみ実行される ---

echo --- [ステップ 1/3] Node.js の状態を確認中...
echo   インストール済みのバージョン:
node -v

rem --- v1.0の確実な更新チェック方式を復活 ---
rem 更新前のバージョンを記録
for /f "tokens=*" %%v in ('node -v') do set "ver_before=%%v"

rem バージョンに関わらず、必ず更新を試みる
winget upgrade OpenJS.NodeJS.LTS --silent >nul 2>&1

rem 更新後のバージョンを再度取得
for /f "tokens=*" %%v in ('node -v') do set "ver_after=%%v"

rem 更新前後でバージョンが変化したか比較
if "!ver_before!" NEQ "!ver_after!" (
  echo   OK. 更新が適用され、最新版になりました。
) else (
  echo   OK. 既に最新のバージョンがインストールされています。
)
echo.

echo --- [ステップ 2/3] Gemini CLI のインストール/更新中...
echo   (この処理には1-2分ほどかかる場合があります)
echo.

call npm install -g @google/gemini-cli

rem --- インストールの成否を、コマンドの存在有無で確実に判定 ---
where gemini >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
  echo.
  echo [エラー] Gemini CLIのインストールに失敗しました。
  echo.
  echo   ■ 考えられる原因と対処法
  echo   --------------------------------------------------------
  echo    1. ネットワーク接続の問題
  echo       → インターネット接続を確認してください。
  echo.
  echo    2. 権限の問題
  echo       → このバッチファイルを「管理者として実行」で再試行してください。
  echo.
  echo    3. npm キャッシュの問題
  echo       → 管理者権限のコマンドプロンプトで以下を実行後、再試行してください:
  echo          npm cache clean --force
  echo   --------------------------------------------------------
  echo.
  pause
  exit /b 1
)
echo   OK. Gemini CLI のインストール/更新が完了しました。
echo.

echo --- [ステップ 3/3] 仕上げと起動...
echo   デスクトップにショートカットを作成しています...

set "SHORTCUT_PATH=%USERPROFILE%\Desktop\Gemini CLI.lnk"
powershell -ExecutionPolicy Bypass -Command "$WshShell = New-Object -ComObject WScript.Shell; try { $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = 'powershell.exe'; $Shortcut.Arguments = '-ExecutionPolicy Bypass -NoExit -Command \"gemini\"'; $Shortcut.WorkingDirectory = '%USERPROFILE%'; $Shortcut.IconLocation = 'powershell.exe,0'; $Shortcut.Description = 'Gemini CLI を起動します'; $Shortcut.Save() } catch {}" >nul 2>&1

if exist "%SHORTCUT_PATH%" (
  echo   OK. デスクトップに「Gemini CLI.lnk」ショートカットを作成しました。
) else (
  echo   [警告] ショートカットの作成に失敗しました。
)
echo.
echo ======================================================================
echo   ★ セットアップが完了しました！ ★
echo ======================================================================
echo.
echo   ■ 重要：初回起動時の手順
echo   ----------------------------------------------------------------
echo   この後、起動するPowerShellで、初回のみ以下の設定を行ってください。
echo.
echo    (1) テーマの選択 (Select Theme)
echo        → 見た目の設定です。こだわりがなければ、そのまま【Enterキー】。
echo.
echo    (2) 認証方法の選択 (Select Auth Method)
echo        →「Login with Google」が選択された状態で【Enterキー】。
echo.
echo   ブラウザが起動したら、画面に従いGoogleアカウントでログインしてください。
echo.
echo.
echo   ■ 今後の使い方
echo   ----------------------------------------------------------------
echo   デスクトップの「Gemini CLI」ショートカットから起動するのが
echo   最も確実で、全ての機能をご利用いただけます。
echo.
echo ======================================================================
echo.
echo 何かキーを押すと、新しいウィンドウ(PowerShell)で Gemini CLI を起動します...
pause >nul

start "Gemini CLI" powershell -ExecutionPolicy Bypass -NoExit -Command "gemini"
exit /b

ENDLOCAL