# cangjie-fuzzy-windows: Cangjie with adjacent-key typo tolerance as the DEFAULT schema (Windows 11 / Weasel).
# Thin front for the base installer of githubhjs/cangjie-fluency, which already contains the full cj*fluency (tables, word list,
# language model) and the typo-tolerant schemas. This script only makes the typo-tolerant schema the FIRST (default) one.
#
#   irm https://raw.githubusercontent.com/githubhjs/cangjie-fuzzy-windows/main/install.ps1 | iex
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/githubhjs/cangjie-fuzzy-windows/main/install.ps1))) -Cangjie5 -FuzzyRange wide
#
# Inside the release zip the base installer sits in .\base\ (fully offline, run install.bat); otherwise it is downloaded from the
# release tag below and checked against the SHA-256 pinned here. ASCII only, no `exit` (it would close your PowerShell under iex).
param(
  [switch]$Cangjie5,
  [switch]$NoDeploy,
  [switch]$NoModel,
  [switch]$NoSweep,
  [string]$PadRef = '',
  [switch]$Offline,
  [switch]$DryRun,
  [switch]$SkipWeaselInstall,
  [ValidateSet('narrow', 'normal', 'wide')][string]$FuzzyRange = 'normal',
  [string]$RimeDir = '',
  [string]$WeaselDir = ''
)
$BaseRepo = 'githubhjs/cangjie-fluency'
$BaseRef = 'v0.6.3'          # pinned by make-release.ps1 / make-release.sh
$BaseSha = 'e7736a655939bfdd63510e22088d4ef47e6038f9f71f6daf2f3fa5175b71386a'      # SHA-256 of install.ps1 at $BaseRef

function Say($m, $zhm) { Write-Host "[cangjie-fuzzy-windows] $m"; if ($zhm) { Write-Host ("[cangjie-fuzzy-windows] " + [regex]::Unescape($zhm)) } }
function Get-Sha256Hex($path) {
  $sha = [Security.Cryptography.SHA256]::Create()
  $fs = [IO.File]::OpenRead($path)
  try { return (($sha.ComputeHash($fs) | ForEach-Object { $_.ToString('x2') }) -join '') } finally { $fs.Dispose(); $sha.Dispose() }
}

& {
  $ErrorActionPreference = 'Stop'
  try {
    $p = @{ FuzzyDefault = $true; FuzzyRange = $FuzzyRange; Ref = $BaseRef }
    if ($Cangjie5) { $p['Cangjie5'] = $true }
    if ($NoDeploy) { $p['NoDeploy'] = $true }
    if ($NoModel) { $p['NoModel'] = $true }
    if ($NoSweep) { $p['NoSweep'] = $true }
    if ($PadRef) { $p['PadRef'] = $PadRef }
    if ($Offline) { $p['Offline'] = $true }
    if ($DryRun) { $p['DryRun'] = $true }
    if ($SkipWeaselInstall) { $p['SkipWeaselInstall'] = $true }
    if ($RimeDir) { $p['RimeDir'] = $RimeDir }
    if ($WeaselDir) { $p['WeaselDir'] = $WeaselDir }

    $bundled = $null
    if ($PSScriptRoot) { $c = Join-Path $PSScriptRoot 'base\install.ps1'; if (Test-Path $c) { $bundled = $c } }
    if ($bundled) {
      Say 'using the bundled base installer (offline bundle)' '\u4f7f\u7528\u96a8\u9644\u7684\u57fa\u790e\u5b89\u88dd\u7a0b\u5f0f\uff08\u96e2\u7dda\u5305\uff09'
      $args2 = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $bundled)
      foreach ($k in $p.Keys) {
        if ($k -eq 'Ref') { continue }
        if ($p[$k] -is [bool]) { $args2 += "-$k" } else { $args2 += "-$k"; $args2 += [string]$p[$k] }
      }
      & powershell @args2
      if ($LASTEXITCODE -ne 0) { throw "base installer failed (exit code $LASTEXITCODE)" }
    } else {
      if ($BaseSha -like '@*') { throw 'this copy has no pinned base checksum (run make-release first)' }
      $url = "https://raw.githubusercontent.com/$BaseRepo/$BaseRef/install.ps1"
      Say "downloading the base installer $BaseRepo@$BaseRef" '\u4e0b\u8f09\u57fa\u790e\u5b89\u88dd\u7a0b\u5f0f'
      $tmp = Join-Path ([IO.Path]::GetTempPath()) ('cjf-fuzzy-base-' + [Guid]::NewGuid().ToString('N') + '.ps1')
      try {
        Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
        $got = Get-Sha256Hex $tmp
        if ($got -ne $BaseSha) { throw "the base installer does not match the pinned SHA-256 (got $got), refusing to run it" }
        $sb = [scriptblock]::Create([IO.File]::ReadAllText($tmp, [Text.Encoding]::UTF8))
        & $sb @p
      } finally { if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue } }
    }
  } catch {
    Write-Host "[cangjie-fuzzy-windows] ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ("[cangjie-fuzzy-windows] " + [regex]::Unescape('\u5df2\u505c\u6b62\uff1b\u505c\u6b62\u4e4b\u524d\u5df2\u5beb\u5165\u7684\u6a94\u6848\u6703\u4fdd\u7559\uff08\u65e2\u6709\u6a94\u6848\u5df2\u5099\u4efd\u6210 *.bak-\u6642\u9593\uff09\u3002')) -ForegroundColor Red
  }
}
