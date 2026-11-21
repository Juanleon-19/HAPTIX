# Electrónica e integración

La electrónica incluye ESP32, las etapas de control de ERM y freno electromagnético, alimentación y sistemas de protección; la SMA requiere un banco específico con control de corriente y temperatura.

## Alertas documentales que requieren comprobación física

Una revisión histórica del diseño con MOSFET identificó un posible capacitor polarizado invertido, diferencias entre nombres de red GPIO y pines reales de ESP32, y referencias de MOSFET/diodos genéricas en CAD. **No sabemos todavía si esa revisión coincide con la placa finalmente utilizada.** No energizar una placa únicamente con base en esos documentos: verificar orientación, pinout y alimentación reales.

Se incorporarán esquemáticos y Gerbers **solo después de emparejar las revisiones verificadas** y comprobar permiso/autoría. [Fuentes](fuentes.md) · [Estado actual](estado.md).
