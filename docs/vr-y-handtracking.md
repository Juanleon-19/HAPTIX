# Integración VR y seguimiento de mano

**Situación actual crítica:** con el guante colocado se ha informado que Meta Quest 3S no reconoce de manera fiable la mano mediante *hand tracking*, posiblemente por oclusión/volumen. Una comunicación UDP funcional no resuelve por sí sola el problema de detección visual.

## Lista de diagnóstico por documentar

1. Caso base: mano sin guante con aplicación de referencia.
2. Guante textil sin accesorios voluminosos.
3. Guante con estructuras y actuadores colocados progresivamente.
4. Fotografías de vista externa del área de dedos/contorno; condiciones de iluminación y distancia a las cámaras.
5. Comparación objetiva: presencia de articulaciones detectadas, duración de pérdidas, tiempo hasta recuperación, escena y versión del SDK.
6. Estrategia de mitigación seleccionada y ensayo de regresión.

Registrar **resultados reales**, no suponer que una opción permitirá el seguimiento. Si se usa un método alternativo de entrada, documentar la diferencia metodológica respecto a *hand tracking* original.
