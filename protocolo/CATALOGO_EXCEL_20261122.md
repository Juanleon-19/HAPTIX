# Catálogo de pruebas registrado en el Excel adjunto (22 de noviembre de 2026)

> **Procedencia:** `Protocolo_de_pruebas_guante_haptico(1).xlsx`, aportado por el autor el 22-11-2026. Este es un **volcado documental**, no una revisión independiente de las mediciones. Se mantiene el estado que figura en cada fila; no se homologa “Listo” con “validado por tercero”.

**Archivo fuente:** 4 hojas; 59 ensayos identificados; 59 imágenes incrustadas; 35 MiB aproximadamente.

**SHA-256 original:** `9b86dfde003353f0203bf1715246d7fd2820bf300e1422b50ccf03985ccaafd2`

**Archivo de consulta completo (solo texto):** [catalogo_excel_fuente_20261122.csv](catalogo_excel_fuente_20261122.csv). Contiene las 11 columnas de las cuatro hojas con sus textos. Los elementos incrustados (imágenes y estilos) **no se transfieren al CSV**.

**Original XLSX:** [instrucciones de incorporación](ORIGINAL_XLSX_PENDIENTE.md). No se considera almacenado en GitHub hasta que aparezca físicamente el `.xlsx` en el historial.

## Balance según estados escritos en las celdas

| Hoja | Ensayos | Estados tal como figuran |
|---|---:|---|
| VIRTUAL | 27 | 24 × Listo, 2 × Listo (con bug), 1 × Falló |
| ELECTRONICA | 12 | 11 × Listo, 1 × No conforme |
| MECANICA | 8 | 8 × Listo |
| INTEGRADO | 12 | 11 × Listo, 1 × No superada |
| **TOTAL** | **59** | **54 “Listo”, 2 “Listo (con bug)”, 1 “Falló”, 1 “No conforme”, 1 “No superada”** |

**No hay procedimientos de LRA en este catálogo.** El estudio trata ERM, freno electromagnético y SMA; la implementación VR comparativa del Excel refiere dos actuadores físicos (ERM y freno).

## Índice completo de los 59 ensayos

La descripción es un extracto de la columna **Qué se hizo** del Excel, con truncado editorial para lectura; la descripción original completa se conserva en el CSV.

### VIRTUAL — Entorno virtual y comunicación

| ID | Fecha escrita | Estado escrito | Actividad (resumen) |
|---|---|---|---|
| P-01 | 2026-08-30 | Listo | Montaje del proyecto en Unity 6000.3.22f1 con XRI 3.3.2, XR Hands 1.8.1 y OpenXR, sobre la escena Room 1. |
| P-02 | 2026-08-31 | Listo | Verificación del hand tracking en el simulador con el sample HandVisualizer. |
| P-03 | 2026-09-01 | Listo (con bug) | Script HandJointCollider: sigue una articulación (ThumbTip, IndexTip, etc.) con un SphereCollider trigger de 8 mm. |
| P-04 | 2026-09-02 | Listo | Corrección del desfase vertical: la conversión de pose local a mundo va contra el CameraFloorOffsetObject, no contra la raíz del XR Origin. |
| P-05 | 2026-09-03 | Listo | Script HapticContactSensor: detección por OnTriggerEnter/Stay/Exit, penetración con Physics.ComputePenetration y modelo F = k·x. |
| P-06 | 2026-09-04 | Falló | Prueba del agarre con el sistema de Select nativo de XRI (Near-Far Interactor + XR Grab Interactable). |
| P-07 | 2026-09-05 | Listo | Script PinchGrabController: mide directo la distancia pulgar-índice, agarra por debajo de 2.5 cm y suelta por encima de 4.5 cm. |
| P-08 | 2026-09-06 | Listo | Adecuación de los objetos de prueba: tag Grabbable, Rigidbody no cinemático y collider ajustado a cada geometría. |
| P-09 | 2026-09-06 | Listo | Segundo punto de contacto por dedo (ThumbDistal, IndexDistal) y dos HapticContactSensor sobre el mismo GameObject para conmutar LRA/SMA. |
| P-10 | 2026-09-07 | Listo | UdpHapticSender enviando el paquete de 7 bytes por sensor (ID, tipo, intensidad float, modo) al puerto 8888 a 60 Hz. |
| P-11 | 2026-09-08 | Listo (con bug) | Primera sesión con el Quest 3S físico, en modo Play desde el Editor por Meta Horizon Link. |
| P-12 | 2026-09-09, 2026-10-29 | Listo | Hand tracking por Link, habilitando Developer Runtime Features en el canal Beta y el cambio automático manos/mandos en el visor. |
| P-13 | 2026-09-09 | Listo | Caracterización del rendimiento por Air Link y ajustes: ASW desactivado, bitrate fijo en 150 Mbps, 72 Hz, Render Scale 0.8 y sombras a 8 m. |
| P-14 | 2026-09-10 | Listo | Revisión de la configuración de XR: un solo loader, features habilitados por plataforma y verificación de que no hay cámaras duplicadas. |
| P-15 | 2026-10-06, 2026-10-29 | Listo | Validar colliders de falange, pinza y sensores hápticos con manos reales en el visor. |
| P-16 | 05-06/10 | Listo | Recepción del paquete UDP en el ESP32, cerrando con Unity en el visor como emisor y el monitor serie capturado por USB. |
| P-18 | 2026-10-06, 2026-11-16 | Listo | Medición del tramo de red por eco de ping sobre el AP de la placa, con diseño A-B-B-A: cuatro corridas de 120 s alternando sin carga y con lo… |
| P-19 | 2026-10-06 | Listo | Build de Android y ejecución autónoma en el Quest 3S, sin PC. |
| P-21 | 29/10 | Listo | Caracterización del jitter del hand tracking con el componente CaracterizadorJitter: batería de ocho fases (reposo, pinza cerrada, contacto s… |
| P-22 | 29/10 | Listo | Implementación del filtrado de jitter con los parámetros que salgan de la P-21, y repetición de la misma batería con Configuracion = tras_fil… |
| P-23 | 21/10, 29/10 | Listo | Extensión de la instrumentación a los cinco dedos de la mano derecha: sensor de yema y de falange distal en medio, anular y meñique, y agarre… |
| P-24 | 21/10, 16/11 | Listo | Hacer palpable todo el entorno: Rigidbody cinemático y collider convexo en los objetos de la sala, sin tag Grabbable. |
| P-25 | 2026-10-21 | Listo | Cuantización de la salida por actuador: umbral con histéresis para los dos actuadores de solo encendido y apagado, valor continuo para el ter… |
| P-26 | 21/10, 30/10 | Listo | Etapa de texturas dentro del entorno: tres placas con periodo espacial de 2, 5 y 15 mm, posicion barajada entre pases, envolvente que avanza … |
| P-27 | 21/10, 30/10 | Listo | Estructura de sesión de tres pases: terna de objetos fija entre pases, botón 'Ronda nueva' para reiniciar sin cerrar la app, y número de pase… |
| P-28 | 15/11, 16/11 | Listo | Modo de realidad mixta conmutable: componente ModoEntorno que apaga los 13 objetos del decorado virtual, pone el fondo de camara transparente… |
| P-29 | 30/10, 15/11, 16/11 | Listo | Build en Release y trazabilidad de las condiciones de medicion dentro del propio CSV: etiqueta de configuracion, tipo de build y entorno en l… |

### ELECTRONICA — Electrónica y actuación

| ID | Fecha escrita | Estado escrito | Actividad (resumen) |
|---|---|---|---|
| E-ERM-01 | 18/11/2026; cierre posterior | Listo | Inspección eléctrica del banco de motores ERM: revisión de cableado, resistencia de cada motor desconectado y tensión de alimentación de los … |
| E-ERM-02 | 18/11/2026; comprobaciones posteri… | No conforme | Diagnóstico de la comunicación I²C mediante multiplexor TCA9548A e identificación de los módulos de accionamiento de los motores ERM. |
| E-ERM-03 | 18–19/11/2026 | Listo | Activación individual y repetibilidad de los motores ERM conectados a CH1, CH2 y CH3, con pulso preliminar y diez ciclos de estímulo por cana… |
| E-ERM-04 | 21/11/2026 | Listo | Medición de tensión y corriente individual en los tres motores ERM del banco DRV previo a la PCB MOSFET (pulsos RTP64 de 200 ms). |
| E-ERM-05 | 18–19/11/2026 | Listo | Validación de patrones temporales de vibración: tres secuencias por canal, cada una compuesta por tres pulsos de 100 ms ON y 100 ms OFF. |
| E-ERM-06 | 21/11/2026 | Listo | Activación simultánea de los tres ERM CH1–CH3 en 10 ciclos con 200 ms ON, 800 ms OFF y nivel RTP80 (banco previo). |
| E-ERM-07 | 21/11/2026 | Listo | Estimación de consumo, potencia y energía nominal por pulso de los tres ERM, con los datos instrumentales disponibles de E-ERM-04. |
| E-ERM-08 | 18–19/11/2026 | Listo | Ensayo de estabilidad operativa supervisado de 20 minutos con CH1–CH3 mediante ciclos periódicos de 200 ms ON y 800 ms OFF. |
| E-P25-01 | 19/11/2026 (realizada; confirmació… | Listo | Inspección del único electroimán P25/11: polaridad del diodo flyback, continuidad, ausencia de cortocircuitos, GND común, resistencia de bobi… |
| E-P25-02 | 19/11/2026 | Listo | Diagnóstico serial del ESP32 y activación ON/OFF del único electroimán P25/11 por GPIO25. Se amplió el pulso test de 250 ms a 1000 ms. |
| E-P25-03 | 19/11/2026 | Listo | Caracterización eléctrica del único P25/11: resistencia de bobina, tensión de fuente, tensión de bobina, corriente, VGS y VDS(ON); cálculo de… |
| E-P25-04 | 19/11/2026 (realizada; confirmació… | Listo | Medición del transitorio de conmutación y protección flyback del P25/11: VGS, VDS en reposo/ON y pico VDS durante apagado; corriente transito… |

### MECANICA — Ensayos mecánicos y térmicos

| ID | Fecha escrita | Estado escrito | Actividad (resumen) |
|---|---|---|---|
| M-01 | 21/11/2026 | Listo | Medición de fuerza de retención del freno electromagnético P25/11 mediante dinamómetro y fleje montado en soporte. |
| M-02 | 21/11/2026 | Listo | Verificación funcional de activación y liberación del estímulo vibratorio ERM con las consignas PWM enviadas por Unity a la ESP32. |
| M-03 | 21/11/2026 | Listo | Medición de deslizamiento residual del fleje bajo retención electromagnética con fuerza de tracción mantenida. |
| M-04 | 21/11/2026 | Listo | Ensayo térmico pulsado del electroimán P25/11 a 12 V: diez pulsos de 1 s ON separados por 9 s OFF (100 s). |
| M-05 | 21/11/2026 | Listo | Medición de fuerza de tracción desarrollada por alambre SMA de Nitinol con dinamómetro al aplicar 1 A, 2 A y prueba limitada a 3 A. |
| M-06 | 21/11/2026 | Listo | Medición del desplazamiento de contracción del alambre SMA bajo corriente de 1 A. |
| M-07 | 21/11/2026 | Listo | Evaluación térmica del SMA y decisión de exclusión de pruebas integradas con el guante por peligro de alta temperatura. |
| M-08 | 21/11/2026 | Listo | Evaluación de geometrías impresas para la adaptación del guante y la incorporación física de actuadores y soportes. Se revisaron iteraciones … |

### INTEGRADO — Sistema integrado

| ID | Fecha escrita | Estado escrito | Actividad (resumen) |
|---|---|---|---|
| INT-01 | 2026-11-20 | Listo | Activación de los dos tipos de actuador físico desde el entorno Unity mediante la ESP32: ERM por PWM (GPIO16/17) y frenos electromagnéticos p… |
| INT-02 | 2026-11-20 | Listo | Integración operativa visor–ESP32–guante con dos actuadores evaluados dentro de cada corrida: para cada actuador, tres objetos y cuatro manio… |
| INT-03 | 2026-11-20 | Listo | Verificación funcional de comandos e intensidades: ERM proporcional mediante PWM y freno electromagnético ON/OFF, con activación/liberación d… |
| INT-04 | 2026-11-20 | No superada | Al finalizar los tres objetos de cada actuador, se realizó la sección de tres placas de texturas. Se registran tres identificaciones (1 ásper… |
| INT-05 | 2026-11-20 | Listo | Evaluación de tiempos de respuesta de la integración: seguimiento de contactos, latencia de control recepción UDP→salida MOSFET y, cuando exi… |
| INT-06 | 2026-11-20 | Listo | Aplicación sistemática de la secuencia por objeto: Objeto 1 → cuatro maniobras; Objeto 2 → las mismas cuatro; Objeto 3 → las mismas cuatro; p… |
| INT-07 | 2026-11-20 | Listo | Registro comparativo bajo corrida global única: habilitar ERM, grabar muestras, cambiar desde HMI a FRENO y continuar el mismo CSV con identi… |
| INT-08 | 2026-11-20 | Listo | Depuración de la campaña: selección de las corridas globales 1, 3 y 5 para análisis y exclusión de 2 y 4 según criterio del operador. |
| INT-09 | 2026-11-20 | Listo | Registro y revisión de la corrida global C001 con los dos actuadores, la misma secuencia de tres objetos y cuatro maniobras por objeto, segui… |
| INT-10 | 2026-11-20 | Listo | Registro y revisión de la corrida global C003 con los dos actuadores, la misma secuencia de tres objetos y cuatro maniobras por objeto, segui… |
| INT-11 | 2026-11-20 | Listo | Registro y revisión de la corrida global C005 con los dos actuadores, la misma secuencia de tres objetos y cuatro maniobras por objeto, segui… |
| INT-12 | 2026-11-20 | Listo | Comprobación del funcionamiento de límites de seguridad del freno electromagnético y seguimiento de transiciones de salida. |

## Precauciones de interpretación

- Una imagen insertada en una celda es **evidencia documental** y no equivale por sí sola a medición calibrada.
- Algunos resultados mencionan rutas relativas como `EVIDENCIAS/MEDICIONES/Mediciones_consolidadas.csv` y `EVIDENCIAS/CORRIDAS_VALIDAS`. El archivo adjunto **no contiene automáticamente esos CSV externos**; todavía es necesario importarlos como archivos independientes.
- Los porcentajes, latencias, fuerzas y temperaturas se citan únicamente como **valores reportados por el Excel** y deben rastrearse hasta las corridas e instrumentos.
- Los resultados de corriente, presión, temperatura y seguridad no deben extrapolarse a uso humano. El propio Excel documenta la **exclusión del SMA** de las pruebas integradas por temperatura elevada.
- Evitar publicar el XLSX o imágenes sin revisar datos personales, credenciales, propiedad intelectual y permisos.
