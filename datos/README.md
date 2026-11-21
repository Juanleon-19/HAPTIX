# Datos experimentales

## Convención

```text
datos/
  anonimizados/
    C001/
      eventos.csv
      telemetria_esp.csv
      latencia_control_esp.csv
      respuestas_texturas.csv
```

La ruta es **ilustrativa**, no contiene datos reales. Toda carpeta de corrida debe incluir `metadata.json` con unidad, fuente de tiempo, revisión, fecha y diccionario de columnas. Priorizar datos anonimizados de tamaño razonable; almacenar ficheros grandes y datos restringidos fuera del repositorio.

## Política

- Los archivos `.gitignore` impiden incorporar por accidente carpetas `datos/brutos/` y secretos.
- Antes de añadir datos anonimizados, verificar que no se puede vincular el código a la identidad de un participante.
- Para resultados publicados, conservar valores originales y scripts de transformación.
- Revisión de licencias/derechos y autorización para los datos procedentes de la aplicación.
