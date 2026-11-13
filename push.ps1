<#
  聊记 · 一键发布到 GitHub Pages
  用法：在本目录右键 → 在此处打开 PowerShell，然后运行
        powershell -ExecutionPolicy Bypass -File .\push.ps1
  前提：已安装 GitHub CLI（gh）并完成登录（gh auth login）
#>

$ErrorActionPreference = 'Stop'
$DIR   = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO  = 'chat-ledger'
$PROXY = 'http://127.0.0.1:7890'   # 本地代理，github.com 直连会超时；没有代理就把它改成空字符串

if ($PROXY) {
  $env:HTTPS_PROXY = $PROXY
  $env:HTTP_PROXY  = $PROXY
  git -C $DIR config http.proxy $PROXY
}

Write-Host "[1/4] 检查 gh 登录状态…" -ForegroundColor Cyan
gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Host "  未登录。先运行： gh auth login -h github.com -p https -w" -ForegroundColor Yellow
  Write-Host "  （选 HTTPS，用浏览器登录；2FA 就在浏览器里过）" -ForegroundColor Yellow
  exit 1
}

$USER = (gh api user --jq .login).Trim()
Write-Host "  已登录：$USER" -ForegroundColor Green

Write-Host "[2/4] 创建远程仓库 $USER/$REPO …" -ForegroundColor Cyan
gh repo view "$USER/$REPO" *> $null
if ($LASTEXITCODE -ne 0) {
  gh repo create "$USER/$REPO" --public --description "聊记 —— 聊天式记账 PWA：发一句「午饭12」就记好，纯本地存储、零服务器" | Out-Null
  Write-Host "  已创建" -ForegroundColor Green
} else {
  Write-Host "  已存在，跳过" -ForegroundColor DarkGray
}

Write-Host "[3/4] 推送代码…" -ForegroundColor Cyan
git -C $DIR remote remove origin 2>$null
git -C $DIR remote add origin "https://github.com/$USER/$REPO.git"
git -C $DIR push -u origin main
if ($LASTEXITCODE -ne 0) { Write-Host "  推送失败，检查代理/网络" -ForegroundColor Red; exit 1 }

Write-Host "[4/4] 开启 Pages（GitHub Actions 模式）…" -ForegroundColor Cyan
gh api -X POST "repos/$USER/$REPO/pages" -f build_type=workflow *> $null
if ($LASTEXITCODE -ne 0) {
  gh api -X PUT "repos/$USER/$REPO/pages" -f build_type=workflow *> $null
}

$URL = "https://$USER.github.io/$REPO/"
Write-Host ""
Write-Host "完成。等 1～2 分钟 Actions 跑完，然后打开：" -ForegroundColor Green
Write-Host "  $URL" -ForegroundColor Cyan
Write-Host ""
Write-Host "iPhone 上用 Safari 打开这个地址 → 分享 → 添加到主屏幕。" -ForegroundColor Green
