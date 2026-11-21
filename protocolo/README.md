# Protocolo de pruebas y evaluación

Esta es una **estructura preliminar** para incorporar el archivo maestro de protocolo y sus pestañas eléctrica, mecánica y virtual. Los formularios CSV son **plantillas vacías**, no resultados reales.

## Capas de evaluación

1. **Caracterización técnica:** alimentación, corriente, respuesta temporal, fuerza o desplazamiento según tecnología, temperatura y repetibilidad.
2. **Prueba de integración VR:** identificación de eventos Unity, comunicación UDP, activación, registros, seguimiento de mano.
3. **Percepción y experiencia:** estímulos y respuestas 1–3 según reglas del aplicativo; instrumentos subjetivos (p. ej., NASA-TLX/IPQ) si constan en la versión aprobada del protocolo.

## Organización de una corrida

Cada corrida debe conservar `run_id` único, fecha, operador, revisión firmware/Unity/PCB, actuador, etapa, condición, instrumento, resultado y observaciones. En conversaciones se ha previsto separar corridas por actuador y guardar tres respuestas 1–3 al final de su etapa; **el número de etapas y la escala exacta deben contrastarse con la versión final de la aplicación antes de automatizarse**.

Archivos de telemetría citados en el desarrollo: `telemetria_esp.csv`, `eventos.csv`, `latencia_control_esp.csv` y `respuestas_texturas.csv`. Se deben conservar sin sobrescribir, en una carpeta por `run_id`, documentando qué proceso los genera. No asumir que sus sellos de tiempo poseen el mismo reloj.

### Criterios de calidad

- No inventar huecos con ceros ni interpolar datos sin justificar.
- Separar ensayos de banco y experiencias con personas.
- Registrar si hand tracking falla durante una prueba.
- Cada cifra de resultados debe enlazar a CSV y script de análisis.
- No integrar SMA al guante con usuarios sin validación térmica documentada.
- Consentimiento informado, criterios de inclusión y duración controlada (objetivo histórico de sesión: 20–30 min) deben verificarse contra protocolo aprobado.

## Plantillas

- [Catálogo de pruebas](plantillas/catalogo_pruebas.csv)
- [Registro de corridas](plantillas/registro_corridas.csv)
- [Respuestas de textura](plantillas/respuestas_texturas.csv)

**Siguiente paso:** incorporar el Excel maestro real y mantener una tabla de correspondencia `pestaña Excel -> carpeta de GitHub -> evidencia original`.
