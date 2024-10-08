# RDP-Administration-by-PowerShell
Script de PowerShell para administrar el Escritorio Remoto en un sistema Windows Server 2022

### Descripción

Este script de PowerShell te permite controlar de manera sencilla el estado del Escritorio Remoto en un servidor Windows Server 2022. Actualmente ofrece las siguientes funcionalidades:

* **Verificar estado:** Muestra si el Escritorio Remoto está habilitado o deshabilitado revisando el registro de Windows, así como el estado de las reglas del firewall relacionadas.
* **Habilitar:** Permite habilitar el Escritorio Remoto modificando los valores del registro y las reglas del firewall.
* **Deshabilitar:** Deshabilita el Escritorio Remoto modificando los valores del registro y las reglas del firewall.

Estas funcionalidades se mejoraran y se añadiran nuevas funciones con el paso del tiempo. 

### Requisitos previos

* **PowerShell:** Versión 5.1 o superior.
* **Privilegios administrativos:** El script debe ejecutarse con privilegios de administrador.

### Instalación

1. **Descarga:** Descarga el script y guárdalo en una ubicación accesible.
2. **Ejecución:** Abre una ventana de PowerShell con privilegios administrativos y ejecuta el script utilizando el siguiente comando:

   ```powershell
   .\menuRDP.ps1

### Uso
Una vez ejecutado el script, se mostrará un menú interactivo con las siguientes opciones:
1. **Estado RDP:** Muestra el estado actual del Escritorio Remoto.
2. **Habilitar RDP:** Habilita el Escritorio Remoto y habilita las reglas del firewall necesarias.
3. **Deshabilitar RDP:** Deshabilita el Escritorio Remoto y deshabilita las reglas del firewall para no permitir conexiones.
Q **Salir:** Sale del script.

### Consideraciones importantes
* **Seguridad:** Habilitar el Escritorio Remoto puede aumentar la exposición de tu sistema. Utiliza contraseñas fuertes y considera implementar medidas de seguridad adicionales. Ten en cuenta que se habilita el puerto RDP por defecto (3389).
* **Compatibilidad:** Este script está creado y probado en Windows Server 2022. Puede haber variaciones en otros sistemas operativos, esto no significa que no vaya a funcionar en otros SO

### Disclaimer
Este script ha sido desarrollado como un proyecto personal para aprender y explorar las capacidades de PowerShell. Si bien se ha hecho todo lo posible para garantizar su correcto funcionamiento, es posible que contenga errores o limitaciones. 
El autor no se hace responsable de ningún daño o pérdida que pueda resultar del uso de este script. Se recomienda utilizar este script bajo su propia responsabilidad y realizar las pruebas necesarias antes de implementarlo en un entorno de producción.
