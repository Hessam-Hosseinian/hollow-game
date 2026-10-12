"""Validate project references, sprite geometry/alpha, audio and data configuration."""
from pathlib import Path
from PIL import Image
import re, sys, wave, json
ROOT=Path(__file__).resolve().parents[1]
errors=[]; checked=0

def require(ok,message):
 global checked
 checked+=1
 if not ok:errors.append(message)

for file in list(ROOT.rglob('*.gd'))+list(ROOT.rglob('*.tres'))+list(ROOT.rglob('*.tscn')):
 if '.godot' in file.parts:continue
 text=file.read_text()
 for ref in re.findall(r'res://([\w/.-]+\.(?:gd|tres|tscn|png|wav))',text):
  require((ROOT/ref).exists(),f'{file.relative_to(ROOT)} missing {ref}')
for folder in ['characters','enemies','boss']:
 for file in (ROOT/'assets'/folder).glob('*.png'):
  with Image.open(file) as im:
   require(im.mode=='RGBA',f'{file.name}: needs RGBA')
   require(im.size==(576,864),f'{file.name}: wrong 96x96 / 6x9 sheet')
   for y in range(9):
    for x in range(6):
     frame=im.crop((x*96,y*96,(x+1)*96,(y+1)*96))
     alpha=frame.getchannel('A')
     require(alpha.getextrema()[0]==0,f'{file.name} {x},{y}: no transparency')
     require(all(alpha.getpixel(p)==0 for p in [(0,0),(95,0),(0,95),(95,95)]),f'{file.name} {x},{y}: opaque frame corner')
     require(alpha.getbbox() is not None,f'{file.name} {x},{y}: empty frame')
for file in (ROOT/'assets/audio').glob('*.wav'):
 with wave.open(str(file)) as audio:
  require(audio.getnchannels()==1 and audio.getsampwidth()==2,f'{file.name}: expected mono PCM16')
  require(audio.getframerate()==22050 and audio.getnframes()>100,f'{file.name}: invalid audio')
for file in (ROOT/'resources/forms').glob('*.tres'):
 text=file.read_text()
 for field in ['speed','damage','defense','recovery','special_cooldown']:
  m=re.search(rf'^{field} = ([\d.]+)',text,re.M)
  require(bool(m) and float(m[1])>0,f'{file.name}: invalid {field}')
for file in (ROOT/'resources/enemies').glob('*.tres'):
 text=file.read_text()
 for field in ['health','damage','speed','telegraph','recovery','reach','body_height']:
  m=re.search(rf'^{field} = ([\d.]+)',text,re.M)
  require(bool(m) and float(m[1])>0,f'{file.name}: invalid {field}')
 require(float(re.search(r'^size_scale = ([\d.]+)',text,re.M)[1]).is_integer(),f'{file.name}: fractional pixel scale')
report={'checks':checked,'failures':errors}
print(json.dumps(report,indent=2))
sys.exit(bool(errors))
