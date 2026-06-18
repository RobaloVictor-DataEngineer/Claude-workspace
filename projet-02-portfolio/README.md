# Projet 02 — Portfolio orchestré (Semaine 8)

## Objectif
Projet portfolio plus complet et documenté : pipeline API -> pandas -> PostgreSQL, orchestré (Airflow) et soigné pour être montré en entretien.

## Stack
Python (pandas, SQLAlchemy), SQL (PostgreSQL). Ajoute ici les outils utilisés.

## Arborescence du projet
- `data/raw/`        : données brutes, JAMAIS modifiées à la main
- `data/processed/`  : données nettoyées / transformées (générées par le code)
- `src/`             : code Python (ex : extract.py, transform.py, load.py)
- `sql/`             : requêtes SQL
- `notebooks/`       : exploration / brouillons Jupyter

## Comment lancer
1. `python -m venv venv` puis active-le (`source venv/bin/activate`)
2. `pip install -r requirements.txt`
3. `python src/main.py`  (ou le script principal)

## Étapes (ETL = Extract, Transform, Load)
- **Extract**  : d'où viennent les données ? (CSV, API...)
- **Transform** : quels nettoyages / jointures / calculs ?
- **Load**     : où sont chargées les données finales ?

## Ce que j'ai appris
_(à remplir au fil de l'eau)_

## À retenir pour l'entretien
_(la phrase / le concept que je saurai expliquer si on me pose une question dessus)_
