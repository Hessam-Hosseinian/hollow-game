from pathlib import Path
root=Path(__file__).resolve().parents[1]
for key,title,hp,dmg,speed,windup,recovery,reach,scale in [('crawler','Ash Crawler',45,12,66,.65,.8,52,1.0),('sentry','Bone Sentry',55,14,42,.85,1.15,250,1),('penitent','Hollow Penitent',110,24,36,.95,1.4,84,1.0),('collector','The Collector',750,28,56,.85,1.1,125,2.0)]:
 text='[gd_resource type="Resource" script_class="EnemyData" load_steps=2 format=3]\n[ext_resource type="Script" path="res://scripts/enemies/enemy_data.gd" id="1"]\n[resource]\nscript = ExtResource("1")\n'
 path='boss' if key=='collector' else 'enemies'
 for k,v in dict(title=title,archetype=key,health=float(hp),damage=float(dmg),speed=float(speed),telegraph=windup,recovery=recovery,reach=float(reach),size_scale=scale,body_height=float(32 if key=='crawler' else 112 if key=='collector' else 62),sprite_path=f'res://assets/{path}/{key}.png').items():
  text+=f'{k} = '+(f'"{v}"' if isinstance(v,str) else str(v))+'\n'
 (root/f'resources/enemies/{key}.tres').write_text(text)
