#!/usr/bin/env python3
"""Audita estructura de CSV de pruebas sin presumir un esquema no verificado.

Uso:
  python scripts/analizar_corridas.py --carpeta datos/anonimizados/C001 --salida resumen.json

NO publica nombres, contenido de registros ni resultados de participantes:
únicamente encabezados, conteos y distribuciones categóricas acotadas.
"""
import argparse
import csv
import json
from collections import Counter
from pathlib import Path

ARCHIVOS_CONOCIDOS = (
    'telemetria_esp.csv', 'eventos.csv',
    'latencia_control_esp.csv', 'respuestas_texturas.csv',
)
CATEGORIAS = ('actuador', 'etapa')

def revisar_csv(ruta: Path) -> dict:
    with ruta.open('r', encoding='utf-8-sig', newline='') as archivo:
        muestra = archivo.read(8192)
        archivo.seek(0)
        if not muestra.strip():
            return {'archivo': ruta.name, 'filas': 0, 'columnas': [], 'error': 'Archivo vacío'}
        try:
            dialecto = csv.Sniffer().sniff(muestra, delimiters=',;\t')
        except csv.Error:
            dialecto = csv.excel
        reader = csv.DictReader(archivo, dialect=dialecto)
        columnas = [c.strip() for c in (reader.fieldnames or []) if c]
        conteos = {c: Counter() for c in CATEGORIAS if c in columnas}
        filas = 0
        columnas_invalidas = 0
        for fila in reader:
            filas += 1
            if None in fila:
                columnas_invalidas += 1
            for columna, counter in conteos.items():
                valor = (fila.get(columna) or '').strip()
                if valor:
                    counter[valor] += 1
        # No incluir categorías de cardinalidad alta para evitar filtrar IDs.
        categorias = {
            col: dict(c.most_common())
            for col, c in conteos.items() if len(c) <= 12
        }
        return {
            'archivo': ruta.name, 'filas': filas, 'columnas': columnas,
            'conteos': categorias,
            'filas_con_campos_extra': columnas_invalidas,
        }

def revisar_carpeta(carpeta: Path) -> dict:
    if not carpeta.is_dir():
        raise NotADirectoryError(f'No existe la carpeta: {carpeta}')
    encontrados = sorted(p for p in carpeta.glob('*.csv') if p.is_file())
    return {
        'tipo': 'auditoria_estructural_no_estadistica',
        'carpeta': carpeta.name,
        'archivos_esperados': list(ARCHIVOS_CONOCIDOS),
        'faltantes_conocidos': [n for n in ARCHIVOS_CONOCIDOS if not (carpeta / n).exists()],
        'archivos': [revisar_csv(p) for p in encontrados],
    }

def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument('--carpeta', type=Path, required=True)
    cli.add_argument('--salida', type=Path)
    args = cli.parse_args()
    resultado = revisar_carpeta(args.carpeta)
    contenido = json.dumps(resultado, ensure_ascii=False, indent=2) + '\n'
    if args.salida:
        args.salida.parent.mkdir(parents=True, exist_ok=True)
        args.salida.write_text(contenido, encoding='utf-8')
        print(f'Resumen estructural: {args.salida}')
    else:
        print(contenido, end='')

if __name__ == '__main__':
    main()
