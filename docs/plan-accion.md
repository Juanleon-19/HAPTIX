# Plan de acción para completar el repositorio

## Fase 0 — Base inicial (este paquete)

- [x] Estructura de carpetas y README técnico.
- [x] Documentación inicial de componentes y estado, con límites explícitos.
- [x] Inventario de fuentes verificadas de Drive.
- [x] Plantillas de corridas, fichas de prueba e incidencias.
- [x] Analizador básico de CSV con pruebas unitarias.
- [x] Comprobar disponibilidad de `Juanleon-19/HAPTIX` y crear historial Git local.
- [ ] Publicar `HAPTIX` **privado** en GitHub desde GitHub Desktop (remoto no creado).

- [x] Incorporar 20 archivos originales de Drive (CAD, MATLAB, LTspice, figuras) y registrar hashes SHA-256.
- [ ] Reproducir los modelos importados en sus aplicaciones nativas y revisar CAD físico.

## Fase 1 — Congelar fuentes funcionales (prioridad máxima)

- [ ] Importar proyecto Unity completo desde ZIP, **sin** `Library/`, caches ni credenciales.
- [ ] Identificar versión Unity, paquetes de Meta XR, escenas, APK y protocolo UDP.
- [ ] Importar `ESP_UDP_receptor.ino` y los sketches ERM/freno **aprobados para banco**, en rutas independientes.
- [ ] Fijar versión de firmware VR integrada, pines reales y tabla de mensajes.
- [ ] Incorporar imágenes originales y un vídeo corto sin participantes identificables, si hay autorización.
- [ ] Crear incidencia de *hand tracking* y documentar pruebas de visibilidad/oclusión.

## Fase 2 — Evidencia experimental

- [ ] Incorporar la última versión única del protocolo Excel (o convertir hoja fuente a formato abierto si es viable).
- [ ] Consolidar procedimientos ERM, freno P25/11 y SMA por separado.
- [ ] Definir diccionario de datos y correspondencia de archivos de cada corrida.
- [ ] Incorporar datos **anonimizados** y no editados; generar métricas con scripts versionados.
- [ ] Revisar consistencia de unidades, equipos, calibración, condiciones, incertidumbre y fechas.

## Fase 3 — Diseño, documentación y réplica

- [ ] Exportar esquemáticos, Gerbers y BOM **de la misma revisión** que se validó.
- [ ] Incorporar ensamblajes CAD validados y planos/exportaciones en formatos adecuados.
- [ ] Generar fotos y diagramas propios con pie de figura, fuente y revisión.
- [ ] Documentar cableado, polaridad, alimentación y protección térmica real.
- [ ] Ejecutar instrucciones paso a paso desde otra máquina (Unity, ESP32, MATLAB/LTspice).

## Fase 4 — Presentación académica

- [ ] Añadir figuras definitivas, criterios de comparación y tablas finales auditadas.
- [ ] Resolver licencias y contribuciones antes de considerar publicación pública.
- [ ] Habilitar GitHub Pages/MkDocs **solo cuando se apruebe qué mostrar públicamente**.
- [ ] Generar release `v0.1.0` con manifiesto y versión validada de los materiales.

**Regla para cerrar tareas:** adjuntar versión de archivo, evidencia de la prueba, resultado reproducible y responsable; no basta con que un archivo exista.
