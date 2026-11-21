#!/usr/bin/env python3
"""Verifica que el esqueleto editorial tiene sus piezas mínimas."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
NECESARIOS = (
    'README.md', 'docs/estado.md', 'docs/fuentes.md', 'docs/trazabilidad.csv',
    'vr/README.md', 'firmware/esp32/README.md', 'protocolo/README.md',
    'protocolo/plantillas/registro_corridas.csv', 'hardware/electronica/README.md',
    'hardware/mecanica/README.md', 'simulaciones/README.md', 'SECURITY.md',
)
faltan = [p for p in NECESARIOS if not (ROOT / p).is_file()]
if faltan:
    raise SystemExit('Faltan archivos: ' + ', '.join(faltan))
print(f'Estructura OK: {len(NECESARIOS)} archivos mínimos.')
