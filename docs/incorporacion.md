# Procedimiento para importar un archivo real

1. Identificar fuente original en Drive o en el histórico de archivos de la tesis.
2. Revisar licencia/autoría; no copiar artículos ni contenido de terceros al repositorio.
3. Clasificar: `código`, `CAD`, `PCB`, `imagen`, `dato de prueba`, `simulación` o `referencia externa`.
4. Comprobar que corresponde a la **versión aprobada** del prototipo y no a una prueba antigua.
5. Buscar credenciales, direcciones IP privadas, IDs de participantes, rostros, documentos firmados y metadatos sensibles.
6. Guardar original inalterado en Drive; incorporar a GitHub fuente editable apropiada o derivado verificable.
7. Calcular SHA-256 del archivo incorporado y registrarlo en `docs/trazabilidad.csv`.
8. Incluir instrucciones reproducibles y resultado esperado, sin inventar pruebas.
9. Abrir una incidencia para cualquier campo que quede sin validar.

**Para archivos grandes:** conservar en Drive o crear una release/usar Git LFS después de revisar costos y límites. No guardar automáticamente datasets brutos o vídeos completos en Git.
