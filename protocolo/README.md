# Protocolo de pruebas de HAPTIX

Esta carpeta es la puerta de entrada al **trabajo experimental**. Se documenta lo conocido del desarrollo sin modificar el protocolo Excel maestro ni atribuir resultados que no se han comprobado. **Estado del índice: 21-11-2026.**

## Fuentes y estado

| Fuente | Situación en HAPTIX | Uso permitido |
|---|---|---|
| `Protocolo_Pruebas_Guante_Haptico_COMPLETO_FINAL_20261121(1).xlsx` | Archivo identificado en conversaciones, **original no importado** | Referencia principal pendiente de cotejo |
| Registros de gestor MATLAB ERM (cuatro canales) | Se revisó un registro textual histórico | Antecedentes de ensayos, **no resultado final consolidado** |
| P25/11: `simulaciones/p25/` | Cuatro .asc, script de análisis, CSV y figuras presentes | Resultados **de simulación**; no medición de fuerza |
| SMA: `simulaciones/sma/` | Modelos MATLAB y fundamento presentes | Escenario teórico; falta validar físicamente |
| Unity/ESP32 integrados | Documentación preliminar, fuentes definitivas no incorporadas | Diseño de las pruebas, no prueba VR aprobada |

## Bloques del protocolo

1. **[ERM](erm/README.md):** inspección, I²C, respuesta por canal, RTP, patrones, simultaneidad, consumo y estabilidad.
2. **[Freno electromagnético](electromagnetico/README.md):** circuito, respuesta de bobina, fuerza/resistencia mecánica, retorno y repetibilidad.
3. **[SMA](sma/README.md):** resistencia real, temperatura, fuerza, desplazamiento y recuperación en banco.
4. **[Realidad virtual](vr/README.md):** reconocimiento de manos, comunicación UDP, eventos, registro y evaluaciones por etapa.
5. **[Trazabilidad](trazabilidad-de-evidencias.md):** identificador de corrida, versiones, instrumentos, datos originales y estado.
6. **[Criterios de comparación](../docs/criterios-comparacion.md):** métricas e interpretación sin pesos inventados.

## Estados válidos

- `PLANIFICADA`: procedimiento redactado; no existe evidencia de ejecución.
- `EJECUTADA_SIN_AUDITAR`: hay un registro o resultado histórico, no conciliado con original maestro.
- `INCOMPLETA`: hubo intento con datos faltantes.
- `NO_CONFORME`: el criterio declarado no se cumplió en la corrida identificada.
- `VALIDADA`: ejecución y evidencia originales verificadas con criterios y revisión concreta.

**No convertir una prueba en VALIDADA por disponer de una gráfica de simulación o de una entrada en un log.**

## Ruta de una corrida

```text
datos/
  corridas/
    <run_id>/
      metadata.json
      bruto/             # salida del instrumento y telemetría inalteradas
      procesamiento/     # scripts, tablas derivadas, gráficas
      evidencia/         # foto/captura/observación sin datos personales
```

No subir archivos sensibles o resultados de participantes sin anonimización y autorización. Conservar originales grandes en Drive y registrar URL/ID, revisión y SHA-256; no subir fotografías de participantes por defecto.

## Plantillas

- [Catálogo base](plantillas/catalogo_pruebas.csv)
- [Registro de corridas](plantillas/registro_corridas.csv)
- [Respuestas de tareas VR](plantillas/respuestas_texturas.csv)
- [Ficha de ensayo](plantillas/ficha_ensayo.md)

**Siguiente trabajo obligatorio:** inspeccionar la última versión del Excel maestro, mapear cada hoja a este índice e importar las evidencias verificadas.
