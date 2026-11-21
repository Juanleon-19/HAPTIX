# Fundamento físico, trazabilidad y limitaciones — SMA v3

## Alcance
Analizar calentamiento Joule de un único hilo y enfriamiento hacia el aire. La pregunta central es: **¿qué corriente teórica requiere un hilo de Nitinol para aproximarse a 60 °C en un intervalo definido?** No implica que 60 °C sea la temperatura final de transformación en presencia de carga ni que se haya medido.

## Modelo matemático

Con capacidad térmica concentrada y convección predominante en el aire:

\[\rho_m c_p V\frac{dT}{dt}=I^2R-hA_s(T-T_a).\]

Geometría cilindro: \(V=\pi d^2L/4\), \(A_s=\pi dL\). Definiendo \(C_{th}=\rho_m c_pV\), \(G_{th}=hA_s\):

\[C_{th}\dot T=I^2R-G_{th}(T-T_a).\]

Para corriente constante, resistencia y coeficiente térmico constantes:

\[T(t)=T_a+\frac{I^2R}{G_{th}}(1-e^{-tG_{th}/C_{th}}).\]

Invirtiendo para alcanzar una referencia \(T^*\) en un tiempo \(t^*\):

\[I(t^*)=\sqrt{\frac{G_{th}(T^*-T_a)}{R\,[1-e^{-t^*G_{th}/C_{th}}]}}.\]

Esta relación representa **un escenario idealizado**, no la corriente admisible para un equipo real. Con \(I^2R\) conocido se obtiene energía suministrada \(\int I^2Rdt\). La conservación de energía requiere que esta sea aproximadamente igual a energía almacenada \(C_{th}(T-T_a)\) más calor evacuado \(\int hA_s(T-T_a)dt\).

## Respaldo bibliográfico DIRECTO del modelo

1. `Efficiency Analysis of SMA-Based Actuators: Possibilities of Configuration According to the Application`, *Actuators*, 2021. Ecuaciones 4-6: término Joule, pérdidas por convección y efecto térmico de transformación; advierte que el calor latente puede requerirse en el proceso. https://www.mdpi.com/2076-0825/10/3/63
2. `Influence of Electrical Parameters in a Composite Wing Actuated by Shape Memory Alloys Wires: A Numerical–Experimental Study`, *J. Compos. Sci.*, 2025. Formula fuente de calor Joule y balance térmico general con conducción y convección. https://www.mdpi.com/2504-477X/9/9/460
3. `FLEXINOL Technical Characteristics of Actuator Wires`, Dynalloy, `F1140 Rev M`. Apartado de propiedades: densidad 6,45 g/cm³ y calor específico 0,2 cal/(g °C). NO es ficha Nexmetal. https://www.dynalloy.com/pdfs/TCF1140.pdf
4. `Nitinol actuator wire datasheet, 0.3 mm, 90°C material`, Fort Wayne Metals, Rev. 10/2024. Resistencia de 13,39 Ω/m y densidad 6,45 g/cm³ para SU material, no para Nexmetal. https://fwmetals.com/media/pbmke3zt/0-3-mm-acuator-data-sheet.pdf
5. `Nitinol SMA Shape Memory Alloy Wire`, Nexmetal. Producto configurable por diámetro y temperatura nominal de transición, pero la página no respalda tomar 60 °C como \(A_f\) del hilo bajo esfuerzo. https://nexmetal.com/products/nitinol-memory-wire

## Parámetros, procedencia y confiabilidad

| Parámetro | Valor en escenario inicial | Fuente / estado | Aplicabilidad |
|---|---:|---|---|
| Longitud activa | 0,120 m | Medición comunicada por usuario | Dato propio |
| R de lectura con dos puntas | 2,70 Ω | Multímetro, incluye puntas/contactos | Dato propio, NO R interna validada |
| Diámetro | 0,30 mm | Referencia nominal de producto | Confirmar físicamente |
| Densidad | 6450 kg/m³ | NiTi Fort Wayne / Dynalloy | Bibliográfico para otro NiTi |
| c_p | 836,8 J/(kg K) | Dynalloy, convertido de 0,2 cal/(g K) | Bibliográfico para otro NiTi |
| h | 57,02 W/(m² K) | Estimación histórica previa | NO calibrado ni verificable para este montaje |
| T ambiente | 25 °C | Condición de escenario | Debe medirse |
| T objetivo | 60 °C | Temperatura nominal comercial | No equivale a A_f bajo carga |
| Pulso de corriente | duración 10 s | Escenario elegido para analizar sensibilidad | NO condición de banco |

## Comparación eléctrica de fabricantes
- Lectura dos puntas: 2,70 Ω / 0,12 m = 22,5 Ω/m **aparentes**.
- Fort Wayne Metals: 13,39 Ω/m × 0,12 m = 1,6068 Ω para hilo 0,3 mm con temperatura de aleación 90°C.
- Dynalloy: 12,2 Ω/m × 0,12 m = 1,464 Ω para ~0,31 mm, producto diferente.

No inferir que el 2,7 Ω es incorrecto ni que la diferencia se deba exclusivamente a las puntas: temperatura, diámetro, material y contacto también pueden contribuir.

## Seguridad e interpretación
La simulación representa **T del hilo** y **no T de piel**. No permite establecer riesgo de quemadura sin modelar y medir el contacto al aislante/textil, tiempo de exposición y condiciones de uso. El ensayo inicial debe ser remoto, en banco y con fuente limitada, instrumentación de temperatura y protecciones. Nunca suministrar 12 V directamente al hilo de 2,7 Ω ni extrapolar el valor de corriente simulado a ensayos humanos.

## Falta para la validación
R de hilo sin resistencia parásita; repetición con distintas longitudes; temperatura ambiente real; h y pérdidas de terminales identificados experimentalmente; si se desea simular fase: curva A_s/A_f/M_s/M_f, calor latente y efecto del esfuerzo de la muestra Nexmetal. Estas faltas no se cubren con números supuestos.
