# Publicación de HAPTIX en GitHub

**Estado al 21-11-2026:** esta carpeta contiene un repositorio Git **local** con un primer commit en la rama `main`. El repositorio remoto `Juanleon-19/HAPTIX` **todavía no existe**; el asistente verificó que el nombre no estaba ocupado en esa cuenta, pero la conexión actual no puede crear repositorios.

## Opción principal: GitHub Desktop (recomendada)

1. Descarga y **extrae** el archivo `HAPTIX-v0.0.3-git.zip` completo. La carpeta `HAPTIX` contiene la carpeta oculta `.git`. No borres esa carpeta.
2. Abre GitHub Desktop con la cuenta `Juanleon-19` iniciada.
3. Selecciona **File → Add local repository...**, elige la carpeta extraída `HAPTIX` y confirma.
4. Verifica que muestre rama **main** y el commit inicial.
5. Pulsa **Publish repository**. Usa el nombre **HAPTIX**, deja marcada la opción **Keep this code private**, y confirma **Publish Repository**.
6. Comprueba que el repositorio aparece en GitHub y que están `README.md`, `docs/`, `firmware/`, `vr/`, `hardware/`, `simulaciones/` y `protocolo/`.

La operación **Publish repository** crea el repositorio privado remoto **y envía el commit local**. No es necesario crear manualmente otro repositorio primero. **No hay ninguna publicación automática desde este ZIP**; requiere esta acción en GitHub Desktop.

## Opción alternativa: terminal Git

Crea primero en https://github.com/new un repositorio **privado** de nombre `HAPTIX`, sin marcar inicialización con README, licencia o `.gitignore`.

Desde la carpeta ya extraída `HAPTIX`, que trae `.git`:

```bash
git remote add origin https://github.com/Juanleon-19/HAPTIX.git
git push -u origin main
```

Si `origin` ya existe, inspecciona con `git remote -v` antes de modificarlo. No uses `git push --force` para esta migración.

## Antes de habilitar visibilidad pública

Revisar derechos de terceros, licencia, CAD, fotos, identificadores de participantes y registros con IP o contraseñas. El proyecto está diseñado para **visibilidad privada inicial**. El Excel maestro y el Unity VR completos no están en esta versión: constan como pendientes de importación, no deben simularse como presentes.
