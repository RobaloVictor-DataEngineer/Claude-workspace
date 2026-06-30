# REPRISE — Où j'en suis dans mon parcours Data Engineer

> Fichier à relire pour reprendre le fil depuis n'importe quel PC (même sans historique Cowork).
> **Dernière mise à jour : 29/06/2026.**
> Au démarrage d'une nouvelle session : faire lire au modèle ce fichier + `CLAUDE.md` (racine) + `CLAUDE.md` (ce projet).

---

## Point d'étape rapide

- **Semaine en cours :** **Semaine 2** (Phase 1 · Pandas & SQL intermédiaire) — **démarrée le 29/06**.
- **Statut :** Semaine 1 **terminée**. Semaine 2 **quasi bouclée** : théorie + exercices + **livrable fait et validé** ; reste à committer/pousser le livrable sur GitHub pour clôturer.
- **Livrable S2 fait :** `exercices/python/livrable/analyse_exploratoire_pharmacie.ipynb` (dataset `data/ventes_pharmacie.csv`) — validé. À retenir des corrections : `dropna()` supprime la **ligne entière** → ne jeter que ce qui est nécessaire (`subset=`) ; les NaN n'étaient que sur `region`, donc le bon CA total = 20 588,32 €.
- **Prochaine étape côté Victor :** pousser le livrable sur GitHub (clôture S2), puis **Semaine 3**.

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

- [x] Le `lire_csv.ipynb` final est bien **commité + poussé** sur GitHub (commit `77494c1` « S1 : livrable script CSV », branche à jour avec origin/main).
- [x] Onglet **Planning** de `Planning_Data_Engineer.xlsx` : **S1 passé en « Terminé »**, S2 en « En cours ».
- [ ] **À committer vendredi** (convention hebdo) — tout le contenu S2 : `cours/semaine-02/01..03`, `exercices/python/data/villes.csv` + `commandes.csv`, `exercices/python/s2_1..s2_2`, `exercices/sql/s2_3_sousrequetes_jointures.sql`, le planning et le `CLAUDE.md` racine à jour.
- [ ] Reprendre les corrections SQL de `s2_3` (exercices 5, 6, 7, 8 — voir « À consolider » ci-dessus).
- [ ] Note : ~44 fichiers apparaissent « modifiés » dans git mais c'est uniquement un changement de fins de ligne (CRLF) après checkout sur un autre PC — pas de contenu modifié. Ne pas committer ce bruit (envisager un `.gitattributes`).

---

## Prochaine étape — finir la Semaine 2 (29/06 -> 05/07)

Théorie + exercices S2 = **faits**. Il reste :

- **Livrable Semaine 2 :** un **notebook d'analyse exploratoire** sur un dataset Kaggle
  (à télécharger ; le déposer dans `exercices/python/livrable/data/` ou un nouveau projet selon l'ampleur).
- Reprendre les corrections SQL de `s2_3` (5, 6, 7, 8).
- Puis bascule **Semaine 3** : pandas groupby/agg + merge + NaN ; SQL window functions ; Python OOP.

> Rappel méthode : un seul thème à la fois, théorie le matin / pratique l'après-midi,
> on n'avance à la semaine suivante que quand le livrable est sur GitHub.

---

## Rappels de contexte (pour le modèle)

- **Format des cours :** fiche d'abord (concept + exemple concret), exercices ensuite, dans un
  contexte différent. Avant chaque exercice, dire ce que je dois en retenir. Un seul thème à la fois,
  Python le matin / SQL l'après-midi. Code commenté en français.
- **Ma façon de travailler :** je code en **notebooks `.ipynb`**, pas en `.py` simple.
  Je veux comprendre, pas qu'on code à ma place. Sur un simple exercice, j'ai le droit d'innover
  (faire ce qui est demandé et/ou mieux).
- **Mon niveau :** SQL bon (théorie + alias/JOINs multiples/sous-requêtes en pratique), Python intermédiaire
  (bases + try/except + CSV + **pandas en pratique** acquis, pas encore d'OOP), Java débutant total.
- **Objectif :** poste data engineer avant septembre 2026 (Rouen / Île-de-France, 40-50k EUR, pharma de préférence).

---

## Repères dans le dossier

- `Programme_Data_Engineer.docx` — vision d'ensemble des 11 semaines.
- `Planning_Data_Engineer.xlsx` — tableau de bord à cocher (statut par semaine).
- `cours/semaine-XX/` — fiches numérotées.
- `exercices/python|sql|java/` — exercices (1 fichier par notion) ; `exercices/python/livrable/` pour les livrables.
- `projet-01-etl/` — **réservé à la Semaine 5** (1er vrai pipeline ETL), ne pas y toucher avant.
- `CLAUDE.md` (racine) + `CLAUDE.md` (projet) — mon profil, mes préférences, les règles d'apprentissage.
