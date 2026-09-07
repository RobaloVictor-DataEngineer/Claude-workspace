#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Génère un CV PDF au style de Victor à partir de :
  - cv_master.json  : contenu FIGÉ et véridique
  - un fichier d'offre (optionnel) : petits ajustements autorisés (titre, présentation, ordre des compétences)

Usage :
  python3 generate_cv.py                      # CV par défaut (data engineer, IdF)
  python3 generate_cv.py --offre offre.json   # CV ajusté pour une offre précise

Le fichier d'offre (JSON) peut contenir uniquement :
  {
    "entreprise": "NomBoite",              # sert au nom du fichier
    "intitule": "Data Engineer BigQuery",  # sert au nom du fichier
    "role": "Data Engineer",               # titre affiché sous le nom (facultatif)
    "presentation": "…",                   # paragraphe de présentation ré-écrit (facultatif)
    "ordre_competences": ["etl","prog","bi","ml"],  # réordonne les blocs compétences (facultatif)
    "footer": ""                           # petite ligne de bas de page (facultatif)
  }
On NE change jamais les expériences, les puces, les études : contenu véridique figé.
"""

import argparse, json, re, sys, datetime
from pathlib import Path

try:
    from jinja2 import Template
    from weasyprint import HTML
except ImportError as e:
    sys.exit("Dépendance manquante : " + str(e) + "\nInstalle : pip install jinja2 weasyprint --break-system-packages")

BASE = Path(__file__).resolve().parent
SORTIE = BASE.parent / "generes"   # les CV générés vont dans CV/generes/


def slug(txt):
    txt = (txt or "").strip().lower()
    txt = re.sub(r"[àâä]", "a", txt); txt = re.sub(r"[éèêë]", "e", txt)
    txt = re.sub(r"[îï]", "i", txt);  txt = re.sub(r"[ôö]", "o", txt); txt = re.sub(r"[ùûü]", "u", txt)
    txt = re.sub(r"[^a-z0-9]+", "-", txt).strip("-")
    return txt or "cv"


def charger_json(chemin):
    with open(chemin, encoding="utf-8") as f:
        return json.load(f)


def appliquer_offre(data, offre):
    """Applique UNIQUEMENT les ajustements autorisés."""
    if not offre:
        offre = {}
    # 1) titre affiché
    data["role"] = offre.get("role", data.get("role"))
    # 2) présentation ré-écrite
    if offre.get("presentation"):
        data["presentation"] = offre["presentation"]
    # 3) ordre des compétences (par id)
    ordre = offre.get("ordre_competences") or data.get("offre_defaut", {}).get("ordre_competences")
    if ordre:
        par_id = {c["id"]: c for c in data["competences"]}
        data["competences"] = [par_id[i] for i in ordre if i in par_id] + \
                               [c for c in data["competences"] if c["id"] not in ordre]
    # 4) footer
    data["footer"] = offre.get("footer", data.get("footer", ""))
    return data


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--offre", help="chemin d'un fichier d'offre JSON (facultatif)")
    ap.add_argument("--nom", help="nom de fichier de sortie (sans extension, facultatif)")
    args = ap.parse_args()

    data = charger_json(BASE / "cv_master.json")
    offre = charger_json(args.offre) if args.offre else {}
    data = appliquer_offre(data, offre)

    template = Template((BASE / "template.html").read_text(encoding="utf-8"))
    html = template.render(**data)

    SORTIE.mkdir(exist_ok=True)
    if args.nom:
        base_nom = slug(args.nom)
    elif offre.get("entreprise") or offre.get("intitule"):
        base_nom = "CV_Victor_ROBALO_" + slug(offre.get("entreprise", "")) + "_" + slug(offre.get("intitule", "data-engineer"))
    else:
        base_nom = "CV_Victor_ROBALO_data-engineer_IdF"
    date = datetime.date.today().isoformat()
    pdf_path = SORTIE / f"{base_nom}_{date}.pdf"

    HTML(string=html, base_url=str(BASE)).write_pdf(str(pdf_path))
    print("CV généré :", pdf_path)


if __name__ == "__main__":
    main()
