# ERM — vibración cutánea

## Lo documentado

Se han trabajado patrones, intensidades, texturas, accionamiento con etapa MOSFET y una alternativa con controlador háptico. En Drive existen diseños/expedientes electrónicos y un análisis de simulación de cargas equivalentes.

**Cuidado de interpretación:** el informe eléctrico en `Documentacion_para_tesis` describe una **carga R-L hipotética a 3 V**, no un motor identificado. Los valores de corriente obtenidos allí **no son mediciones del ERM real** ni prueban amplitud, fuerza o frecuencia mecánica.

## Evidencias por importar

- Sketch realmente usado en ensayos finales, incluyendo configuración de pines.
- Esquema + PCB y registro de componentes y orientación del diodo.
- Equipos, tensión/corriente medida, señales, parámetros temporales y CSV.
- Fotografías originales del montaje y, cuando existan, oscilogramas.

## Criterios mínimos de aceptación

No publicar la etapa como validada hasta verificar en hardware: alimentación nominal, corriente de arranque y régimen, polaridad de protección, temperatura, patrón observado y correspondencia entre comando recibido y salida activada.
