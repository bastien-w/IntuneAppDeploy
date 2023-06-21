function Invoke-Process {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [bool]$Wait = $true
    )
    try {
        $process = Start-Process -FilePath $FilePath -ArgumentList $Arguments -PassThru -ErrorAction Stop
        if ($Wait) {
            $process.WaitForExit()
        }
    } catch {
        Write-Error $_.Exception.Message
    }
}
