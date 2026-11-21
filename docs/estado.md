# Estado del proyecto — corte 2026-11-21

Este estado se reconstruye con información de las sesiones de trabajo y fuentes localizadas en Drive. **Todo material migrado después debe registrar su versión y una prueba de reproducción.**

| ID | Componente | Evidencia/localización inicial | Estado de migración | Criterio para cerrar |
|---|---|---|---|---|
| VR-01 | Proyecto Unity y APK | `VRRoom_fuente_20261118_1121.zip` mencionado en conversaciones | **Por importar** | abrir proyecto, documentar versión de Unity/SDK, reproducir comunicación |
| FW-01 | Receptor UDP | `ESP_UDP_receptor(1).ino` mencionado en conversaciones | **Por importar** | identificar commit/sketch de integración y contrato UDP |
| FW-02 | Actuadores | sketches ERM y electroimán de trabajo | **Por importar** | prueba de banco independiente y asignación final GPIO |
| ELE-01 | PCB y Gerbers | Drive: Desarrollo tesis / PCB | **Documentación localizada, no importada** | identificar esquemático, PCB y Gerber de la misma revisión |
| MEC-01 | CAD del guante | Drive: Desarrollo tesis / Mecánica / CAD | **4 originales CAD importados** | comparar CAD vs guante real y fijaciones |
| SMA-01 | Simulación | Drive: Simulacion_SMA_Tesis | **Modelo MATLAB y documentación importados** | separar parámetros medidos y supuestos |
| ERM-01 | Modelo eléctrico | Drive: Documentacion_para_tesis | **Script MATLAB y guía importados** | conservar la advertencia de parámetros hipotéticos |
| P25-01 | LTspice/MATLAB | Drive: Simulaciones_P25_LTspice_y_MATLAB | **4 esquemas, script y figuras importados** | ejecutar y adjuntar logs reales antes de citar resultados |
| PR-01 | Protocolo principal | `Protocolo_Pruebas_Guante_Haptico_COMPLETO_FINAL_20261121(1).xlsx`, conversación | **Por importar** | versión única, diccionario de datos, anexos e imágenes |
| PR-02 | Ensayos P25 | `P25_PRUEBAS_UNIFICADO_V1_6(1).zip`, conversación | **Por importar** | clasificar eléctricos/mecánicos; identificar pendientes |

## Riesgos abiertos de prioridad alta

- **Reconocimiento de mano** con el guante colocado en Meta Quest 3S.
- **Coherencia de PCB**: documentación histórica de ERM identifica designadores y revisiones no coincidentes; se ha señalado una posible inversión de C4 en CAD y discrepancias entre redes GPIO y pads. **No asumir que corresponden a la placa montada**; cotejar antes de energizar.
- **SMA y temperatura**: investigación en banco, no disponible para pruebas con participantes sin controles térmicos.
- **Trazabilidad**: evitar mezclar capturas, tablas, Gerbers y código de revisiones diferentes.

## Datos preliminares a auditar

Se han reportado ensayos de integración, tiempos de comunicación y valoraciones de textura. Se conservarán como resultados definitivos **solo después de localizar los CSV, identificar las corridas y verificar el método de cálculo**. En particular, no confundir un tiempo ida-vuelta de comunicaciones con latencia total de la percepción.

**Importación verificada de 20 archivos:** registro con SHA-256 en `docs/importaciones_2026-11-21.csv`. No se ha importado el proyecto Unity, el firmware integrado final ni el protocolo Excel del 21-11-2026.
