"""Export and validate a Godot-runtime PCK. Desktop templates are not required."""
from pathlib import Path
import subprocess, sys
ROOT=Path(__file__).resolve().parents[1]
(ROOT/'builds').mkdir(exist_ok=True)
LOGS=ROOT/'docs/qa_logs';LOGS.mkdir(parents=True,exist_ok=True)
steps=[('export_pack',['godot','--headless','--editor','--path',str(ROOT),'--export-pack','Linux','builds/ashen-vessel.pck']),('pack_smoke',['godot','--headless','--main-pack','builds/ashen-vessel.pck','--script',str(ROOT/'tests/pack_smoke.gd')])]
if '--deep' in sys.argv:
 steps.append(('pack_integration',['godot','--headless','--main-pack','builds/ashen-vessel.pck','--script',str(ROOT/'tests/test_suite.gd')]))
for name,cmd in steps:
 result=subprocess.run(cmd,cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180)
 (LOGS/f'{name}.log').write_text(result.stdout)
 if result.returncode or 'ERROR:' in result.stdout or 'leaked at exit' in result.stdout:
  print(result.stdout);sys.exit(1)
 print(name+': PASS',flush=True)
print('PCK ready: builds/ashen-vessel.pck (requires Godot 4.7.2)',flush=True)
