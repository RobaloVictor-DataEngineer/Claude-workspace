# Semaine 5 · Projet — Ton premier pipeline ETL

> Nouvelle étape : ce n'est plus un exercice, c'est un **vrai projet** (ton premier pour le portfolio).
> Un **ETL** (Extract, Transform, Load = Extraire, Transformer, Charger) est le cœur du métier de data
> engineer : un programme qui **va chercher** des données brutes, les **nettoie/transforme**, et les
> **charge** dans une base propre, prête à être utilisée. Tu as déjà toutes les briques (pandas, SQL,
> fonctions, gestion d'erreurs) — ici on les assemble en un **programme structuré**.

---

## 1. Le concept ETL en une image

```
   EXTRACT                 TRANSFORM                       LOAD
   (aller chercher)        (nettoyer + croiser)            (ranger au propre)

   ventes_brutes.csv  ─┐
                       ├─►  pandas : enlever doublons,   ─►  PostgreSQL
   catalogue.json  ────┘    corriger les types,              table "ventes_propres"
                            joindre, calculer le CA          (prête pour l'analyse / la BI)
```

- **Extract** : lire les sources (CSV, JSON/API, autre base…) → des DataFrames bruts.
- **Transform** : le vrai travail — nettoyer (doublons, types, valeurs manquantes), **joindre** les
  sources, calculer les colonnes utiles. C'est là que pandas sert.
- **Load** : écrire le résultat propre dans la base cible (ici PostgreSQL).

---

## 2. Structurer le code en **fonctions** (le réflexe pro)

Un pipeline ne s'écrit pas d'un bloc : on découpe en **fonctions**, une par responsabilité. C'est plus
lisible, testable, et réutilisable — exactement ce qu'on regarde sur ton code en entretien.

```python
def extract():
    """Lit les sources brutes et renvoie les DataFrames."""
    ventes = pd.read_csv("data/raw/ventes_brutes.csv")
    catalogue = pd.json_normalize(json.load(open("data/raw/catalogue.json", encoding="utf-8")))
    return ventes, catalogue

def transform(ventes, catalogue):
    """Nettoie et croise les données, renvoie un DataFrame propre."""
    # ... dédoublonnage, types, jointure, colonne montant ...
    return df_propre

def load(df_propre):
    """Écrit le DataFrame propre dans PostgreSQL."""
    # ... to_sql ...

def main():
    ventes, catalogue = extract()
    df = transform(ventes, catalogue)
    load(df)

if __name__ == "__main__":     # ne s'exécute que si on lance CE fichier directement
    main()
```

`main()` **orchestre** : elle appelle E → T → L dans l'ordre. Chaque fonction fait **une seule** chose.

---

## 3. Où va quoi (dans `projet-01-etl/`)

```
projet-01-etl/
├── data/raw/         <- les fichiers bruts (JAMAIS modifiés à la main)
├── data/processed/   <- le résultat nettoyé si tu l'exportes en fichier
├── src/              <- ton code : extract.py, transform.py, load.py, main.py
├── sql/              <- requêtes SQL (ex. vérifier la table chargée)
├── notebooks/        <- brouillons d'exploration
└── requirements.txt  <- les dépendances (déjà rempli : pandas, sqlalchemy…)
```

Règle d'or du raw : les données de `data/raw/` sont **la source de vérité**, on ne les édite jamais à la
main — tout nettoyage se fait **dans le code**, pour être reproductible.

---

## 4. Le Load dans PostgreSQL avec **SQLAlchemy**

**SQLAlchemy** est la bibliothèque qui permet à Python de parler à une base SQL. On crée un **engine**
(la connexion), puis pandas écrit le DataFrame en une ligne avec `to_sql`.

```python
from sqlalchemy import create_engine

# "postgresql+psycopg2://UTILISATEUR:MOT_DE_PASSE@HÔTE:PORT/BASE"
engine = create_engine("postgresql+psycopg2://postgres:TON_MDP@localhost:5432/postgres")

df_propre.to_sql("ventes_propres", engine, if_exists="replace", index=False)
```

- `create_engine("postgresql+psycopg2://…")` = l'adresse de connexion (le même login que dans DBeaver).
- `df.to_sql("nom_table", engine, if_exists="replace", index=False)` : crée/remplace la table et y écrit
  les lignes. `if_exists="replace"` = on repart propre à chaque exécution ; `index=False` = on n'écrit pas
  l'index pandas comme colonne.

Ensuite tu peux vérifier dans DBeaver : `SELECT * FROM ventes_propres;`.

---

## 5. Rendre le pipeline robuste : logging + gestion d'erreurs

Un pipeline tourne **tout seul** : il faut qu'il **dise ce qu'il fait** et qu'il **gère les pépins**.

Le **logging** (journalisation) remplace les `print` par des messages datés et niveaux (INFO, ERROR) :

```python
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s")

logging.info("Extract : %d lignes lues", len(ventes))
```

Et le `try/except` (que tu connais depuis la S1) protège les étapes fragiles (fichier absent, base
injoignable) :

```python
try:
    ventes = pd.read_csv("data/raw/ventes_brutes.csv")
except FileNotFoundError:
    logging.error("Fichier introuvable : data/raw/ventes_brutes.csv")
    raise      # on relance l'erreur : un pipeline ne doit pas continuer sur des données absentes
```

---

## 6. À retenir

- **ETL** = Extract (lire les sources) → Transform (nettoyer + joindre avec pandas) → Load (écrire en base).
- On **découpe en fonctions** (`extract`, `transform`, `load`) orchestrées par `main()` ; une fonction = une responsabilité.
- `data/raw/` = source de vérité **jamais modifiée à la main** ; tout nettoyage se fait dans le code.
- **Load** : `create_engine("postgresql+psycopg2://…")` puis `df.to_sql("table", engine, if_exists="replace", index=False)`.
- **Robustesse** : `logging` pour tracer, `try/except` pour gérer les pannes (fichier/base absents).

---

## 7. Le projet — brief (à réaliser en 3 phases)

> **Ce que tu dois en retenir :** transformer un tas de données brutes et sales en une table propre et
> exploitable, via un programme **structuré et reproductible**. C'est LE livrable qui prouve que tu sais
> faire un pipeline — celui qu'on regardera sur ton GitHub. Tout se passe dans `projet-01-etl/`. Le code
> va dans `src/` (un squelette de fonctions avec des `TODO` t'y attend). **Écris la logique toi-même** ;
> je t'ai laissé les signatures et le rôle de chaque fonction.

**Sources fournies dans `data/raw/`** : `ventes_brutes.csv` (ventes **sales** : lignes en double, `ville`
en casse/espaces incohérents, quelques **quantités manquantes**, et des `produit_id` hors catalogue) et
`catalogue.json` (le catalogue produits, propre, avec `fournisseur` imbriqué).

**Phase 1 — Extract (`src/extract.py`)**
1. Lis `data/raw/ventes_brutes.csv` dans un DataFrame.
2. Lis `data/raw/catalogue.json` et aplatis-le en DataFrame (les infos fournisseur en colonnes).
3. Protège la lecture du CSV par un `try/except FileNotFoundError` qui journalise l'erreur.
4. La fonction `extract()` renvoie les deux DataFrames (ventes, catalogue).

**Phase 2 — Transform (`src/transform.py`)**
1. Supprime les lignes **strictement en double** dans les ventes.
2. La colonne `quantite` a des **valeurs manquantes** (lignes sans quantité) : retire ces lignes, puis convertis `quantite` en **entier**.
3. Nettoie la colonne `ville` : enlève les espaces autour et uniformise la casse (ex. tout en `Title` → « Paris »).
4. **Joins** les ventes au catalogue sur `produit_id`, en **gardant toutes les ventes** (même celles sans produit connu).
5. Crée la colonne `montant` = `quantite × prix`.
6. La fonction `transform(ventes, catalogue)` renvoie le DataFrame propre.

**Phase 3 — Load (`src/load.py`)**
1. Crée l'`engine` SQLAlchemy vers ta base PostgreSQL locale (mêmes identifiants que DBeaver).
2. Écris le DataFrame propre dans une table `ventes_propres` (`if_exists="replace"`, `index=False`).
3. La fonction `load(df)` effectue l'écriture.

**Orchestration (`src/main.py`)** : `main()` appelle `extract()` → `transform()` → `load()`, avec un
`logging.info` à chaque étape (nombre de lignes). `if __name__ == "__main__": main()`.

**Vérification (`sql/verif.sql`)** : une requête `SELECT` qui confirme que `ventes_propres` est bien
chargée (ex. compter les lignes, le CA total par ville).

**Livrable :** le pipeline complet dans `projet-01-etl/` + la table `ventes_propres` créée dans
PostgreSQL + le README rempli (section « Ce que j'ai appris »), poussé sur GitHub.

---

*On avancera phase par phase : commence par l'Extract, envoie-moi `extract.py`, je corrige, et on
enchaîne sur le Transform puis le Load. Prends ton temps, c'est un projet — pas un sprint.*
