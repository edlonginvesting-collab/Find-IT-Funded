# FIND IT FUNDED - NEW REPO PUSH HELPER
# Put this file in the clean website folder, then run it.
# It does not close PowerShell.

$ErrorActionPreference = "Stop"
function Say($m){ Write-Host "`n$m" -ForegroundColor Cyan }
function Stop-Safe($m){ Write-Host "[ERROR] $m" -ForegroundColor Red; throw $m }

Say "Checking clean site files"
foreach ($f in @("index.html","styles.css","404.html","thank-you.html",".nojekyll")) {
  if (!(Test-Path $f)) { Stop-Safe "$f is missing" }
  Write-Host "[OK] $f" -ForegroundColor Green
}

$html = Get-Content "index.html" -Raw
if ($html -match "/src/main\.jsx") { Stop-Safe "Bad React source path found." }
if ($html -match "/assets/") { Stop-Safe "Bad absolute /assets path found." }

Say "Git setup"
if (!(Test-Path ".git")) { git init }

$remote = git remote -v
if ([string]::IsNullOrWhiteSpace($remote)) {
  Write-Host "Paste your new GitHub repo URL, example:" -ForegroundColor Yellow
  Write-Host "https://github.com/YOUR-USERNAME/YOUR-REPO.git" -ForegroundColor Yellow
  $repo = Read-Host "GitHub repo URL"
  if ([string]::IsNullOrWhiteSpace($repo)) { Stop-Safe "No repo URL entered." }
  git remote add origin $repo
}

git branch -M main
git add .
git commit -m "Initial clean Find It Funded website"
git push -u origin main

Say "Done. Now set GitHub Pages: Settings > Pages > Deploy from branch > main > /root > Save"
