function Invoke-MSI {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath,
        [string]$Transform,
        [Parameter(Mandatory)]
        [ValidateSet("Install", "Uninstall")]
        [string]$Action,
        [bool]$Quiet = $true,
        [bool]$NoRestart = $true,
        [string[]]$AdditionalArguments
    )
    $arguments = @()
    if ($Action -eq "Install") {
        $arguments += "/i"
    } elseif ($Action -eq "Uninstall") {
        $arguments += "/x"
    }
    if ($Quiet) {
        $arguments += "/qn"
    }
    if ($NoRestart) {
        $arguments += "/norestart"
    }
    if ($AdditionalArguments) {
        $arguments += $AdditionalArguments
    }
    $extension = [System.IO.Path]::GetExtension($FilePath)
    if ($extension -eq ".msi") {
        $arguments += "`"$FilePath`""
        if ($Transform) {
            if ([System.IO.Path]::GetExtension($Transform) -eq ".mst") {
                $arguments += "TRANSFORMS=`"$Transform`""
            } else {
                Write-Error "Transform must be an MST file"
                return
            }
        }
    } elseif ($extension -eq ".msp") {
        $arguments += "`"$FilePath`""
    } else {
        Write-Error "Unsupported file type: $extension"
        return
    }
    try {
        Invoke-Process -FilePath "msiexec.exe" -Arguments $arguments
    } catch {
        Write-Error $_.Exception.Message
    }
}
