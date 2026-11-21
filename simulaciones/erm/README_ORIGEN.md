# ERM — Figuras de tesis desde resultados LTspice (versión 2.0)

## Objetivo
Usar **MATLAB únicamente para procesar y graficar** los datos de las dos simulaciones LTspice existentes. No incluye modelo dinámico ni simulación del motor en MATLAB.

## Qué hay en el ZIP
- `Generar_Figuras_ERM_LTspice.m`: script principal MATLAB R2025a (no requiere Simulink ni toolboxes).
- `Datos_LTspice/01_ERM_Pulsos.raw`: simulación ya ejecutada en LTspice 26.1.1 (600 ms; tres pulsos).
- `Datos_LTspice/02_ERM_PWM.raw`: simulación ya ejecutada en LTspice 26.1.1 (20 ms; 25%, 50%, 75% a 10 kHz).
- `Circuitos_originales/*.asc, *.plt`: copias sin cambios de los circuitos y vistas originales; no se altera el modelo simulado.
- `Resultados_generados/`: carpeta a la que MATLAB enviará figuras y tablas.
- `Notas/`: aclaración de la corrección de interpretación del diodo y controles de calidad.

## Instrucciones en MATLAB (Windows)
1. Descomprimir el ZIP completo, sin alterar los nombres de subcarpetas.
2. Abrir MATLAB, en Current Folder seleccionar la carpeta `ERM_Graficas_MATLAB_v2`.
3. Ejecutar `Generar_Figuras_ERM_LTspice` en la línea de comandos o abrir `Generar_Figuras_ERM_LTspice.m` y pulsar Run.
4. Abrir `Resultados_generados/` para ver:
   - `F01_ERM_Conmutacion_Pulsos.png` / `.pdf`
   - `F02_ERM_Apagado_Diodo.png` / `.pdf`
   - `F03_ERM_PWM_FormasDeOnda.png` / `.pdf`
   - `F04_ERM_Potencia_vs_Duty.png` / `.pdf`
   - `Tabla_Resultados_Pulsos.csv`
   - `Tabla_Resultados_PWM.csv`
   - `LEER_ANTES_DE_USAR_LAS_FIGURAS.txt`
5. Si MATLAB muestra un error, enviar el mensaje completo de la línea de comandos y el nombre de archivo y línea indicados.

## Corrección del diodo (SIN cambiar las simulaciones)
En el registro `.log` de SIM-02 el valor `I_DIODO_MAX` llega a cerca de 109 mA durante un flanco de ENCENDIDO cuando casi no circula corriente por el motor. Por tanto, NO se debe reportar como pico de recirculación de la carga inductiva. El script busca la recirculación del diodo solo si simultáneamente:
- Gate < 0,2 V (MOSFET en estado de apagado);
- V(drain) > V(fuente) + 0,10 V (polaridad de la corriente de rueda libre);
- I(D1) > 0 e I(RMOTOR) > 0.

Así se obtiene aproximadamente 32,3 mA en el apagado y se separa del máximo de corriente sin filtrar. **Se trata de un criterio para clasificar las corrientes en el modelo**, no de validar el comportamiento real del diodo 1N5819HW. No se modificó ningún `.asc`; por tanto no se alteran los resultados originales ni es necesario repetir LTspice para corregir esta interpretación.

## Datos y limitaciones
- R_motor = 92,5 ohmios: medición del usuario a motor detenido.
- L_motor = 349 microhenrios: referencia de Precision Microdrives 310-103, no corresponde a una medición propia.
- VMOTOR = 3 V: tensión de fuente ideal de la simulación.
- PWM = 10 kHz: condición de simulación, no frecuencia medida de firmware.
- MOSFET `M_NMOS_APROX` y diodo `D_SCHOTTKY_APROX`: modelos preliminares **NO OFICIALES**. No usar sus picos como especificaciones del AO3400A o 1N5819HW.
- El modelo R-L no tiene fuerza contraelectromotriz, conmutación de escobillas, velocidad, inercia, carga mecánica, ni vibración; NO predice la corriente de un ERM girando ni la potencia de una batería con reguladores.
- Las pérdidas de MOSFET reales se justifican por hoja de datos y medición posterior, no por este modelo genérico.
- Los `.raw` de LTspice usan UTF-16LE + datos binarios sin compresión; el lector incluido es para **este formato de RAW**. Si otro LTspice exporta RAW ASCII o comprimido, el script lo rechazará con un mensaje.

## Calidad de resultados
El script vuelve a integrar señales a partir de la resolución temporal de `.raw` utilizando `trapz`. Los valores podrán diferir ligeramente (menos del orden de una décima porcentual) de las directivas `.meas` de LTspice debido a la cuadratura/interpolación interna; no significa que el circuito se haya simulado de nuevo.

## Referencias originales
AO3400A: https://www.aosmd.com/sites/default/files/res/datasheets/AO3400A.pdf
Motor de referencia 310-103: https://precisionmicrodrives.com/cdn/catalog_product/89437681-576e-46e1-97cf-5ae185adeb1c/310-103-datasheet.pdf
1N5819HW: https://www.diodes.com/part/view/1N5819HW

## Documentación de la tesis
Todavía no copiar estos resultados al documento como "validación experimental". Esperar la revisión de figuras y datos exportados desde la instalación MATLAB del usuario. Debería incluirse el esquemático original LTspice, una figura de los pulsos, un detalle del apagado y la gráfica de potencia contra duty (no necesariamente las cuatro figuras).
