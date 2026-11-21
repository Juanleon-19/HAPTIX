# P25/11 — Circuitos gráficos LTspice y resultados automáticos en MATLAB

**Objetivo:** exactamente el método de ERM: LTspice 26.1.1 calcula -> archivos `.raw` y `.log` -> MATLAB R2025a **lee los `.raw` originales** y crea las figuras finales, sin volver a simular la electrónica.

## 1. Cómo ejecutar en LTspice

1. Descomprime el ZIP sin cambiar su estructura.
2. Abre `Circuitos/01_P25_Pulsos.asc` en LTspice; pulsa `Run` (icono verde).
3. La ventana **negra** de curvas aparece vacía si no has elegido señales. **Eso no significa que falló.** En el esquema haz clic en el cable `GATE` (tensión Gate), `DRAIN` (tensión Drain) y en el símbolo `L_BOB` (corriente inductiva). Alternativamente, en la ventana negra clic derecho > `Add Trace` y selecciona `V(gate)`, `V(drain)` e `I(L_BOB)`.
4. Para ver las medidas `.meas`, activa `View > SPICE Error Log` o `Ctrl+L`. Con `.step` hay tablas por cada condición; en el log puedes hacer clic derecho > `Plot .step'ed .meas data`.
5. Comprueba que junto al `.asc` aparecen archivos `.raw` y `.log`. **No elimines los RAW**.
6. Repite Run para `02_P25_Barrido_inductancia.asc`, `03_P25_PWM_25_50_75.asc` y `04_P25_Zener_9V_OPCIONAL.asc`.

Si quieres trabajar por partes, empieza solo con **SIM01**. MATLAB procesará las simulaciones disponibles e indicará cuáles faltan.

## 2. Cómo obtener gráficas MATLAB

1. Abre MATLAB R2025a y cambia `Current Folder` a la raíz de esta carpeta (donde está `Procesar_P25_LTspice_RAW.m`).
2. Ejecuta:

   `Procesar_P25_LTspice_RAW`

3. La carpeta `Resultados_MATLAB/` contendrá PNG y PDF de las figuras y `Tabla_Resultados_P25.csv` (solo para las simulaciones realmente ejecutadas).
4. **No necesitas exportar manualmente TXT desde LTspice.** El script lee archivos RAW binarios de LTspice Windows, **sin compresión**, con datos `time` double y otras variables float. Si la versión de LTspice usa un formato nuevo no compatible, se reportará el error en vez de inventar resultados.

## 3. Las cuatro simulaciones y cuáles usar en la tesis

| Simulación | Pregunta | Rol recomendado |
|---|---|---|
| 01 Pulsos | Corriente en ON y tensión Drain en OFF | **Principal** |
| 02 Barrido de L hipotética | ¿Cuánto depende el apagado de la inductancia aún desconocida? | **Principal, sensibilidad** |
| 03 PWM 500 Hz (25/50/75 %) | ¿Qué cambia en corriente RMS y potencia? | **Opcional** si se planea fuerza modulable |
| 04 Diodo + Zener de 9 V | ¿Una protección de apagado más rápida mejoraría el comportamiento eléctrico? | **Exploratoria**, no PCB definitiva |

**Condiciones**: V=12 V, R_bobina=80 ohm nominal, Lb=20 mH supuesto base; en SIM02 se exploran 5/20/100 mH **no medidos**. MOSFET y diodos usan modelos SPICE aproximados, **no son modelos oficiales certificados**.

La única demostración válida en estas simulaciones es **eléctrica**. No calcula fuerza magnética, torque, fricción, temperatura, ni capacidad de detener un dedo.

## 4. Modelo de factibilidad magnética / fricción (no FEM)

En `Analisis_Fleje/Analisis_Factibilidad_Fleje.m` hay un análisis opcional de **sensibilidad algebraica**, basado en una tabla de catálogo para una variante LSD-P25/11: 1 mm 2.5 kgf, 2 mm 3.5 kgf, 3 mm 5 kgf. Fuente: https://botland.store/content/287-load-capacity-diagram-of-electromagnets

Fuerza **normal de atracción** no es la fuerza tangencial del tendón. El modelo calcula el límite ideal de fricción: `F_t = mu * F_normal`, con `mu` hipotético de 0.15/0.25/0.40. **No declara resultados del prototipo**. El resorte y la fricción de las guías modifican la resistencia total ON/OFF; el aporte adicional del electroimán se identifica comparando ambas condiciones. Deben medirse más adelante.

Para ejecutarlo desde la carpeta `Analisis_Fleje`: `Analisis_Factibilidad_Fleje`

## 5. Advertencias de trazabilidad

- No se ha ejecutado LTspice Windows ni MATLAB aquí. Archivos revisados estáticamente, no simulación comprobada.
- Los `.raw` solo se generan cuando TÚ pulsas `Run` en LTspice.
- Los `.png`/`.pdf` de MATLAB solo se crean al ejecutar el script sobre archivos RAW reales.
- No utilices el modelo eléctrico RL para inferir directamente el tiempo de liberación mecánica.
- En la simulación 04 el Zener está orientado en inversa durante la recirculación y el diodo Schottky en directa. Esta corrección se hizo en la V3 del esquema; revisar la polaridad visual antes de ejecutar. La simulación 04 es una comparación de topologías, **NO** una propuesta para instalar Zener sin validar el límite de 30 V del AO3400A y transitorios.
