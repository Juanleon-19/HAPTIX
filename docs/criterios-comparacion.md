# Criterios para comparar los tres actuadores

**Objetivo:** elaborar una comparación defendible, basada en magnitudes medidas y criterios relevantes para una interfaz portátil. **No se asignan puntuaciones ni pesos sin medir y justificar.**

| Criterio | Método sugerido | Advertencia metodológica |
|---|---|---|
| Tipo de estímulo | describir principio de actuación y variable física de salida | ERM y freno no generan la misma sensación |
| Respuesta temporal | inicio de comando → variable física, con sensores y reloj definidos | no comparar únicamente tiempos de transmisión UDP |
| Consumo y energía | tensión/corriente medidas, integral de potencia y condiciones | separar potencia de reposo, pico y régimen |
| Fuerza de oposición | dinamómetro con recorrido y montaje iguales ON/OFF | aplicable a freno; ERM requiere otra métrica de intensidad |
| Desplazamiento/contracción | sensor de recorrido con precarga documentada | aplicable SMA y tendón, no indistintamente al ERM |
| Temperatura y seguridad | sensor térmico en punto relevante y duración fijada | simulación SMA no certifica seguridad sobre piel |
| Masa, volumen e integración | balanza, dimensiones, fijación y alimentación | reportar banco separado frente a guante montado |
| Repetibilidad | mismos estímulos, muestras y métricas por ensayo | no elegir arbitrariamente n o umbrales tras ver resultados |
| Percepción de usuario | respuestas ordinales, NASA-TLX/IPQ si el protocolo las contempla | no comparar sin revisar escala/consentimientos |

## Matriz multicriterio

Primero construir una tabla **no ponderada** de resultados con intervalos de incertidumbre y criterio de aplicabilidad. Si el documento académico requiere una selección ponderada, definir pesos, sentido de optimización, normalización y análisis de sensibilidad **antes** de emitir un ganador. Una métrica no aplicable no se convierte en cero.

## Evidencia requerida

[Protocolo de ensayos](../protocolo/README.md) · [Trazabilidad](../protocolo/trazabilidad-de-evidencias.md) · [Modelos de cada actuador](actuadores/index.md).
