# Fiche de révision — Semaine 5 (ETL, premier pipeline)

> Antisèche entretien. Semaine centrée sur le **projet `projet-01-etl/`** : assembler les briques déjà connues (pandas, SQL, try/except) en un vrai pipeline **ETL** (Extract, Transform, Load = Extraire, Transformer, Charger).

---

### ETL — le concept
**Idée :** un ETL va **chercher** des données brutes (Extract), les **nettoie/croise** (Transform), puis les **écrit** dans une base propre (Load).
**Syntaxe :** pas de code unique — c'est une architecture en 3 fonctions (`extract()`, `transform()`, `load()`) orchestrées par `main()`.
**Piège :** Transform ≠ juste "nettoyer". Ça inclut aussi le **join** des sources et le calcul des colonnes utiles (ex. `montant`).

### Découper en fonctions (une responsabilité chacune)
**Idée :** chaque fonction fait **une seule chose** (extraire, OU transformer, OU charger) ; `main()` les enchaîne dans l'ordre.
**Syntaxe :**
```python
def main():
    ventes, catalogue = extract()
    df = transform(ventes, catalogue)
    load(df)

if __name__ == "__main__":   # ne s'exécute que si ce fichier est lancé directement
    main()
```
**Piège :** `if __name__ == "__main__"` évite que `main()` se lance tout seul si un autre script fait `import main`.

### `pd.json_normalize` — aplatir un JSON imbriqué
**Idée :** un JSON avec des objets imbriqués (ex. `fournisseur` dans chaque produit) doit être **aplati** en colonnes avant de devenir un DataFrame exploitable.
**Syntaxe :** `pd.json_normalize(json.load(open("fichier.json")), sep="_")` → les clés imbriquées deviennent `fournisseur_nom`, `fournisseur_pays`, etc.
**Piège :** sans `json_normalize`, la colonne imbriquée reste un **dict Python** dans une cellule — inutilisable pour filtrer/agréger.

### `drop_duplicates` — dédoublonner
**Idée :** supprime les lignes **strictement identiques** (doublon exact), pas les quasi-doublons.
**Syntaxe :** `df.drop_duplicates()` (toutes colonnes) ou `df.drop_duplicates(subset=["col"])` (doublon sur une colonne précise).
**Piège :** sans `subset`, deux lignes qui diffèrent par un seul caractère (espace en trop) ne sont **pas** détectées comme doublons.

### Nettoyer un texte incohérent (`str.strip` / `str.title`)
**Idée :** avant de joindre ou grouper sur une colonne texte, il faut uniformiser espaces et casse, sinon `"Paris"` et `" paris "` sont vus comme deux valeurs différentes.
**Syntaxe :** `df["ville"] = df["ville"].str.strip().str.title()`
**Piège :** l'ordre ne change rien ici, mais **oublier un des deux** (juste `.str.title()` sans `.strip()`) laisse passer les espaces parasites.

### Gérer les valeurs manquantes avant un `astype`
**Idée :** on ne peut pas convertir une colonne en entier si elle contient des `NaN` (valeur manquante) — il faut les retirer d'abord.
**Syntaxe :** `df = df.dropna(subset=["quantite"])` puis `df["quantite"] = df["quantite"].astype(int)`
**Piège :** `astype(int)` directement sur une colonne avec des `NaN` lève une erreur (`NaN` n'est pas un entier valide).

### `merge(how="left")` — joindre en gardant tout
**Idée :** un `left join` garde **toutes les lignes de gauche** (ici les ventes), même celles sans correspondance dans le catalogue.
**Syntaxe :** `ventes.merge(catalogue, on="produit_id", how="left")`
**Piège :** un `how="inner"` (par défaut) **supprimerait** les ventes dont le `produit_id` n'existe pas dans le catalogue — donc jamais `inner` quand la consigne dit « garder toutes les lignes ».

### SQLAlchemy — écrire dans PostgreSQL (`to_sql`)
**Idée :** `SQLAlchemy` est la bibliothèque qui connecte Python à une base SQL ; une fois l'`engine` (connexion) créé, pandas écrit le DataFrame en une ligne de code.
**Syntaxe :**
```python
from sqlalchemy import create_engine
engine = create_engine("postgresql+psycopg2://postgres:MDP@localhost:5432/postgres")
df.to_sql("ventes_propres", engine, if_exists="replace", index=False)
```
**Piège :** sans `index=False`, l'index pandas (0, 1, 2…) part comme colonne inutile dans la table SQL.

### `logging` — remplacer les `print`
**Idée :** le **logging** (journalisation) donne des messages datés avec un niveau de gravité (`INFO`, `ERROR`) — un `print` ne dit pas quand ni quelle gravité.
**Syntaxe :**
```python
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s")
logging.info("Extract : %d lignes lues", len(ventes))
```
**Piège :** `logging.error(...)` seul n'arrête rien — il faut un `raise` derrière si le pipeline doit s'arrêter sur cette erreur.

### `try/except` + `raise` dans un pipeline
**Idée :** un pipeline protège ses étapes fragiles (fichier absent, base injoignable) — mais contrairement à un simple script, il ne doit **pas continuer** avec des données absentes.
**Syntaxe :**
```python
try:
    ventes = pd.read_csv("data/raw/ventes_brutes.csv")
except FileNotFoundError:
    logging.error("Fichier introuvable")
    raise   # on relance l'erreur, le pipeline s'arrête
```
**Piège :** `except` sans `raise` **avale** l'erreur silencieusement — le pipeline continuerait avec `ventes` non défini.

### Règle du dossier `data/raw/`
**Idée :** les fichiers dans `data/raw/` sont la **source de vérité** — on ne les modifie jamais à la main.
**Syntaxe :** tout nettoyage se fait **dans le code** (`transform.py`), pas en éditant le CSV/JSON directement.
**Piège :** modifier `data/raw/` à la main casse la **reproductibilité** : le pipeline ne donnerait plus le même résultat en le relançant depuis zéro.

---

*Statut : le projet `projet-01-etl/` (Extract/Transform/Load) est en cours — les fichiers `src/*.py` sont encore au stade squelette (`TODO` + `NotImplementedError`). Cette fiche couvre les notions du cours, pas encore les corrections d'exercice.*
