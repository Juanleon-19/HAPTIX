# Protocolo VR, comunicación y experiencia

> **Actualización (Excel fuente aportado el 22-11-2026):** los estados del documento preliminar deben leerse junto al [catálogo de las 59 pruebas](../CATALOGO_EXCEL_20261122.md) y [resultados registrados](../RESULTADOS_REPORTADOS_20261122.md). Este documento conserva contexto histórico y propuestas, pero NO sustituye los campos originales de ese Excel.\n\n
## Sistema y condición crítica

Meta Quest 3S → hand tracking → aplicación Unity → comandos UDP → ESP32 → actuación ERM/freno electromagnético. Existe una **incidencia abierta de reconocimiento de manos con el guante colocado**; no presentar la integración como validada sin resolverla.

La aplicación, APK y sketch receptor final **aún no están importados** a este repositorio. Las estructuras aquí descritas son un plan de registro a cotejar contra el código real.

## Matriz preliminar

| Área | Qué comprobar | Evidencia |
|---|---|---|
| Tracking | Mano sin guante vs con guante; condiciones de luz, oclusión y geometría | video/capturas anonimizadas, estado de detección, versión de visor |
| Eventos VR | Identificación de objeto, textura o contacto, etapa y evento | log Unity con timestamp y escena |
| UDP | Emisión/recepción de paquete, pérdida, duplicados y secuencia | mensajes originales, revisión firmware, red usada |
| Actuación | Confirmación de consigna ERM/freno y medición de respuesta física | log ESP32 + instrumento externo |
| Sincronización | Diferenciar retardo de red, electrónica y respuesta mecánica | definición de reloj e instrumentación |
| Respuesta | Tres valores ordinales 1–3 al cierre de cada etapa, **según significado real de la app** | archivo por corrida con actuador y etapa |
| Experiencia | Instrumentos subjetivos si están en protocolo aprobado | cuestionario codificado y consentimiento correspondiente |

Se mencionó un flujo de **tres etapas, una por tecnología**, con **tres respuestas 1–3 al final de cada etapa**. La asociación exacta de cada valor, su codificación y el funcionamiento de la etapa SMA **deben verificarse directamente en el proyecto Unity**. No asumir que los tres actuadores ya operan de manera integrada dentro del visor.

## Esquema mínimo de corrida

```text
run_id | timestamp | etapa | actuador | evento | objeto | valor | unidad | fuente | version
```

Separar `eventos_unity.csv`, `comandos_esp32.csv`, `mediciones_instrumento.csv` y `respuestas.csv`; usar un `run_id` compartido y **no restar marcas de tiempo de relojes diferentes** sin sincronización y método justificado. Los datos identificables de participantes no deben subirse.

## Pendiente crítico

1. Importar `VRRoom_fuente_20261118_1121.zip` y `ESP_UDP_receptor(1).ino`.
2. Extraer del código la **tabla real de mensajes UDP**, etapas, objetos y opciones.
3. Documentar un procedimiento reproducible de reconocimiento de manos con y sin guante.
4. Identificar criterios de éxito, duración, privacidad y protocolos de cuestionarios desde la versión aprobada.
