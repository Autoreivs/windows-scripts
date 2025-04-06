function Rename-PC {
    <#
        .SYNOPSIS
        Prompt user for a new computer name, validate, and rename the PC.
    #>

    do {
        $NewName = Read-Host "Enter the new computer name (max 15 chars, no special characters)"

        # Validate: 1–15 characters, only letters/numbers/hyphens, cannot start or end with hyphen
        if ($NewName.Length -le 15 -and ($NewName -match '^[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]$' -or $NewName -match '^[a-zA-Z0-9]$')) {
            Write-Host "New computer name will be: $NewName. Remember to restart the PC."
            $confirm = Read-Host "Confirm rename to '$NewName'? (Y/N)"
            if ($confirm -match '^(y|yes)$') {
                Rename-Computer -NewName $NewName -Force
                return
            }
        } else {
            Write-Warning "Invalid name. Must be 1-15 characters, only letters, numbers, or hyphens. Cannot start or end with a hyphen."
        }
    } while($true)
}

function  Initialize-FolderStructure {
    param (
        [string]$BasePath = "C:\ServerFiles"
    )
    
    $folders = @(
        "$BasePath",
        "$BasePath\Logs",
        "$BasePath\Configs",
        "$BasePath\Software",
        "$BasePath\Software\Scripts",
        "$BasePath\Backups",
        "$BasePath\Notes"
    )

    foreach ($folder in $folders) {
        if (-not (Test-Path $folder)) {
            New-Item -Path $folder -ItemType Directory -Force | Out-Null
            Write-Host "Created folder: $folder"
        } else {
            #Write-Host "Folder already exists: $folder"
        }
    }
}

function Initialize-BaseSetup {
    Rename-PC
    Initialize-FolderStructure
}

Initialize-BaseSetup