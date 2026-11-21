# Trazabilidad de cada ensayo

## Regla principal

Un resultado debe vincular **procedimiento → muestra/dispositivo → fecha → instrumentos → firmware/escena/PCB → datos brutos → análisis → conclusión**. No mezclar resultados provenientes de distintos montajes o revisiones.

## Ficha mínima

| Campo | Qué guardar |
|---|---|
| `run_id` | identificador único e inmutable de la corrida |
| `test_id` | código original del protocolo; si no existe, indicar PROVISIONAL |
| `actuador` | ERM, ELECTROMAGNETICO o SMA |
| `tipo` | SIMULACION, BANCO_ELECTRICO, BANCO_MECANICO o VR |
| `fecha_hora` | instante y zona horaria |
| `montaje` | fotografía/plano, revisión mecánica y cableado |
| `configuracion` | alimentación, señal, duración, precarga, geometría |
| `versiones` | commit firmware/Unity, esquemático y PCB |
| `instrumentos` | modelo, resolución y método de calibración |
| `archivos_brutos` | nombre, ubicación original y SHA-256 |
| `analisis` | script, versión, tratamiento e incertidumbre |
| `estado` | PLANIFICADA/INCOMPLETA/EJECUTADA_SIN_AUDITAR/NO_CONFORME/VALIDADA |
| `observaciones` | incidencias y condiciones de exclusión |

## Criterios antes de mostrar gráficas finales

- Los archivos originales deben estar preservados y enlazados, no solo la captura.
- Si una magnitud es calculada por un modelo, etiquetar **SIMULACION**.
- La latencia del paquete UDP no equivale a la latencia perceptual completa.
- Las medidas de fuerza ON/OFF deben usar misma geometría y método.
- Datos humanos se anonimizan, revisan y publican únicamente con autorización.
- El protocolo Excel maestro es la referencia normativa interna una vez auditado; no reemplazarlo silenciosamente por esta carpeta.
