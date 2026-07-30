# REPRISE — Où j'en suis dans mon parcours Data Engineer

> Fichier à relire pour reprendre le fil depuis n'importe quel PC (même sans historique Cowork).
> **Dernière mise à jour : 22/07/2026.**
> Au démarrage d'une nouvelle session : faire lire au modèle ce fichier + `CLAUDE.md` (racine) + `CLAUDE.md` (ce projet).

---

## Point d'étape rapide

- **Semaines 1 à 6 : terminées** (Phases 0, 1, 2, 3). Tout est commité et **poussé sur GitHub**.
- **Statut planning :** S1 → S6 = « Terminé ». S7 = « À faire ».
- **1er vrai projet fait (S5) :** `projet-01-etl/` — pipeline ETL complet (extract CSV+JSON → transform pandas → load PostgreSQL via SQLAlchemy), en fonctions, avec logging, gestion d'erreurs et secrets dans un `.env`. **C'est le projet phare du portfolio.**
- **Prochaine étape :** démarrer la **Semaine 7** (Phase 3) : Java en survol + intro Spark.

---

## Ce qui est fait (Semaine 6) — Concepts DE + Airflow

**Cours** (`cours/semaine-06/`)
- 01 — Concepts : ETL vs ELT, data warehouse vs data lake, batch vs streaming, **idempotence**.
- 02 — Modélisation en **étoile** (faits vs dimensions, grain, dénormalisation).
- 03 — **Airflow** (DAG, tâches/opérateurs, dépendances `>>`, `schedule` cron, retries + lien idempotence).

**Exercices** (`exercices/concepts/`, questionnaires écrits — corrigés) : `s6_1_concepts_de.md`, `s6_2_modelisation_etoile.md`, `s6_3_airflow.md`.

**À consolider :** en modélisation, rattacher chaque attribut au bon objet (`ville` décrit la **vente/le lieu**, pas le produit → côté faits, pas dans `dim_produit`) ; `if_exists="replace"` **écrase et recrée toute la table** (ce n'est pas un upsert ligne à ligne, même si le résultat est idempotent).

---

## Ce qui est fait (Semaine 5) — Projet ETL 1

**Cours** (`cours/semaine-05/01_etl_concept_et_projet.md`) : concept ETL, code en fonctions, structure de projet, Load PostgreSQL avec SQLAlchemy, logging + gestion d'erreurs, secrets via `.env`.

**Projet** (`projet-01-etl/`, sur GitHub) : `src/extract.py` (CSV + JSON `json_normalize`), `src/transform.py` (dédoublonnage, NaN, types, nettoyage `ville`, jointure `left`, colonne `montant`), `src/load.py` (`URL.create` + `to_sql(if_exists="replace")`), `src/main.py` (orchestration + logging). Table produite : `ventes_catalogues_propres` (21 lignes). `.env` ignoré par git, `.env.example` versionné, README rempli.

**À consolider (vu à la correction) :** une méthode pandas **renvoie** un résultat (l'affecter : `ventes = ventes.drop_duplicates()`) ; travailler sur une **copie** pour ne pas modifier ses entrées (effet de bord) ni déclencher `SettingWithCopyWarning`.

---

## Ce qui est fait (Semaine 4) — Pandas avancé + SQL analytique

**Cours** (`cours/semaine-04/`)
- 01 Python — `merge` (jointure pandas, les `how`, piège de l'`inner` qui perd des lignes) + `concat`.
- 02 SQL — **CTE** (`WITH ... AS`), enchaînées, CTE + window function.
- 03 Python — `pivot_table` (tableau croisé, `fill_value`, `margins`).
- 04 Python — `apply`/`lambda` (dont `axis=1`) + piège « préférer le vectorisé ».
- 05 Python — **API → pandas** (`requests`, JSON, `pd.json_normalize`).

**Exercices** (`exercices/python/s4_1..s4_4`, `exercices/sql/s4_2`) — tous corrigés et validés.

**Mini-projet cumulatif S1→S4 :** `exercices/python/livrable/mini_projet_s1_s4.ipynb` — extract JSON+CSV, `concat`, `merge` (avec piège), `apply`, `groupby`+`pivot_table`, une classe, SQL (CTE + window via SQLite). Validé.

**Note méthode (demandes de Victor) :** vocabulaire technique exact (*trier* = `ORDER BY`/`sort_values` ≠ *classer/attribuer un rang* = `RANK`) ; explications avec **visuel avant/après empilé** ; **jamais** d'exercice « à toi d'inventer la question » (consignes fermées) ; **ne jamais régénérer/écraser un fichier de travail** (le lire, retouches ciblées).

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

- [x] Planning à jour : **S1 → S6 = « Terminé »**, S7 = « À faire ».
- [x] Tout le contenu S1→S6 **commité et poussé sur GitHub** (cours, exercices, mini-projets, projet ETL).
- [x] Bruit CRLF réglé (`.gitattributes`) ; dossier rangé (`.gitignore` + parasites supprimés).

---

## Prochaine étape — Semaine 7 (Phase 3 · Concepts Data Eng, suite)

**Focus : Java (survol) + intro Spark.**

- **Théorie à apprendre**
  - Java : syntaxe, types, conditions/boucles, classes/objets, collections (List, Map) — juste de quoi **lire** du code.
  - Spark : DataFrame distribué, *lazy evaluation*, différence avec pandas (+ PySpark si le temps).
- **Pratique à faire**
  - Un petit programme Java ; une fiche concepts Spark. **Lancer les 1res candidatures** (objectif planning S7).
- **Livrable / mini-projet S7 :** programme Java + fiche Spark (voir planning). Rappel : le mini-projet reste **cumulatif** (règle CLAUDE.md projet).

> Rappels méthode (tenus à jour dans le `CLAUDE.md` projet) : un seul thème à la fois ; consignes fermées et
> précises (jamais « invente la question ») ; exercices ≠ calque des exemples ; vocabulaire technique exact
> (*trier* ≠ *classer*) ; visuels avant/après empilés ; **ne jamais écraser un fichier de travail**.

---

## Rappels de contexte (pour le modèle)

- **Format des cours :** fiche d'abord (concept + exemple concret), exercices ensuite, dans un
  contexte différent. Avant chaque exercice, dire ce que je dois en retenir. Un seul thème à la fois,
  Python le matin / SQL l'après-midi. Code commenté en français.
- **Ma façon de travailler :** je code en **notebooks `.ipynb`**, pas en `.py` simple.
  Je veux comprendre, pas qu'on code à ma place. Sur un simple exercice, j'ai le droit d'innover
  (faire ce qui est demandé et/ou mieux).
- **Mon niveau :** SQL solide (alias, JOINs multiples, sous-requêtes, window functions, **CTE** en pratique),
  Python intermédiaire (bases + try/except + **pandas complet** : sélection/filtrage, `groupby`/agg, NaN,
  `merge`/`concat`, `pivot_table`, `apply`, API/JSON + **OOP** de base), **1 pipeline ETL** construit
  (extract/transform/load, SQLAlchemy, logging, `.env`), **concepts DE** (ETL/ELT, batch/streaming,
  warehouse/lake, idempotence, modélisation en étoile, Airflow). Java : débutant total (démarre en S7).
- **Objectif :** poste data engineer avant septembre 2026 (Rouen / Île-de-France, 40-50k EUR, pharma de préférence).

---

## Repères dans le dossier

- `Programme_Data_Engineer.docx` — vision d'ensemble des 11 semaines.
- `Planning_Data_Engineer.xlsx` — tableau de bord à cocher (statut par semaine).
- `cours/semaine-XX/` — fiches numérotées.
- `exercices/python|sql|java/` — exercices (1 fichier par notion) ; `exercices/python/livrable/` pour les livrables.
- `projet-01-etl/` — **1er pipeline ETL (fait, S5)** : projet phare du portfolio, sur GitHub.
- `exercices/concepts/` — questionnaires écrits des concepts DE (S6).
- `CLAUDE.md` (racine) + `CLAUDE.md` (projet) — mon profil, mes préférences, les règles d'apprentissage.
