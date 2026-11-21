"""Datos ficticios SOLO para probar el script (no representan pruebas de tesis)."""
import importlib.util
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts' / 'analizar_corridas.py'
spec = importlib.util.spec_from_file_location('analizar_corridas', SCRIPT)
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)

class AnalisisCSVTest(unittest.TestCase):
    def test_cuentas_actuador_y_etapa(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / 'eventos.csv').write_text(
                'actuador;etapa;evento_id\nERM;1;A\nERM;1;B\nELECTROIMAN;2;C\n', encoding='utf-8')
            r = mod.revisar_carpeta(p)
            self.assertEqual(r['archivos'][0]['filas'], 3)
            self.assertEqual(r['archivos'][0]['conteos']['actuador']['ERM'], 2)
            self.assertIn('telemetria_esp.csv', r['faltantes_conocidos'])

    def test_utf8_bom_y_archivo_vacio(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / 'eventos.csv').write_text('\ufeffactuador,etapa\nERM,1\n', encoding='utf-8')
            (p / 'telemetria_esp.csv').write_text('', encoding='utf-8')
            r = mod.revisar_carpeta(p)
            estados = {a['archivo']: a for a in r['archivos']}
            self.assertEqual(estados['eventos.csv']['filas'], 1)
            self.assertEqual(estados['telemetria_esp.csv']['filas'], 0)

if __name__ == '__main__':
    unittest.main()
