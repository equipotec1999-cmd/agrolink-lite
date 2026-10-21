#!/usr/bin/env python3
"""Agrega el paquete mx.agrolink.lite a android/app/google-services.json (copia el cliente de
mx.agrolink.agrolink) para que AgroLite compile junto a AgroLink.
Para notificaciones push reales, registra mx.agrolink.lite en Firebase y baja su json."""
import json, sys, copy
p = sys.argv[1] if len(sys.argv) > 1 else "android/app/google-services.json"
d = json.load(open(p))
cl = d["client"]
if any(c["client_info"]["android_client_info"]["package_name"] == "mx.agrolink.lite" for c in cl):
    print("ya estaba"); sys.exit()
base = next(c for c in cl if c["client_info"]["android_client_info"]["package_name"] == "mx.agrolink.agrolink")
n = copy.deepcopy(base)
n["client_info"]["android_client_info"]["package_name"] = "mx.agrolink.lite"
cl.append(n)
json.dump(d, open(p, "w"), indent=2)
print("listo")
