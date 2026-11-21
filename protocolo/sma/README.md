# Protocolo SMA — Nitinol en banco de pruebas

## Alcance y estado

La evaluación SMA es una línea de desarrollo **de banco**, no una integración térmicamente validada en el guante. Se estudia alambre NiTi y geometrías recta, zigzag y X-crossing como posibilidades de fabricación. No afirmar que todas fueron ensayadas.

## Datos de partida documentados

- Longitud comunicada: **0,12 m** de hilo recto.
- Lectura de resistencia con multímetro de dos puntas: **2,70 Ω**; incluye contactos/puntas y **no es resistencia interna corregida**.
- Diámetro nominal: **0,30 mm**, por confirmar físicamente.
- Referencia comercial de transición: alrededor de **60 °C**, **no** equivalente a Af bajo carga medida.
- El coeficiente de intercambio `h=57,02 W/(m² K)` del modelo histórico **no está calibrado** para el banco.

Estas son condiciones de un escenario preliminar documentado en [fundamento y trazabilidad](../../simulaciones/sma/FUNDAMENTO_Y_TRAZABILIDAD.md), no resultados de caracterización completa.

## Ensayos propuestos (IDs de trabajo)

| ID provisional | Ensayo | Registro imprescindible |
|---|---|---|
| SMA-B01 | Resistencia por longitud | L, método dos/cuatro hilos, R_puntas, R_medida, ambiente |
| SMA-B02 | Temperatura vs tiempo | corriente/tensión reales, ubicación del sensor, T(t), enfriamiento |
| SMA-B03 | Fuerza bajo restricción | fijación, dinamómetro, F(t), corriente, temperatura |
| SMA-B04 | Contracción/desplazamiento | precarga, longitud inicial, carrera, recuperación |
| SMA-B05 | Repetibilidad y fatiga inicial | número de ciclos, variación de respuesta y daño observado |

Los códigos SMA-B* son **propuestos para ordenar GitHub**, pendientes de cotejo con el protocolo Excel original.

## Salvaguardas

Ensayos iniciales **fuera del cuerpo**, con fuente limitada en corriente, medición independiente de temperatura y desconexión accesible. No aplicar 12 V directamente a un hilo de resistencia aparente 2,70 Ω. No usar curvas de simulación para demostrar seguridad cutánea. En las pruebas conservar trazas crudas y registrar el aislamiento térmico del montaje.

## Archivos disponibles

- [Modelo electrotérmico y scripts MATLAB](../../simulaciones/sma/README.md)
- [Fundamento y supuestos](../../simulaciones/sma/FUNDAMENTO_Y_TRAZABILIDAD.md)
- [Trazabilidad](../trazabilidad-de-evidencias.md)

**Estado:** simulación documentada y metodología de ensayo redactada; faltan series experimentales auditadas de temperatura, fuerza y desplazamiento.
