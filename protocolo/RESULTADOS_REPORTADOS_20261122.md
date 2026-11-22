# Lectura de resultados de referencia — protocolo HAPTIX

> Extracción de los campos **Resultado obtenido** de las hojas del Excel adjunto. **No se realizaron ensayos nuevos** ni se verificó el contenido de archivos CSV externos. Los números solo describen lo consignado en la fuente; no sustituyen sus fotografías, gráficas y registros de instrumentos.

## Electrónica ERM

| Ensayo | Valores registrados | Consideración |
|---|---|---|
| E-ERM-01 | CH1: 40,50 Ω / 3,31 V; CH2: 41,70 Ω / 3,31 V; CH3: 83,20 Ω / 3,32 V | Alcance de tres canales. CH0 excluido. |
| E-ERM-02 | TCA9548A 0x70; CH1 ID7; CH2 y CH3 ID5 | **No conforme**: ID5 no certifica identidad DRV2605L. |
| E-ERM-04 | RTP64, 200 ms: CH1 3,27 V / 0,050 A; CH2 3,29 V / 0,050 A; CH3 3,27 V / 0,050 A | Medición individual registrada; no se reportaron mediciones RTP80 en este ensayo. |
| E-ERM-06 | Tres motores simultáneos, 10 ciclos, 200 ms ON / 800 ms OFF, RTP80; tensión 3,30 → 3,00 V | El valor total de corriente “0,2 mA” tiene **unidad no validada** e inconsistente con valores individuales. |
| E-ERM-07 | Potencia nominal por motor ≈0,1635–0,1645 W; energía aproximada 32,7–32,9 mJ por pulso | **Calculadas**, no medidas como energía integrada. |
| E-ERM-08 | Ciclos supervisados durante 20 min, CH1–CH3 | Sin valores numéricos finales de VDD o temperatura en la revisión. |

## Electrónica P25/11

| Ensayo | Valores registrados | Observación |
|---|---|---|
| E-P25-01 | Rbobina 50,5 Ω; fuente 11,88 V | Verificaciones de polaridad/continuidad declaradas en registro MATLAB. |
| E-P25-02 | Comandos PONG, STATUS, ACK ARM y transiciones ON/OFF; pulso de 1 s | Registro serial original pendiente. |
| E-P25-03 | Rbobina 50,5 Ω; Vfuente 11,88 V; Vbobina 11,83 V; Ibobina 0,220 A; VGS 3,25 V; VDS(ON) 0,006 V; Pbobina calculada 2,6026 W | Relacionar valores con archivos instrumentales. |
| E-P25-04 | VDS pico 12 V; “t10 = 676 ms” | **No validado**: la cifra del oscilograma no acredita caída de corriente al 10 %. |

## Mecánica y temperatura

| Ensayo | Valores registrados | Limitación |
|---|---|---|
| M-01 y M-03 | Fuerza de retención observada ≈5 N; deslizamiento residual ≈1 mm/s bajo tracción | El freno no se considera bloqueo ideal. |
| M-04 | Electroimán: 10 pulsos 1 s ON / 9 s OFF; temperatura máxima registrada 25 °C; ambiente 19 °C | Aplicable solo a ese protocolo pulsado. |
| M-05 | SMA: 1 A → 17 N a 66 °C; 2 A → 17 N a 144 °C; a 3 A T > 270 °C sin fuerza medible | Combinación de fuerza y temperatura; no inferir aptitud de uso cutáneo. |
| M-06 | Contracción SMA ≈2,35 mm a 1 A | Sin longitud activa, fuerza simultánea o tiempo completos. |
| M-07 | SMA 66/144/>270 °C (1/2/3 A) | **Decisión documentada: no integrar SMA al guante ni evaluar con participantes.** |

## Integración Unity — ESP32 — guante

| Ensayo | Valores registrados | Alcance |
|---|---|---|
| INT-01 | ERM PWM GPIO16/17; frenos ON/OFF GPIO25/26; tres corridas C001/C003/C005 con 15.352 muestras y seis segmentos | Comandos reportados, no señales físicas medidas de todos los actuadores. |
| INT-03 | 72 eventos `LIMITE_P25` (C001=25, C003=10, C005=37) | Evidencia de órdenes de protección, no liberación mecánica medida. |
| INT-04 | **No superada**: identificación de placas de textura con baja correspondencia perceptual | Sin clave de superficies reales en CSV; no calcular porcentaje de acierto. |
| INT-05 | 1.013 eventos ON/OFF (ERM 475; freno 538); mediana ON/OFF ERM 1,303/1,288 ms; freno 1,290/1,296 ms | Retardo **interno de control**, no latencia total contacto–estímulo físico. |
| INT-09 | C001: 5.678 muestras (2.930 ERM, 2.748 FRENO); 289 eventos de latencia; 25 LIMITES | Sin medida de respuesta física. |
| INT-10 | C003: 3.078 muestras; 142 transiciones; 10 LIMITES | Respuesta ERM de texturas (2,1,3) registrada posteriormente. |
| INT-11 | C005: 6.596 muestras; 582 transiciones; 37 LIMITES | Orden de actuadores inverso FRENO→ERM. |

## Seguimiento de mano, red y aplicación

| Ensayo | Valor consignado | Interpretación |
|---|---|---|
| P-01 | Unity 6000.3.22f1; XR Interaction Toolkit 3.3.2; XR Hands 1.8.1; OpenXR | Meta XR Interaction SDK inicial descartado en esta rama. |
| P-10 | UdpHapticSender: paquete por sensor de 7 bytes, envío sostenido ~60 Hz en esa prueba | Diferenciar configuración de escenario y carga. |
| P-16 | Autoprueba ESP32 15/15, USB 4.795/4.795 paquetes; sesión con visor 25.591 paquetes en 111,6 s | Registros corresponden a condiciones específicas descritas en la hoja VIRTUAL. |
| P-18 | RTT real Quest: p50 14,8 ms, p95 49,8 ms, p99 70,2 ms, máximo 220,5 ms | Valores de **viaje redondo**. Estimaciones de ida no son marcas físicas absolutas. |
| P-21 | Jitter con mano apoyada 0,76 mm RMS; en aire 1,11 mm RMS; 72 Hz | Ensayos de tracking sin inferir reconocimiento cuando se cubren dedos con guante físico. |
| P-29 | Build Release y cabecera de condiciones en CSV | Verificar el APK exacto y su revisión al importar Unity. |

## Fuente y próximos pasos

- [Catálogo completo](CATALOGO_EXCEL_20261122.md) y [CSV textual original](catalogo_excel_fuente_20261122.csv).
- El **XLSX con 59 imágenes** aún debe añadirse a GitHub desde GitHub Desktop; instrucciones en [ORIGINAL_XLSX_PENDIENTE.md](ORIGINAL_XLSX_PENDIENTE.md).
- Recuperar `EVIDENCIAS/MEDICIONES/Mediciones_consolidadas.csv` y los directorios de corridas `C001/C003/C005` citados por las celdas; los CSV no están embebidos como archivos del XLSX.
