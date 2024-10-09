
function statusRDP {


    # Obtener el estado de Escritorio Remoto en el registro
    $rdpStatus = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections").fDenyTSConnections

    # Comprobar si Escritorio Remoto está habilitado
    if ($rdpStatus -eq 0) {
            #RDP Habilitado
            $reg = 0 
            } 

        elseif ($rdpStatus -eq 1) {
            #RDP Deshabilitado
            $reg = 1 
            }
             
        else {
            #RDP no se puede determinar
            $reg = 2 
            }
        

    # Verificar el estado del firewall para Escritorio Remoto
    $firewallStatus = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*RDP*" -or $_.DisplayName -like "*Escritorio Remoto*" } | Where-Object { $_.Enabled -eq 'True' }
    
    # Verificar si las reglas del firewall están habilitadas
    if ($firewallStatus) {
        #Firewall configurado
        $fir = 0

        } 

    else {
        #Firewall no configurado
        $fir = 1

        }

    return @($reg, $fir)
   
}



function EnableRDP {

    #Modifica el valor del resgistro para permitir conexiones de Escritorio Remoto
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

    #Modificar el valor en el registro para habilitar la autentificacion por red de RDP
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1 
   

    # Obtener todas las reglas del firewall RDP
    $rdpRules = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*RDP*" -or $_.DisplayName -like "*Escritorio Remoto*" }

    # Habilitar todas las reglas encontradas
    foreach ($rule in $rdpRules) {
        Enable-NetFirewallRule -Name $rule.Name
        Write-Host "Regla habilitada: $($rule.DisplayName)"
    } 


}



function DisableRDP {

    #Modifica el valor del resgistro para permiter conexiones de Escritorio Remoto
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1

    #Modificar el valor en el registro para habilitar la autentificacion
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 0

    # Obtener todas las reglas del firewall RDP
    $rdpRules = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*RDP*" -or $_.DisplayName -like "*Escritorio Remoto*" }


    # Deshabilitar todas las reglas encontradas
    foreach ($rule in $rdpRules) {
        Disable-NetFirewallRule -Name $rule.Name
        Write-Host "Regla deshabilitada: $($rule.DisplayName)"
    }

    

}



do {
    Clear-Host
    Write-Host "============MENU RDP=============="
    Write-Host "1) Estado RDP"
    Write-Host "2) Habilitar RDP"
    Write-Host "3) Deshabilitar RDP"
    Write-Host "Q) Salir"
    Write-Host "===================================================="
    
    Write-Host "*IP Publica:" -NoNewline -ForegroundColor Black -BackgroundColor DarkYellow 
    (Invoke-WebRequest http://ipinfo.io/ip).Content 
    Write-Host "*IP Privada:" -NoNewline -ForegroundColor Black -BackgroundColor DarkYellow
    (Get-NetIPAddress | Where-Object { $_.IPAddress -match "\b(?:192\.168|10\.|172\.1[6-9]|172\.2[0-9]|172\.3[0-1])\.\b" }).IPAddress
    $fecha = Get-Date
    Write-Host $fecha -ForegroundColor Black -BackgroundColor Magenta
    Write-Host "===================================================="

    $input= Read-Host "Introduce una opcion: "

    switch ($input){

    '1' {
            $estado = statusRDP


            if ($estado[0] -eq 0 -and $estado[1] -eq 0) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "Escritorio Remoto está " -NoNewline 
                                Write-Host "HABILITADO" -ForegroundColor Black -BackgroundColor Green -NoNewline
                                Write-Host " y el Firewall " -NoNewline 
                                Write-Host "SI" -ForegroundColor Black -BackgroundColor Green -NoNewline 
                                Write-Host " permite conexiones."
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

            }

                elseif ($estado[0] -eq 0 -and $estado[1] -eq 1) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "Escritorio Remoto está " -NoNewline
                                Write-Host "HABILITADO" -ForegroundColor Black -BackgroundColor Green -NoNewline
                                Write-Host " pero el Firewall " -NoNewline
                                Write-Host "NO permite conexiones" -ForegroundColor Black -BackgroundColor Red -NoNewline
                                Write-Host ".Vaya el menu principal y seleccione la opcion 2 para habilitar RDP"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

    
                    }

                        elseif ($estado[0] -eq 1 -and $estado[1] -eq 0) {
                                Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------"                            
                                Write-Host "El Firewall " -NoNewline 
                                Write-Host "SI permite conexiones" -ForegroundColor Black -BackgroundColor Green -NoNewline 
                                Write-Host " pero el Escritorio Remoto esta " -NoNewline 
                                Write-Host "DESHABILITADO" -ForegroundColor Black -BackgroundColor Red -NoNewline 
                                Write-Host ".Vaya el menu principal y seleccione la opcion 2 para habilitar RDP"
                                Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------"

                        }
                            
                            elseif ($estado[0] -eq 1 -and $estado[1] -eq 1) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "El Firewall " -NoNewline
                                Write-Host "NO permite conexiones" -ForegroundColor Black -BackgroundColor Red -NoNewline
                                Write-Host " y el Escritorio Remoto esta " -NoNewline 
                                Write-Host "DESHABILITADO" -ForegroundColor Black -BackgroundColor Red -NoNewline
                                Write-Host ".Vaya el menu principal y seleccione la opcion 2 para habilitar RDP"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                                }

                                    else {
                                            Write-Host "-----------------------------------------"
                                            Write-Host "No se puede determinar el estado del RDP" -ForegroundColor Black -BackgroundColor Red
                                            Write-Host "-----------------------------------------"
                                            }

                                Write-Host " "
                                $salirMenu = $false
                                

        
    }

    '2' {
            $estado = statusRDP
            $on = EnableRDP


            if ($estado[0] -eq 0 -and $estado[1] -eq 0) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP ya estaba HABILITADO" -ForegroundColor Black -BackgroundColor Green
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

            }

                elseif ($estado[0] -eq 0 -and $estado[1] -eq 1) {

                                $on

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "RDP HABILITADO" -ForegroundColor Black -BackgroundColor Green
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

    
                    }

                        elseif ($estado[0] -eq 1 -and $estado[1] -eq 0) {
                        
                                $on

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "RDP HABILITADO" -ForegroundColor Black -BackgroundColor Green
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                        }
                            
                            elseif ($estado[0] -eq 1 -and $estado[1] -eq 1) {
                                
                                $on

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "RDP HABILITADO" -ForegroundColor Black -BackgroundColor Green
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                                }


            Write-Host " "
            $salirMenu = $false
     }

    '3' {
            $estado = statusRDP
            $off = DisableRDP


            if ($estado[0] -eq 0 -and $estado[1] -eq 0) {

                                $off

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP DESHABILITADO" -ForegroundColor Black -BackgroundColor Red
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

            }

                elseif ($estado[0] -eq 0 -and $estado[1] -eq 1) {
                                
                                $off

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP DESHABILITADO" -ForegroundColor Black -BackgroundColor Red
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

    
                    }

                        elseif ($estado[0] -eq 1 -and $estado[1] -eq 0) {
                                
                                $off

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP DESHABILITADO" -ForegroundColor Black -BackgroundColor Red
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                        }
                            
                            elseif ($estado[0] -eq 1 -and $estado[1] -eq 1) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP ya estaba DESHABILITADO" -ForegroundColor Black -BackgroundColor Red
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                                }
                    
                            Write-Host " "
                            $salirMenu = $false

      }

    'Q' {
            $salirMenu = $true
            Write-Host "Saliendo..."
            break
     }

     default {
            Write-Host "Opcion no valida, introduce otra opcion"
     }

    }

    #Bucle que se ejecuta despues de cada opcion para poder elegir si volver al menu principal o salir del programa
    while (!$salirMenu) {
    Write-Host "Volver al menú principal (S/N)?"
        $opcionSalir = Read-Host
        if ($opcionSalir -eq "S") {
          $salirMenu = $true
        } elseif ($opcionSalir -eq "N") {
          $salirMenu = $true
          $input = "Q"
        } else {
          Write-Host "Opción no válida."
        }
  }
    
} while ($input -ne "Q")