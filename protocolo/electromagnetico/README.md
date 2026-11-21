# Protocolo del freno electromagnético P25/11

## Arquitectura documentada

El freno cinestésico usa un electroimán P25/11 y un **tendón con fleje y resorte de retorno**. Su funcionamiento mecánico se debe caracterizar independientemente de la respuesta eléctrica de la bobina. No asumir que la fuerza normal de atracción del electroimán es igual a la fuerza tangencial que percibe el dedo.

## Secuencia de ensayos propuesta (IDs locales provisionales)

| ID provisional | Ensayo | Variables/evidencias |
|---|---|---|
| P25-B01 | Identificación y circuito sin energía | Revisión PCB, bobina, diodo, MOSFET, polaridad y resistencia |
| P25-B02 | Activación y desactivación eléctrica | V_bobina, I_bobina, V_GS, V_DS y método de medición temporal |
| P25-B03 | Consumo y estabilidad eléctrica | Corriente, potencia, temperatura del componente y tiempo de operación |
| P25-M01 | Fuerza de resistencia con electroimán ON/OFF | Fuerza tangencial medida con dinamómetro; montaje y recorrido |
| P25-M02 | Retorno de tendón mediante resorte | Desplazamiento, fuerza de retorno y recuperación |
| P25-M03 | Repetibilidad mecánica | Diferencia de respuesta por ciclos y condición del fleje |
| P25-I01 | Ensayo integrado en guante | Evento/consigna, respuesta, oclusión de tracking y seguridad |

**Los identificadores P25-* son etiquetas de organización nuevas**, no se atribuyen al Excel maestro. Hay que sustituirlos o mapearlos cuando el original se encuentre.

## Evidencia ya existente

En [`simulaciones/p25/`](../../simulaciones/p25/README.md) se conservaron cuatro circuitos LTspice (pulsos, barrido de inductancia hipotética, PWM y alternativa exploratoria Zener), su script MATLAB, un CSV y figuras. Son **simulaciones eléctricas**, no mediciones de resistencia mecánica ni tiempos de liberación del tendón. El modelo histórico parte de bobina 80 Ω nominal y 20 mH supuesto: **no trasladar los valores no medidos a una ficha experimental**.

## Requisitos para comparar de forma válida

- Mismo punto de medición y trayectoria del tendón en OFF y ON.
- Instrumento de fuerza identificado, calibración/resolución y unidades.
- Separar fuerza de fricción residual del fleje/resorte y diferencia generada por el electroimán.
- Registrar recorrido, velocidad, tensión/corriente de bobina, número de ciclos y temperatura.
- Definir método de estimación de latencia y número de repeticiones antes de comparar.

**Estado:** procedimientos documentados; conciliación con registros reales eléctricos y mecánicos pendiente. No declarar fuerza efectiva validada ni freno apto para ensayos con participantes.
