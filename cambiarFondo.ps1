If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Si no está siendo ejecutado como administrador, relanzar el script con privilegios elevados
    Start-Process powershell -Verb runAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Definition + "`"")
    Exit
}
# Definir la ruta local donde se guardará la imagen
$localPath = "C:\Users\Public\Pictures\Logo_Grupo_ACS.png"

# Definir la URL de la imagen en Azure Blob Storage
$blobUri = "https://stdrpimagenavd.blob.core.windows.net/contenedor-imagen/Logo_Grupo_ACS.png"

# Descargar la imagen desde Azure Blob Storage
try {
    Invoke-WebRequest -Uri $blobUri -OutFile $localPath
    Write-Host "La imagen se descargó correctamente en $localPath."
} catch {
    Write-Host "Error al descargar la imagen: $_"
    exit 1
}

# Verificar si la imagen fue descargada exitosamente
if (Test-Path $localPath) {
    # Establecer la imagen como fondo de pantalla
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name wallpaper -Value $localPath

    # Actualizar el fondo de pantalla
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
    Write-Host "El fondo de pantalla ha sido actualizado con éxito."

    # Borrar la imagen después de establecer el fondo de pantalla
    Remove-Item -Path $localPath -Force
    Write-Host "La imagen en $localPath ha sido eliminada."
} else {
    Write-Host "No se encontró la imagen en la ruta $localPath. No se pudo actualizar el fondo de pantalla."
}
gpupdate /force
