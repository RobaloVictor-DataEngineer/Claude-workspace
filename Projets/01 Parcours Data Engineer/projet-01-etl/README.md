# Projet 01 — Pipeline ETL (Semaine 5)

Pipeline **ETL** (Extract, Transform, Load) qui récupère des données de ventes issues de deux sources
hétérogènes, les nettoie et les croise avec pandas, puis les charge dans une base **PostgreSQL** prête
à être interrogée.

## Objectif

Partir de données brutes et sales, et produire une table propre et exploitable, via un programme
**structuré, journalisé et reproductible** — sans jamais modifier les fichiers sources à la main.

## Stack

- **Python 3** — `pandas` (transformation), `SQLAlchemy` + `psycopg2` (connexion à la base), `python-dotenv` (gestion des secrets)
- **PostgreSQL** — base cible
- **DBeaver** — client SQL pour la vérification

## Les données sources (`data/raw/`)

| Fichier | Format | Contenu | Problèmes volontaires |
|---|---|---|---|
| `ventes_brutes.csv` | CSV | 26 lignes de ventes | lignes en double, `ville` en casse/espaces incohérents, quantités manquantes, `produit_id` hors catalogue |
| `catalogue.json` | JSON | 8 produits | bloc `fournisseur` **imbriqué** (à aplatir) |

> `data/raw/` est la **source de vérité** : ces fichiers ne sont jamais modifiés à la main, tout le
> nettoyage se fait dans le code pour rester reproductible.

## Le pipeline

```
   EXTRACT                  TRANSFORM                         LOAD
   ventes_brutes.csv ─┐
                      ├─►  nettoyage + jointure + calcul  ─►  PostgreSQL
   catalogue.json ────┘                                       ventes_catalogues_propres
```

**Extract** (`src/extract.py`)
- Lecture du CSV, protégée par un `try/except FileNotFoundError` (log de l'erreur puis `raise` : un pipeline ne continue pas sur des données absentes).
- Lecture du JSON et **aplatissement** avec `pd.json_normalize(..., sep="_")` → `fournisseur_nom`, `fournisseur_pays` (le `sep="_"` évite les points, qui obligeraient à quoter les colonnes en SQL).

**Transform** (`src/transform.py`)
1. Suppression des lignes strictement en double (26 → 24).
2. Retrait des lignes sans quantité, puis conversion de `quantite` en entier (24 → 21).
3. Normalisation de `ville` : valeurs manquantes étiquetées « Ville Inconnu », puis espaces retirés et casse uniformisée (`  paris `, `PARIS` → `Paris`).
4. Jointure au catalogue sur `produit_id` en `how="left"` : **aucune vente n'est perdue**, même celles dont le produit n'est pas au catalogue (2 lignes conservées, colonnes produit à `NaN`).
5. Colonne calculée `montant` = `quantite × prix`.

La fonction travaille sur une **copie** (`.copy()`) : elle ne modifie pas les DataFrames reçus en
paramètre (pas d'effet de bord sur l'appelant).

**Load** (`src/load.py`)
- Connexion construite avec `URL.create(...)` de SQLAlchemy (plutôt qu'une chaîne concaténée : les
  caractères spéciaux du mot de passe sont encodés automatiquement).
- Écriture avec `df.to_sql(table, engine, if_exists="replace", index=False)`.

**Orchestration** (`src/main.py`) : `main()` enchaîne `extract()` → `transform()` → `load()`.
Chaque phase journalise son avancement via `logging`.

**Résultat** : table `ventes_catalogues_propres`, **21 lignes**, CA total ≈ 23 547,84 €.

## Configuration (secrets)

Les identifiants de la base ne sont **jamais** dans le code.

1. Copie le modèle : `copy .env.example .env` (Windows)
2. Renseigne tes valeurs dans `.env` :
   ```
   DB_USER=postgres
   DB_PASSWORD=ton_mot_de_passe
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=postgres
   ```
`.env` est listé dans `.gitignore` : il ne partira jamais sur GitHub. Seul `.env.example`
(sans secret) est versionné.

## Comment lancer

```bash
python -m venv venv           # créer l'environnement virtuel
venv\Scripts\activate         # (Windows)  ou  source venv/bin/activate
pip install -r requirements.txt
python src/main.py            # depuis la racine du projet
```

## Vérification

Après exécution, dans DBeaver (`sql/verif.sql`) :

```sql
SELECT COUNT(*) FROM ventes_catalogues_propres;          -- doit renvoyer 21

SELECT ville, SUM(montant) AS ca_total
FROM   ventes_catalogues_propres
GROUP BY ville
ORDER BY ca_total DESC;
```

## Arborescence

- `data/raw/`       : données brutes, jamais modifiées à la main
- `data/processed/` : sorties générées par le code
- `src/`            : `extract.py`, `transform.py`, `load.py`, `main.py`
- `sql/`            : requêtes de vérification
- `notebooks/`      : brouillons d'exploration

## Ce que j'ai appris

- **Découper un pipeline en fonctions** (`extract` / `transform` / `load`) orchestrées par `main()` : une fonction = une responsabilité, c'est plus lisible et testable qu'un script d'un bloc.
- **Ne pas modifier ses entrées** : `drop_duplicates(inplace=True)` sur un paramètre altère les données de l'appelant. Travailler sur une copie évite cet effet de bord (et fait disparaître les `SettingWithCopyWarning`).
- **Une méthode pandas renvoie un résultat** : sans affectation (`ventes = ventes.drop_duplicates()`), le calcul est jeté et le nettoyage ne se fait pas.
- **Choisir le bon type de jointure** : un `left` conserve toutes les ventes, y compris celles sans produit au catalogue — un `inner` les aurait supprimées silencieusement.
- **Sortir les secrets du code** avec `.env` + `os.getenv()` + `.gitignore`.
- **Journaliser plutôt qu'afficher** : `logging` date les messages et distingue INFO/ERROR, indispensable pour un programme qui tourne seul.

## À retenir pour l'entretien

> « J'ai construit un pipeline ETL qui extrait des données de deux sources (un CSV et un JSON imbriqué
> façon réponse d'API), les nettoie avec pandas — doublons, types, valeurs manquantes, normalisation de
> texte — les croise par une jointure `left` pour ne perdre aucune vente, puis les charge dans PostgreSQL
> via SQLAlchemy. Le code est découpé en fonctions `extract` / `transform` / `load` orchestrées par un
> `main()`, avec du logging et de la gestion d'erreurs, et les identifiants de connexion sont sortis du
> code dans un `.env` ignoré par git. »

**Les deux points que je sais défendre :**
- *Pourquoi un `left join` ?* Pour ne pas perdre de lignes silencieusement. Sur ce jeu, 2 ventes portent un produit absent du catalogue : un `inner join` les aurait supprimées et aurait faussé le chiffre d'affaires sans alerte.
- *Pourquoi les secrets dans un `.env` ?* Parce qu'un mot de passe commité sur GitHub est compromis définitivement. `URL.create()` encode en plus les caractères spéciaux du mot de passe, ce qu'une chaîne de connexion concaténée ne fait pas.
