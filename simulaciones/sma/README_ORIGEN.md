# SMA — modelo electrotérmico por ecuaciones (v3)

**Estado:** código MATLAB preparado y contrastado de manera independiente con SciPy; **pendiente de ejecución nativa en MATLAB R2025a y validación experimental**.

**Propósito:** estimar corriente idealizada para una temperatura objetivo nominal de 60 °C, respuesta de calentamiento/enfriamiento y balance de potencia/energía de **un hilo de NiTi de 12 cm**. No modela fuerza, desplazamiento, cambio de fase, contacto con piel ni electrónica MOSFET.

## Ejecución
1. Descomprime y abre `MATLAB/` en MATLAB R2025a.
2. Ejecuta `s = simular_electrotermico_SMA_v3;`.
3. Consulta los archivos que se crearán en `MATLAB/Resultados/` (4 figuras PNG+PDF, dos CSV, resumen TXT).
4. Si MATLAB devuelve error, guarda el mensaje completo y compártelo. No declares las salidas verificadas hasta revisarlas.

## Parámetros importantes
- Medición del usuario: **2,7 Ω** entre los extremos de 12 cm, por multímetro de **dos puntas**. No se ha restado resistencia de puntas/contactos.
- Campo editable `p.R_puntas_Ohm = NaN` (DESCONOCIDO). **No se ha supuesto que los 2,7 Ω pertenezcan íntegramente al Nitinol**. El script usa la lectura sin corregir como escenario provisional, etiquetado inequívocamente.
- Longitud 0,12 m (dato del usuario). Diámetro 0,30 mm nominal a confirmar.
- Densidad 6450 kg/m³: fabricante Fort Wayne Metals para otro hilo NiTi.
- Calor específico 836,8 J/(kg K): equivalencia de 0,2 cal/(g °C) en ficha Dynalloy, otro hilo NiTi.
- Coeficiente `h=57,02 W/(m² K)`: **estimación anterior no calibrada con el montaje**. No es medición ni parámetro certificado de Nexmetal.
- Temperatura ambiente 25 °C: supuesto de prueba. Objetivo 60 °C: **referencia nominal del producto, no temperatura Af confirmada bajo carga**.
- Simulación ilustrativa con corriente constante: el script calcula I para 60 °C en 10 s bajo las hipótesis y corta la energía a continuación. **NO es recomendación de ensayo físico**.

## Hipótesis y límites del modelo
Capacidad térmica concentrada, material homogéneo, temperatura uniforme, resistencia constante, convección lineal, omisión de radiación, calor latente, conducción a las mordazas, cambios de resistencia con temperatura/carga, inercia de sensores, flujo hacia textil y piel. `h` puede variar con temperatura, velocidad del aire y montaje. Las curvas no predicen seguridad humana ni llegada real a austenita completa.

## ¿Qué pruebas faltan?
1. Cortocircuita las dos puntas del multímetro y anota resistencia indicada; repite varias veces.
2. Repite medición del hilo con presión de contacto reproducible y, si puedes, usa medición Kelvin de 4 terminales.
3. Confirma el diámetro real, la temperatura ambiente y cómo se fijará el hilo.
4. Realiza ensayos **en banco, nunca sobre piel**, con fuente limitada en corriente y medida de temperatura. Identifica pérdidas hacia soportes y resistencia R(T).
5. Solo entonces calibra el modelo y considera calor de transformación.

## Documentación
- `Documentacion/FUNDAMENTO_Y_TRAZABILIDAD.md`
- `Documentacion/INSTALAR_LTSPICE.md`
- `Vista_Previa/` contiene **gráficas generadas en una ejecución independiente Python/SciPy**, no resultados MATLAB ni mediciones.
