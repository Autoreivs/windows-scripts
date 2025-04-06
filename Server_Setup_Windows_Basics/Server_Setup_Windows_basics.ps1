function Rename-PC {
    <#
        .SYNOPSIS
        Prompt user for a new computer name, validate, and rename the PC.
    #>

    do {
        $NewName = Read-Host "Enter the new computer name (max 15 chars, no special characters)"

        # Validate: 1–15 characters, only letters/numbers/hyphens, cannot start or end with hyphen
        if ($NewName -match '^[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,13}[a-zA-Z0-9])?$') {
            Write-Host "New computer name will be: $NewName. Remember to restart the PC."
            $confirm = Read-Host "Confirm rename to '$NewName'? (Y/N)"
            if ($confirm -eq 'Y') {
                Rename-Computer -NewName $NewName -Force
                return
            }
        } else {
            Write-Warning "Invalid name. Must be 1–15 characters, only letters, numbers, or hyphens. Cannot start or end with a hyphen."
        }
    } while ($true)
}

function Initialize-FolderStructure {
    param (
        [string]$BasePath = "C:\ServerFiles"
    )

    $folders = @(
        "$BasePath\Logs",
        "$BasePath\Configs",
        "$BasePath\Software",
        "$BasePath\Software\Scripts",
        "$BasePath\Backups",
        "$BasePath\Notes"
    )

    if (-not (Test-Path $BasePath)){
        New-Item -Path $BasePath -ItemType Directory -Force | Out-Null
        Write-Host "Created folder: $BasePath"
    }

    foreach ($folder in $folders) {
        if (-not (Test-Path $folder)) {
            New-Item -Path $folder -ItemType Directory -Force | Out-Null
            Write-Host "Created folder: $folder"
        } else {
            Write-Host "Folder already exists: $folder"
        }
    }
}

function Set-StaticInfo {
    Write-Host "Setting static information (placeholder)"
    # TODO: Add logic for hostname tagging, notes, or config metadata
}


function Initialize-BaseSetup {
    Rename-PC
    Initialize-FolderStructure
}

Initialize-BaseSetup