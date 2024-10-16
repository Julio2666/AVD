# Verificar si el script está siendo ejecutado como administrador
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Si no está siendo ejecutado como administrador, relanzar el script con privilegios elevados
    Start-Process powershell -Verb runAs -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Definition + "`"")
    Exit
}

# Tu script continúa aquí...
Set-TimeZone -Id "Romance Standard Time"
# Otros comandos que requieren permisos de administrador
