# Simulaciones y modelos

## Fuentes disponibles

- ERM: [documentación y gráficas de simulación](https://drive.google.com/drive/folders/1OuKrUeDhULlNsY09p3WcN32lixiDRScQ). Hay un reporte de pruebas por **ngspice CLI con modelo R-L ilustrativo**. Sus parámetros no equivalen a identificación del motor.
- P25/11: [LTspice y MATLAB](https://drive.google.com/drive/folders/1oCk-_c_3hKGcJOGO2Zv1t_e0a7_ZvPn9). La guía encontrada reconoce que los archivos entregados requerían ejecutar localmente LTspice/MATLAB; los supuestos de inductancia no deben confundirse con medición de bobina.
- SMA: [MATLAB y LTspice](https://drive.google.com/drive/folders/148sPABUidSgpBeOhSVSGOZrW9WG-ykdW). Separar datos térmicos medidos de parámetros calibrados y escenarios hipotéticos.

## Estructura propuesta por experimento

`modelo/`, `parametros.csv`, `ejecutar.md`, `resultados/`, `figuras/`, `limitaciones.md`, `version-software.txt`. Para corridas extensas, enlazar resultados brutos externos sin incorporarlos al historial Git.

**Nunca presentar una simulación estática no ejecutada como resultado verificado.**
