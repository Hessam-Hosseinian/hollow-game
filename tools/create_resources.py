from pathlib import Path
root = Path(__file__).resolve().parents[1]
forms = [
 ('Whole','The Guardian',140,24,0.85,0.34,'d4c5a0','PARRY',0,0.9),
 ('Flesh','The Devourer',112,35,1.0,0.5,'973e4a','DEVOUR',12,2.1),
 ('Bone','The Dancer',185,17,1.2,0.23,'e7ddbf','BONE DASH',12,1.3),
 ('Soul','The Hollow',150,16,1.1,0.32,'5d8fa9','PHASE',22,3.2)]
for i,(name,role,speed,dmg,defense,recovery,tint,special,cost,cd) in enumerate(forms):
 text = '[gd_resource type="Resource" script_class="FormData" load_steps=2 format=3]\n[ext_resource type="Script" path="res://scripts/core/form_data.gd" id="1"]\n[resource]\nscript = ExtResource("1")\n'
 for k,v in dict(title=name,role=role,speed=float(speed),damage=float(dmg),defense=defense,recovery=recovery,special_name=special,special_cost=float(cost),special_cooldown=cd,sprite_path=f'res://assets/characters/{name.lower()}.png').items():
  text += f'{k} = '+(f'"{v}"' if isinstance(v,str) else str(v))+'\n'
 rgb=[int(tint[j:j+2],16)/255 for j in (0,2,4)]
 text += f'tint = Color({rgb[0]}, {rgb[1]}, {rgb[2]}, 1)\n'
 (root/f'resources/forms/{name.lower()}.tres').write_text(text)
upgrades=[('Reliquary Heart','Gain 25 maximum health and recover 25 health.','max_health',25),('Serrated Oath','All attacks deal 18% more damage.','damage',0.18),('Ashen Breath','Regenerate 2.5 more Hollow Energy per second.','regen',2.5),('Thin Veil','Hollow Shifts cost 20% less energy.','shift',0.2),('Sacred Reversal','Successful parries restore 12 extra energy.','parry',12),('Dancer\'s Wake','Bone Dash marks last longer and dash deals 10 damage.','dash',10),('Red Communion','Devour heals 4 extra health on a successful hit.','heal',4),('Lingering Echo','Soul Phase lasts 0.4 seconds longer.','phase',0.4)]
for i,(title,desc,stat,amount) in enumerate(upgrades):
 (root/f'resources/upgrades/upgrade_{i}.tres').write_text(f'[gd_resource type="Resource" script_class="UpgradeData" load_steps=2 format=3]\n[ext_resource type="Script" path="res://scripts/core/upgrade_data.gd" id="1"]\n[resource]\nscript = ExtResource("1")\ntitle = "{title}"\ndescription = "{desc}"\nstat = "{stat}"\namount = {float(amount)}\n')
layouts=[('Nave of Ash',[(320,204,128,16),(768,204,160,16)]),('Ossuary Steps',[(256,236,128,16),(480,204,128,16),(736,236,128,16)]),('The Broken Choir',[(384,220,224,16),(800,220,128,16)]),('Sepulchral Gallery',[(256,220,160,16),(608,236,160,16),(960,220,96,16)]),('Reliquary Crossing',[(416,236,96,16),(672,204,160,16)]),('Hall of Empty Names',[(288,220,160,16),(576,204,128,16),(864,220,160,16)])]
for i,(name,platforms) in enumerate(layouts):
 rects=', '.join('Rect2(%s)' % ', '.join(map(str,p)) for p in platforms)
 (root/f'resources/rooms/room_{i}.tres').write_text(f'[gd_resource type="Resource" script_class="RoomData" load_steps=2 format=3]\n[ext_resource type="Script" path="res://scripts/world/room_data.gd" id="1"]\n[resource]\nscript = ExtResource("1")\ntitle = "{name}"\nwidth = 1280\nplatforms = Array[Rect2]([{rects}])\nenemy_spawns = Array[Vector2]([Vector2(460,300),Vector2(660,300),Vector2(840,300),Vector2(1020,300),Vector2(1160,300)])\n')
