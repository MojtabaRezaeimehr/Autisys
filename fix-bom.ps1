# Strips duplicate UTF-8 BOMs from a file (keeps at most one).
# Usage: .\fix-bom.ps1 Main.pas  (or no args = all *.pas/*.fmx in project)
param([string[]]$Paths)

if (-not $Paths) {
    $Paths = Get-ChildItem -Path . -Recurse -Include *.pas,*.fmx,*.dpr | ForEach-Object { $_.FullName }
}

foreach ($p in $Paths) {
    $b = [System.IO.File]::ReadAllBytes($p)
    $start = 0
    # Skip every leading BOM (EF BB BF)
    while ($start + 2 -lt $b.Length -and
           $b[$start -eq 0xEF -and $b[$start+1] -eq 0xBB -and $b[$start+2] -eq 0xBF) {
        $start += 3
    }
    if ($start -gt 3) {
        $fixed = New-Object byte[] (3 + $b.Length - $start)
        $fixed[0..2] = 0xEF,0xBB,0xBF
        [Array]::Copy($b, $start, $fixed, 3, $b.Length - $start)
        [System.IO.File]::WriteAllBytes($p, $fixed)
        Write-Output "$p : removed $($start - 3) extra BOM(s)"
    } else {
        Write-Output "$p : OK"
    }
}
