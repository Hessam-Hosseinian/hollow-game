"""Original deterministic TEMPORARY sprites and synthesized audio, not final art."""
from PIL import Image, ImageDraw
from pathlib import Path
import math, random, wave, struct
ROOT=Path(__file__).resolve().parents[1]
PALETTE=['#101014','#24242c','#555260','#d4c5a0','#973e4a','#5d8fa9','#b18a55','#e7ddbf']
ANIMS=['idle','run','jump','fall','attack','special','hurt','transform','death']

def character(kind,frame,anim):
 im=Image.new('RGBA',(96,96)); d=ImageDraw.Draw(im)
 bone='#d4c5a0'; pale='#e7ddbf'; steel='#555260'; dark='#24242c'; blood='#973e4a'; blue='#5d8fa9'; gold='#b18a55'
 phase=frame/6*math.tau; bob=round(math.sin(phase)*1) if anim in ('idle','run') else 0
 dx=round(math.sin(phase)*5) if anim=='run' else 0
 if anim=='death':
  for k in range(18):
   x=28+(k*13)%44; y=84-(5-frame)*3-(k*7)%17
   d.rectangle((x,y,x+2,y+1),fill=bone if kind!='soul' else blue)
  if frame>2: return im
 y=22+bob
 if kind=='soul':
  d.polygon([(43,y),(54,y-2),(61,y+12),(58,y+26),(67,y+41),(60,y+54),(56,y+44),(50,84),(44,y+55),(34,y+63),(39,y+38),(32,y+19)],fill='#304854')
  d.line([(43,y),(54,y-2),(60,y+13),(55,y+29),(58,y+50)],fill=blue,width=2)
  d.polygon([(40,y+25),(55,y+26),(48,y+55)],fill=blue)
  d.line([(48,y+30),(46,y+42),(50,y+49)],fill='#9bb6bf',width=2)
 else:
  # Shared mask, mantle and reliquary core across all physical forms.
  d.polygon([(39,y+17),(31,y+29),(33,y+55),(28,86),(44,80),(52,y+49),(59,84),(65,86),(61,y+22),(55,y+15)],fill=dark)
  legspread=dx
  if kind=='bone':
   for x,end in [(43,39+legspread),(53,57-legspread)]:
    d.line([(x,y+39),(x+legspread,y+52),(end,84)],fill=bone,width=4)
    d.rectangle((end-3,83,end+5,86),fill=steel)
   d.line([(46,y+18),(46,y+40)],fill=bone,width=3)
   for rib in range(4): d.line((39,y+22+rib*4,54,y+24+rib*4),fill=bone,width=2)
   d.line([(36,y+22),(31,y+39),(38,y+46)],fill=bone,width=3)
   d.line([(56,y+22),(60,y+36),(64,y+42)],fill=bone,width=3)
   d.rectangle((41,y+39,54,y+43),fill=bone)
  else:
   d.polygon([(37,y+19),(55,y+17),(60,y+29),(53,y+44),(38,y+44),(33,y+31)],fill=steel if kind=='whole' else blood)
   d.polygon([(37,y+19),(46,y+18),(43,y+38),(36,y+35)],fill='#78727a' if kind=='whole' else '#b35559')
   d.rectangle((38,y+41,55,y+46),fill=gold)
   d.polygon([(40,y+45),(47,y+46),(45+dx,y+60),(40+dx,84),(33+dx,85),(38+dx,y+58)],fill=steel if kind=='whole' else blood)
   d.polygon([(50,y+45),(57,y+46),(59-dx,y+60),(61-dx,85),(53-dx,85),(51-dx,y+59)],fill=dark if kind=='whole' else '#612f3c')
   for x in (34+dx,53-dx): d.rectangle((x,83,x+10,86),fill=dark)
   d.polygon([(35,y+20),(29,y+22),(28,y+34),(36,y+35),(39,y+24)],fill=bone if kind=='whole' else blood)
   d.line([(31,y+31),(33,y+43),(40,y+47)],fill=steel if kind=='whole' else blood,width=6)
   d.line([(57,y+26),(63,y+37),(65,y+47)],fill=steel if kind=='whole' else blood,width=6)
   if kind=='flesh':
    for yy in range(y+23,y+38,4): d.line((40,yy,54,yy+2),fill='#602b38',width=1)
  d.rectangle((46,y+27,50,y+34),fill=gold)
 # Relic mask: no face borrowed from commercial characters.
 d.polygon([(39,y),(51,y-3),(57,y+4),(54,y+15),(45,y+19),(38,y+11)],fill=bone if kind!='soul' else blue)
 d.polygon([(39,y),(45,y-2),(44,y+15),(39,y+11)],fill=pale if kind!='soul' else '#9bb6bf')
 d.rectangle((48,y+6,54,y+8),fill='#101014');d.line((47,y+12,51,y+13),fill=steel)
 d.line([(39,y),(36,y-4),(39,y-9)],fill=gold,width=2)
 if kind!='soul':
  if anim in ('attack','special') and frame in (1,2,3):
   d.line([(56,y+28),(72,y+20),(87,y+16)],fill=bone,width=4)
   d.polygon([(70,y+17),(93,y-1),(90,y+7),(74,y+23)],fill=pale)
  else:
   d.line([(65,y+40),(71,y+11)],fill=bone,width=2)
   d.polygon([(69,y+14),(73,y-10),(76,y+11)],fill=steel)
 if anim=='transform':
  for k in range(12):
   xx=20+(k*19+frame*7)%58; yy=12+(k*13+frame*9)%68
   d.rectangle((xx,yy,xx+1,yy+3),fill=blue)
 if anim=='hurt':
  im=im.convert('RGBA'); pix=im.load()
  for yy in range(96):
   for xx in range(96):
    if pix[xx,yy][3]:pix[xx,yy]=(231,221,191,255)
 return im

for kind in ('whole','flesh','bone','soul'):
 sheet=Image.new('RGBA',(576,864))
 for a,anim in enumerate(ANIMS):
  for f in range(6):sheet.alpha_composite(character(kind,f,anim),(f*96,a*96))
 sheet.save(ROOT/f'assets/characters/{kind}.png')
for kind in ('crawler','sentry','penitent','collector'):
 sheet=Image.new('RGBA',(576,864))
 for a,anim in enumerate(ANIMS):
  for f in range(6):
   im=Image.new('RGBA',(96,96));d=ImageDraw.Draw(im);bob=round(math.sin(f/6*math.tau))
   if kind=='crawler':
    d.polygon([(23,77),(29,65),(43,59+bob),(58,64),(70,73),(66,83),(32,84)],fill='#612f3c')
    d.line([(28,74),(38,67),(54,66),(64,74)],fill='#973e4a',width=3)
    for x in (30,44,58,66):d.line([(x,77),(x-5+(f%2)*3,85)],fill='#d4c5a0',width=3)
    d.polygon([(61,65),(73,68),(76,77),(67,80),(60,74)],fill='#d4c5a0');d.rectangle((70,71,73,73),fill='#101014')
   else:
    im=character('bone' if kind=='sentry' else 'whole',f,anim);d=ImageDraw.Draw(im)
    if kind=='penitent':
     d.polygon([(23,38),(36,29),(40,49),(27,58)],fill='#555260');d.line((31,37,31,50),fill='#b18a55',width=2)
     d.rectangle((59,40,72,61),fill='#555260');d.line((62,42,68,57),fill='#973e4a',width=3)
    if kind=='collector':
     d.polygon([(19,28),(33,18),(41,35),(28,60),(16,56)],fill='#612f3c')
     d.polygon([(60,29),(76,19),(84,41),(73,57),(59,49)],fill='#555260')
     for x in (23,30,66,73):d.line([(x,28),(x-3,15),(x+2,10)],fill='#d4c5a0',width=3)
     d.ellipse((40,40,54,55),fill='#5d8fa9');d.rectangle((45,43,49,50),fill='#e7ddbf')
   if anim=='death' and f>2:im.putalpha(im.getchannel('A').point(lambda a: a*max(0,255-(f-2)*75)//255))
   sheet.alpha_composite(im,(f*96,a*96))
 path='boss' if kind=='collector' else 'enemies'
 sheet.save(ROOT/f'assets/{path}/{kind}.png')
# 32px terrain atlas. Stone bricks with stable one-pixel detail.
rng=random.Random(21);atlas=Image.new('RGBA',(96,32));d=ImageDraw.Draw(atlas)
for t in range(3):
 x=t*32;d.rectangle((x,0,x+31,31),fill='#24242c')
 for yy in (0,16):
  off=8 if yy else 0
  for xx in range(-off,32,16):
   d.rectangle((max(x,x+xx),yy,min(x+31,x+xx+14),yy+14),fill='#37353f',outline='#1a1a22')
   d.line((max(x,x+xx+1),yy+1,min(x+30,x+xx+13),yy+1),fill='#555260')
 for k in range(34):
  xx=x+rng.randrange(32);yy=rng.randrange(32);d.point((xx,yy),fill=rng.choice(['#24242c','#555260','#45424e']))
 if t==1:d.rectangle((x,0,x+31,3),fill='#78727a');d.line((x,0,x+31,0),fill='#a19b8a')
atlas.save(ROOT/'assets/environments/stone.png')
# Sound effects: deterministic synthesis, original placeholder audio.
for name,freq,length in [('attack',190,.14),('heavy',70,.28),('parry',880,.28),('dash',240,.19),('shift',420,.32),('phase',540,.38),('hurt',100,.2),('hit',140,.13),('death',60,.55),('jump',320,.13),('land',90,.12),('step',120,.065),('ui',660,.08),('boss',55,.5),('combo',1040,.24)]:
 rate=22050;buf=[];rng=random.Random(name)
 for n in range(int(rate*length)):
  t=n/rate;env=(1-t/length)**2; pitch=freq*(1-0.45*t/length)
  val=(math.sin(math.tau*pitch*t)*.65+(rng.random()*2-1)*.35)*env*.36
  buf.append(struct.pack('<h',int(val*32767)))
 with wave.open(str(ROOT/f'assets/audio/{name}.wav'),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(buf))
for name,boss in [('ambient',False),('boss_drone',True)]:
 rate=22050;length=12;buf=[]
 for n in range(rate*length):
  t=n/rate; env=math.sin(math.pi*t/length)**.5
  val=sum(math.sin(math.tau*f*t+math.sin(t*.5)*.18)*a for f,a in [(55,.13),(82.5,.055),(110,.035),(146.83 if boss else 130.81,.028)])
  if boss: val+=math.sin(math.tau*44*t)*math.exp(-((t%1.5)*13))*.12
  buf.append(struct.pack('<h',int(val*env*32767)))
 with wave.open(str(ROOT/f'assets/audio/{name}.wav'),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(buf))
print('Generated original placeholder sprite sheets, tile atlas and synthesized audio.')
