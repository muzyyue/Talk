@echo off
echo ========================================
echo 清理并重建 Flutter Windows 项目
echo ========================================
echo.

echo [1/4] 清理构建缓存...
flutter clean
if %errorlevel% neq 0 (
    echo 清理失败！
    pause
    exit /b 1
)

echo.
echo [2/4] 获取依赖...
flutter pub get
if %errorlevel% neq 0 (
    echo 获取依赖失败！
    pause
    exit /b 1
)

echo.
echo [3/4] 检查代码...
flutter analyze
if %errorlevel% neq 0 (
    echo 代码检查发现错误，但继续构建...
)

echo.
echo [4/4] 构建 Windows 应用...
flutter build windows --release
if %errorlevel% neq 0 (
    echo 构建失败！
    pause
    exit /b 1
)

echo.
echo ========================================
echo 构建成功！
echo 可执行文件位置：build\windows\x64\runner\Release\talk.exe
echo ========================================
pause
