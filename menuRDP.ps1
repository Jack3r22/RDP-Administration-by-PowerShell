
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
    $firewallStatus = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*RDP*" -or $_.DisplayName -like "*Escritorio Remoto*" }
    #Get-NetFirewallRule -DisplayGroup "Escritorio Remoto" | Where-Object { $_.Enabled -eq 'True' }

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
    Write-Host "=================================="

    $input= Read-Host "Introduce una opcion: "

    switch ($input){

    '1' {
            $estado = statusRDP


            if ($estado[0] -eq 0 -and $estado[1] -eq 0) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "Escritorio Remoto está HABILITADO y el Firewall SI permite conexiones."
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

            }

                elseif ($estado[0] -eq 0 -and $estado[1] -eq 1) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "Escritorio Remoto está HABILITADO pero el Firewall NO permite conexiones.Vaya el menu principal y seleccione la opcion 2 para habilitar RDP"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

    
                    }

                        elseif ($estado[0] -eq 1 -and $estado[1] -eq 0) {
                                Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------"                            
                                Write-Host "El Firewall SI permite conexiones pero el Escritorio Remoto esta DESHABILITADO.Vaya el menu principal y seleccione la opcion 2 para habilitar RDP"
                                Write-Host "----------------------------------------------------------------------------------------------------------------------------------------------------"

                        }
                            
                            elseif ($estado[0] -eq 1 -and $estado[1] -eq 1) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "El Firewall NO permite conexiones y el Escritorio Remoto esta DESHABILITADO.Vaya el menu principal y seleccione la opcion 2 para habilitar RDP"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                                }

                                    else {
                                            Write-Host "-----------------------------------------"
                                            Write-Host "No se puede determinar el estado del RDP" 
                                            Write-Host "-----------------------------------------"
                                            }

        
    }

    '2' {
            $estado = statusRDP
            $on = EnableRDP


            if ($estado[0] -eq 0 -and $estado[1] -eq 0) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP ya estaba HABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

            }

                elseif ($estado[0] -eq 0 -and $estado[1] -eq 1) {

                                $on

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "RDP HABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

    
                    }

                        elseif ($estado[0] -eq 1 -and $estado[1] -eq 0) {
                        
                                $on

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "RDP HABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                        }
                            
                            elseif ($estado[0] -eq 1 -and $estado[1] -eq 1) {
                                
                                $on

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"                    
                                Write-Host "RDP HABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                                }


            Write-Host "Pulsa cualquier tecla para volver al menu principal..."
            Read-Host -Prompt " "
     }

    '3' {
            $estado = statusRDP
            $off = DisableRDP


            if ($estado[0] -eq 0 -and $estado[1] -eq 0) {

                                $off

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP DESHABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

            }

                elseif ($estado[0] -eq 0 -and $estado[1] -eq 1) {
                                
                                $off

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP DESHABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

    
                    }

                        elseif ($estado[0] -eq 1 -and $estado[1] -eq 0) {
                                
                                $off

                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP DESHABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                        }
                            
                            elseif ($estado[0] -eq 1 -and $estado[1] -eq 1) {
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"
                                Write-Host "RDP ya estaba DESHABILITADO"
                                Write-Host "-----------------------------------------------------------------------------------------------------------------------------------------------"

                                }


      }

    'Q' {
            Write-Host "Saliendo..."
            break
     }

     default {
            Write-Host "Opcion no valida, introduce otra opcion"
     }

    }


    
} while ($input -ne "Q")