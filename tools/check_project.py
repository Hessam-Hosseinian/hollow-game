"""Run engine tests; fail even when Godot returns zero with an error log."""
from pathlib import Path
import subprocess, sys
ROOT=Path(__file__).resolve().parents[1]
LOGS=ROOT/'docs/qa_logs';LOGS.mkdir(parents=True,exist_ok=True)
steps=[('assets',['/usr/bin/python', 'tools/validate_assets.py']),('import',['godot','--headless','--editor','--path',str(ROOT),'--quit-after','120']),('integration',['godot','--headless','--path',str(ROOT),'--script','tests/test_suite.gd'])]
if '--live' in sys.argv:
 steps.append(('live_combat',['godot','--headless','--path',str(ROOT),'--script','tests/live_combat_smoke.gd']))
if '--render' in sys.argv:
 steps.append(('render',['godot','--path',str(ROOT),'--script','tests/render_smoke.gd']))
for name,cmd in steps:
 result=subprocess.run(cmd,cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180)
 (LOGS/f'{name}.log').write_text(result.stdout)
 bad=result.returncode!=0 or 'ERROR:' in result.stdout or 'SCRIPT ERROR:' in result.stdout or 'leaked at exit' in result.stdout
 print(f'{name}: '+('FAIL' if bad else 'PASS'),flush=True)
 if name in ['integration','assets']:
  print(result.stdout,flush=True)
 if bad:
  print(result.stdout,flush=True)
  sys.exit(1)
print('All requested checks passed. Logs: docs/qa_logs/',flush=True)
