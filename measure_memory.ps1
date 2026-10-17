
$ErrorActionPreference = "Stop"

$python = (Get-Command py).Source
$rscript = "C:\Program Files\R\R-4.3.0\bin\Rscript.exe"
$root = $PSScriptRoot

$targets = @(
    @{
        Name = "Python"
        Executable = $python
        Arguments = "-u `"$root\python\regression.py`""
    },
    @{
        Name = "R"
        Executable = $rscript
        Arguments = "`"$root\R\regression.R`""
    }
)

foreach ($target in $targets) {
    Write-Host "`nMeasuring $($target.Name)..."

    $process = Start-Process `
        -FilePath $target.Executable `
        -ArgumentList $target.Arguments `
        -PassThru

    $peakMB = 0

    while (-not $process.HasExited) {
        $process.Refresh()

        if (-not $process.HasExited) {
            try {
                $process.Refresh()
                $currentMB = $process.WorkingSet64 / 1MB

                if ($currentMB -gt $peakMB) {
                    $peakMB = $currentMB
                }
            } catch {}

            Start-Sleep -Milliseconds 10
        }
    }

    Write-Host "$($target.Name) exit code: $($process.ExitCode)"
    Write-Host ("Peak sampled working set: {0:N2} MB" -f $peakMB)
}
