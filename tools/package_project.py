"""Bundle the complete source without caches, VCS internals or recursive builds."""
from pathlib import Path
import zipfile
root=Path(__file__).resolve().parents[1]
out=root/'builds/ashen-vessel-source.zip'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as archive:
 for file in sorted(root.rglob('*')):
  if not file.is_file():continue
  rel=file.relative_to(root)
  if any(p in ['.git','.godot','__pycache__','builds'] for p in rel.parts):continue
  if file.suffix in ['.import','.pyc']:continue
  archive.write(file,Path('ashen-vessel')/rel)
print(out)

with zipfile.ZipFile(root/"builds/ashen-vessel-runtime.zip","w",zipfile.ZIP_DEFLATED) as archive:
 for name in ["ashen-vessel.pck","run_linux.sh","README.txt"]:
  archive.write(root/"builds"/name,Path("ashen-vessel")/name)
print(root/"builds/ashen-vessel-runtime.zip")
