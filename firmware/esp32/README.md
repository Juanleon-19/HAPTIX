# Firmware ESP32

Esta carpeta espera **los sketches originales aprobados**, no un ejemplo ficticio presentado como firmware funcional.

## Estructura prevista

- `receptor_udp/`: sketch de comunicación ESP32 ↔ Unity.
- `actuadores/erm/`: pruebas unitarias ERM.
- `actuadores/electromagnetico/`: pruebas unitarias freno.
- `actuadores/sma_banco/`: solo código de ensayo en banco, sujeto a seguridad.
- `integracion/`: versión congelada de la aplicación de tres etapas con telemetría.

## Requisitos de cada sketch importado

Versión del core ESP32, librerías exactas, placa, voltaje, pinout medido, cableado, formato UDP, ejemplo de salida serial, instrucciones para cargar y **cómo apagar el sistema de forma segura**. Nunca incluir SSID ni contraseña reales.

Ver [plantilla de configuración](config.example.h), que no es firmware ejecutable por sí sola.
