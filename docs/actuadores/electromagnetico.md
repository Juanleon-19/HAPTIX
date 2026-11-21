# Freno electromagnético P25/11

## Principio

Un electroimán interviene sobre un **fleje o elemento de frenado** asociado a un tendón. El **resorte** permite el retorno del mecanismo. La fuerza tangencial efectiva **no es igual** a la fuerza normal de atracción nominal del electroimán y debe medirse experimentalmente.

## Hardware conocido y límites

- Referencia de desarrollo: P25/11 de 12 V; etapas electrónicas basadas en NMOS y diodo de rueda libre.
- Se han preparado ensayos eléctricos y mecánicos; el paquete final de pruebas se conserva como fuente pendiente de importar.
- Los modelos LTspice iniciales emplean valores de R, L y dispositivos **nominales o supuestos**. No acreditan fuerza, bloqueo de dedos, temperatura ni tiempo mecánico de liberación.
- Confirmar número de canales y PCB de la revisión actualmente montada antes de describir un diseño final.

## Pendientes

1. Medir diferencia de esfuerzo ON/OFF con dinamómetro y registrar el retorno por resorte.
2. Identificar condiciones de ensayo, tensión bajo carga, corriente, desplazamiento y repetibilidad.
3. Relacionar firmware, esquemático, PCB, BOM y fotografías de la misma revisión.
4. Documentar protección frente a bloqueo, sobrecorriente o activación prolongada.

Fuente: [Simulaciones P25](https://drive.google.com/drive/folders/1oCk-_c_3hKGcJOGO2Zv1t_e0a7_ZvPn9).
