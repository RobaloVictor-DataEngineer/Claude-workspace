# REPRISE — Où j'en suis dans mon parcours Data Engineer

> Fichier à relire pour reprendre le fil depuis n'importe quel PC (même sans historique Cowork).
> **Dernière mise à jour : 07/07/2026.**
> Au démarrage d'une nouvelle session : faire lire au modèle ce fichier + `CLAUDE.md` (racine) + `CLAUDE.md` (ce projet).

---

## Point d'étape rapide

- **Semaines 1, 2 et 3 : terminées** (Phase 0 + Phase 1). Contenu, exercices corrigés et livrables/mini-projet faits et validés.
- **Statut planning :** S1, S2, S3 = « Terminé ». S4 = « À faire ».
- **Mini-projet S3 (cumulatif S1→S3) fait et validé :** `exercices/python/livrable/mini_projet_s1_s3.ipynb` (dataset `data/ventes_pharmacies.csv`) — pandas + une classe OOP qui `return` + SQL (jointure/sous-requête/window via SQLite). Bien géré : NaN pharmacie remplacés par un **label** (`fillna("Pharmacie inconnue")`), pas par 0.
- **Prochaine étape côté Victor :** committer/pousser le contenu S2 **et** S3 sur GitHub (avec `git add --renormalize .`), puis démarrer la **Semaine 4**.

---

## Ce qui est fait (Semaine 3)

**Cours** (`cours/semaine-03/`)
- 01 Python — pandas `groupby`/agg (split-apply-combine, `.agg()`, named aggregation, multi-clés) + gestion des NaN.
- 02 SQL — window functions (`OVER`, `PARTITION BY` vs `GROUP BY`, ROW_NUMBER/RANK/DENSE_RANK, agrégat fenêtré, cumul, LAG/LEAD).
- 03 Python — première classe OOP (classe/instance/attribut/méthode, `__init__`, `self`) + 4 pièges détaillés (self vs local, `__init__` porte l'état, indépendance des instances, `return` vs `print`).

**Exercices** (corrigés)
- `exercices/python/s3_1_pandas_groupby.ipynb` (dataset `data/essais_cliniques.csv`) — validé.
- `exercices/sql/s3_2_window_functions.sql` (base boutique) — validé.
- `exercices/python/s3_3_oop_premiere_classe.ipynb` (classe Panier) — validé.

**Mini-projet cumulatif S1→S3 :** `exercices/python/livrable/mini_projet_s1_s3.ipynb` — complet et validé.

**Notions acquises :** pandas `groupby`/agg + NaN (`dropna(subset=)`, `fillna(label)`), SQL window functions, OOP (première classe, `self`, `return` vs `print`).

**À consolider :** `PARTITION BY` = « recommence le calcul par groupe » (à ne PAS mettre pour un cumul global) ; dans une classe, toujours `self.` (pas la variable globale) ; méthodes en `snake_case` ; une méthode qui calcule doit `return`.

**Rangement du dossier (07/07) :** ajout d'un `.gitignore` (`.venv/`, caches) et d'un `.gitattributes` (fin du bruit CRLF) ; suppression de 3 fichiers parasites (`Postgres local.session.sql` vide, `projet-01-etl/test.py` égaré, doublon `analyse_exploratoire_pharmacie_avec_test.ipynb`).

---

## Ce qui est fait (Semaine 2)

**Cours** (`cours/semaine-02/`)
- 01 Python — pandas fondamentaux (Series/DataFrame, read_csv, inspection, loc/iloc, filtrage, tri, colonne calculée)
- 02 Python — pandas sélection avancée (value_counts, isin, between, nlargest, accesseur .str, chaînage)
- 03 SQL — alias, JOINs multiples (4 tables), sous-requêtes (scalaire, IN/NOT IN, table dérivée)

**Exercices** (corrigés)
- `exercices/python/s2_1_pandas_fondamentaux.ipynb` (dataset `data/villes.csv`) — validé.
- `exercices/python/s2_2_pandas_intermediaire.ipynb` (dataset `data/commandes.csv`) — validé (rappels : `value_counts` sur 1 colonne = Series ; `.tolist()` avec les `()`).
- `exercices/sql/s2_3_sousrequetes_jointures.sql` (base boutique + bloc de prépa : client Nora sans commande, produit Webcam jamais commandé) — fait, **points à revoir** ci-dessous.

**Notions acquises cette semaine :** pandas en pratique (sélection, filtrage, tri, colonnes calculées, value_counts/isin/between/nlargest/.str, chaînage) ; SQL alias + JOINs multiples + sous-requêtes.

**À consolider (vu sur s2_3) :** ne pas mélanger JOIN et sous-requête — `NOT IN`/absence = **sous-requête seule, jamais un INNER JOIN** (un INNER JOIN supprime d'avance les lignes sans correspondance) ; une table dérivée (`FROM (...)`) exige un **alias** en PostgreSQL.

**Note méthode (demande de Victor 29/06) :** les exercices doivent moins calquer les exemples du cours → désormais énoncés « questions métier », sans nommer la méthode, avec pièges/combinaisons pour forcer le choix de l'outil.

---

## Profil mis à jour le 29/06

- Ligne **Python** du `CLAUDE.md` principal passée de « pas encore pandas en pratique » à « pandas en pratique » (détail des méthodes ajouté).

---

## Ce qui est fait (Semaine 1)

**Cours** (`cours/semaine-01/`)
- 01 Python — structures & comprehensions
- 02 SQL — modélisation & création
- 03 Python — fonctions
- 04 SQL — interroger une table
- 05 SQL — jointures
- 06 Python — try/except
- 07 Python — livrable « lire un CSV »

**Exercices** (`exercices/`)
- Python : comprehensions, fonctions, try/except (notebooks `.ipynb`) — tous validés.
- SQL : DDL/fonctions, interrogations, JOINs (>= 10 requêtes) — fait.

**Livrable Semaine 1** (objectif planning : repo + script CSV + 10 requêtes SQL)
- Repo GitHub `Claude-parcours-data-eng` : OK
- 10 requêtes SQL : OK
- Script `lire_csv.ipynb` (`exercices/python/livrable/`) : OK — lit un CSV, gère
  `FileNotFoundError` et `ValueError`, garde les produits complets, calcule le prix moyen.

**Notions acquises cette semaine :** try/except (`FileNotFoundError`, `ValueError`, `KeyError`),
lecture CSV avec le module `csv` (`DictReader`), fonctions, comprehensions.

---

## À vérifier avant de continuer

- [x] Planning à jour : **S1, S2, S3 = « Terminé »**, S4 = « À faire ».
- [x] Bruit CRLF réglé par un `.gitattributes` ; dossier rangé (`.gitignore` + parasites supprimés).
- [ ] **À committer/pousser sur GitHub** (clôture officielle S2+S3) : tout `cours/semaine-02` et `cours/semaine-03`, les exercices S2+S3, le mini-projet `mini_projet_s1_s3.ipynb`, les datasets, le planning, `.gitignore`, `.gitattributes`, les deux `CLAUDE.md`. Lancer d'abord `git add --renormalize .` pour absorber le CRLF.

---

## Prochaine étape — Semaine 4 (Phase 2 · Approfondissement)

**Focus : pandas avancé + SQL analytique.**

- **Théorie à apprendre**
  - Pandas : `pivot_table`, `apply`/`lambda`, `concat`, `merge` complexe, lecture JSON/Excel/API (`requests`).
  - SQL : CTE (Common Table Expression = `WITH ... AS (...)`), index, notion de performance.
- **Pratique à faire**
  - Un appel **API** + transformation en pandas ; des requêtes **CTE**.
- **Livrable / mini-projet S4 :** cumulatif **S1 → S4** (règle du CLAUDE.md projet), un cran au-dessus,
  intégrant un flux API→pandas et du SQL avec CTE.

> Rappels méthode : un seul thème à la fois, Python le matin / SQL l'après-midi ; on ne valide la semaine
> qu'une fois le livrable sur GitHub. Exercices = **questions métier**, jamais un calque des exemples.

---

## Rappels de contexte (pour le modèle)

- **Format des cours :** fiche d'abord (concept + exemple concret), exercices ensuite, dans un
  contexte différent. Avant chaque exercice, dire ce que je dois en retenir. Un seul thème à la fois,
  Python le matin / SQL l'après-midi. Code commenté en français.
- **Ma façon de travailler :** je code en **notebooks `.ipynb`**, pas en `.py` simple.
  Je veux comprendre, pas qu'on code à ma place. Sur un simple exercice, j'ai le droit d'innover
  (faire ce qui est demandé et/ou mieux).
- **Mon niveau :** SQL bon (alias, JOINs multiples, sous-requêtes **et window functions** en pratique),
  Python intermédiaire (bases + try/except + CSV + **pandas** — dont `groupby`/agg et gestion des NaN —
  + **première classe OOP** acquis), Java débutant total.
- **Objectif :** poste data engineer avant septembre 2026 (Rouen / Île-de-France, 40-50k EUR, pharma de préférence).

---

## Repères dans le dossier

- `Programme_Data_Engineer.docx` — vision d'ensemble des 11 semaines.
- `Planning_Data_Engineer.xlsx` — tableau de bord à cocher (statut par semaine).
- `cours/semaine-XX/` — fiches numérotées.
- `exercices/python|sql|java/` — exercices (1 fichier par notion) ; `exercices/python/livrable/` pour les livrables.
- `projet-01-etl/` — **réservé à la Semaine 5** (1er vrai pipeline ETL), ne pas y toucher avant.
- `CLAUDE.md` (racine) + `CLAUDE.md` (projet) — mon profil, mes préférences, les règles d'apprentissage.
