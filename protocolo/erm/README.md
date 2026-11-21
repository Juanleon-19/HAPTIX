# Protocolo ERM — evidencia histórica y procedimientos

## Sistema

Motores ERM controlados por módulos hápticos sobre bus I²C, con selección de cuatro canales mediante multiplexor (dirección observada `0x70`). En el registro de diagnóstico consultado se reportaron respuestas en `0x5A` y se usaron consignas RTP. La identidad de los módulos **no fue uniforme** en los ensayos históricos.

## Catálogo del gestor MATLAB: identificadores reales

| ID | Ensayo | Salidas/evidencia esperada |
|---|---|---|
| E-ERM-01 | Inspección, resistencias y alimentación | R de cada motor desconectado, VIN-GND de cada módulo, foto/observación de cableado |
| E-ERM-02 | Comunicación I²C e identificación | Scan del multiplexor y canales, ID, estado y registro de inicialización |
| E-ERM-03 | Activación individual y repetibilidad | Reacción por canal y 10 ciclos, sin activación cruzada |
| E-ERM-04 | Consigna RTP y medición eléctrica | Nivel de consigna, tensión, corriente y configuración del instrumento |
| E-ERM-05 | Patrones temporales | Duración y separación de eventos, consistencia observada |
| E-ERM-06 | Activación simultánea de cuatro motores | Comandos y respuesta de canales, efecto sobre alimentación |
| E-ERM-07 | Consumo, potencia y energía | Tensión y corriente medidas; método de cálculo de energía |
| E-ERM-08 | Estabilidad operativa, 20 minutos | Incidencias, reinicios, fallas y condiciones térmicas |

Los IDs y los nombres proceden del **menú registrado** del gestor MATLAB ERM. La tabla no afirma que estas ocho pruebas estén aprobadas.

## Hallazgos de un registro anterior (NO es el consolidado final)

- Se registraron tensiones de módulos **3,31 V (CH1), 3,10 V (CH2) y 3,32 V (CH3)**; resistencias **40,50 Ω, 41,7 Ω y 83,2 Ω**, respectivamente. CH0 estaba sin medición en ese intento.
- El gestor marcó **E-ERM-01 = INCOMPLETO** por falta de mediciones de los cuatro canales.
- En un intento de E-ERM-02 se obtuvo multiplexor `0x70` y respuestas `0x5A`, pero los IDs observados fueron **[5,7,5,5]**. El propio registro etiqueta el ID5 como **no verificado**, diferente del ID7 asociado a DRV2605L.
- El gestor marcó esa corrida **E-ERM-02 = NO_CONFORME**. En otro intento se perdió un canal; el registro reportó 3/4 inicializados.
- El texto histórico también muestra reinicios/brownout ESP32 y una falla de actualización Excel por recursos de memoria. **El fallo de Excel no invalida automáticamente los archivos CSV/MD/MAT, pero hay que localizar esos originales antes de concluir.**

Fuente de estos puntos: registro textual del gestor MATLAB, recuperado de las conversaciones de trabajo de noviembre de 2026. **Faltan los archivos brutos de la corrida, las fechas exactas y el cotejo con el Excel maestro**. No utilizar las cifras de esta sección como resultado final de tesis.

## Procedimiento mínimo reproducible

1. Registrar revisión PCB, identificación de driver, alimentación, instrumentos, fecha y configuración del firmware.
2. Con el sistema apagado, verificar continuidad, polaridad y resistencias.
3. Con energía limitada, registrar `scan`, `init` y `status`; **no tratar ID5 como DRV2605L certificado**.
4. Ejecutar el ensayo elegido **solo cuando los canales y protección estén verificados**; registrar salida serial íntegra y señal eléctrica con instrumentos externos.
5. Exportar datos originales e identificar el archivo y la corrida. Consignas no equivalen a corriente ni amplitud vibratoria medidas.
6. Evaluar conforme/no conforme **por corrida y versión**. No fusionar distintos intentos en un único resultado.

Relacionado: [simulaciones ERM](../../simulaciones/erm/README.md) · [trazabilidad](../trazabilidad-de-evidencias.md).
