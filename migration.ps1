$packageDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$zipFile    = Join-Path $packageDir "Offices.zip"

#Verification du fichier zip
if (-not (Test-Path $zipFile)) {
    Write-Host "Le fichier $zipFile est introuvable." 
    Write-Host "Script terminé" 
    exit 1 
}

function Install2024 {
    Set-Location $env:TEMP
    if (Test-Path "$env:TEMP\Office2019Uninstall") {
        Write-Host "Nettoyage des fichiers temporaires..."
        Remove-Item -Recurse -Force "$env:TEMP\Office2019Uninstall"
        if (Test-Path "$env:TEMP\Office2019Uninstall") {
            Write-Host "Le dossier temporaire n'a pas été supprimé." #TEXT SENSITIVE
        } else {
            Write-Host "Le dossier temporaire a été supprimé avec succès." 
        }
    }
    #Installation de 2024 à partir du zip
    $tempDir = Join-Path $env:TEMP "Office2024"
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    Expand-Archive -Path $zipFile -DestinationPath $tempDir

    $installerPath = Join-Path $tempDir ".\Offices\setup.exe"
    if (Test-Path $installerPath) {
        $configPath = Join-Path $tempDir "Offices\configuration.xml"
        Start-Process -FilePath $installerPath -ArgumentList "/configure `"$configPath`"" -Wait -WorkingDirectory (Join-Path $tempDir "Offices")
        Write-Host "Verification de l'installation de Office 2024..."
        if (Test-Path "C:\Program Files\Microsoft Office\root\Office16") {
            Write-Host "Installation de Office 2024 réussie."
            Write-Host "Nettoyage des fichiers temporaires..."
            Remove-Item -Recurse -Force $tempDir  
            if (Test-Path $tempDir) {
                Write-Host "Le dossier temporaire n'a pas été supprimé." #TEXT SENSITIVE
                exit 0
            } else {
                Write-Host "Le dossier temporaire a été supprimé avec succès." 
                exit 0
            } 
        } else {
            Write-Host "Installation de Office 2024 échouée."
            Write-Host "Nettoyage des fichiers temporaires..."
            Remove-Item -Recurse -Force $tempDir  
            if (Test-Path $tempDir) {
                Write-Host "Le dossier temporaire n'a pas été supprimé." #TEXT SENSITIVE
                exit 1
            } else {
                Write-Host "Le dossier temporaire a été supprimé avec succès." 
                exit 1
            }
        }
    } else {
        Write-Host "Le fichier d'installation setup.exe est introuvable dans le zip."
        Write-Host "Nettoyage des fichiers temporaires..."
        Remove-Item -Recurse -Force $tempDir
        if (Test-Path $tempDir) {
            Write-Host "Le dossier temporaire n'a pas été supprimé." #TEXT SENSITIVE
            exit 1
        } else {
            Write-Host "Le dossier temporaire a été supprimé avec succès." 
            exit 1
        }
    }
}

function Uninstall2019 {
    $tempDir = Join-Path $env:TEMP "Office2019Uninstall"
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    Expand-Archive -Path $zipFile -DestinationPath $tempDir
    Set-Location $tempDir
    $saraPath = Join-Path $tempDir ".\Offices\setup.exe"
    if (Test-Path $saraPath) {
        $configPath = Join-Path $tempDir "Offices\remove.xml"
        Start-Process -FilePath $saraPath -ArgumentList "/configure `"$configPath`"" -Wait -WorkingDirectory (Join-Path $tempDir "Offices")
        if (Test-Path "C:\Program Files\Microsoft Office\root\Office16") {
            Write-Host "La désinstallation de Office 2019 a échoué."
            Remove-Item -Recurse -Force $tempDir
            exit 1
        } else {
            Write-Host "La désinstallation de Office 2019 a réussi."
        }
    } else {
        Write-Host "Le fichier setup.exe est introuvable dans le zip."
        Write-Host "Nettoyage des fichiers temporaires..." 
        Remove-Item -Recurse -Force $tempDir
        if (Test-Path $tempDir) {
            Write-Host "Le dossier temporaire n'a pas été supprimé." #TEXT SENSITIVE
            exit 1
        } else {
            Write-Host "Le dossier temporaire a été supprimé avec succès." 
            exit 1
        }
    }
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Ce script doit être exécuté en tant qu'administrateur." 
    Write-Host "Script terminé" 
    exit 1 
}

#Verification installation de Office 2019
$officeInstallPath = "C:\Program Files\Microsoft Office\root\Office16"
if (Test-Path $officeInstallPath) {
    Write-Host "Office 2019 est déjà installé."
    Write-Host "Suppression de Office 2019..."
    Uninstall2019
}

Write-Host "Installation de Office 2024..."
Install2024