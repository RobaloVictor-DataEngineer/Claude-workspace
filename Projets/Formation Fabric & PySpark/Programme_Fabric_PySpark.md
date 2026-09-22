# Feuille de route — Fabric & PySpark

Objectif : passer de « je connais le vocabulaire » à « je maîtrise », **entretien d'abord**. On avance module par module (fiche → exo), un seul thème à la fois.

> **Déjà acquis** (parcours DE) : Spark distribué, lazy evaluation, transformation vs action, 1re chaîne PySpark exécutée (`filter`/`withColumn`/`groupBy`/`agg`/`orderBy`), et la fiche d'entretien Fabric. On part de là.

---

## Phase 0 — Cadrage (fait / rapide)
- Fiche d'entretien Fabric+PySpark créée (dans `Recherche Emploi.../Préparation entretiens/`).
- (Optionnel mais utile) créer un **compte d'essai Fabric** pour le hands-on (voir README).

## Phase 1 — PySpark (le code, pratiquable maintenant)
Chaque module = fiche courte + exercices de code à froid, exécutés pour validation.
1. **DataFrame Spark & lazy** : DataFrame vs pandas, transformations vs actions, plan d'exécution *(consolidation)*.
2. **Colonnes & expressions** : `select`, `filter`, `withColumn`, `F.col`, littéraux, conditions (`F.when`).
3. **Agrégations & jointures** : `groupBy().agg(F.sum/…)`, `join` (types), `orderBy` ; **fonctions fenêtre** Spark (`Window.partitionBy().orderBy()`, `row_number/rank/lag/lead`).
4. **Delta & Spark SQL** : lire/écrire des tables **Delta** (`format("delta")`, `saveAsTable`, `MERGE`), faire du **SQL** sur un DataFrame (`spark.sql`, vues temporaires).
5. **Performance** : partitions, `repartition` vs `coalesce`, **shuffle**, `cache`/`persist`, `partitionBy` à l'écriture *(niveau « en parler juste »)*.

## Phase 2 — Fabric (la plateforme)
Fiches + questionnaires ; mini-manips si compte d'essai.
6. **Vue d'ensemble & OneLake** : SaaS unifié, les expériences, OneLake sur ADLS Gen2, format Delta.
7. **Lakehouse vs Warehouse** : Spark-first vs T-SQL, SQL endpoint, quand choisir quoi.
8. **Data Factory** : pipelines (Copy, Notebook, conditions, planif), **Dataflows Gen2** (Power Query), et **architecture médaillon** (Bronze/Silver/Gold).
9. **Notebooks & shortcuts** : Spark dans Fabric, attacher un Lakehouse, **shortcuts** (virtualiser sans copier).
10. **Restitution** : **Direct Lake**, modèle sémantique, lien Power BI.
11. **Industrialisation** : **CI/CD** (Git integration + deployment pipelines, Azure DevOps), sécurité/gouvernance, **capacité** (F SKU) & coûts.

## Phase 3 — Prêt pour l'entretien
- **Q/R à froid** sur toute la banque (fiche d'entretien), cours fermé.
- **Mini-projet médaillon** (fil rouge) : ingestion → nettoyage (PySpark/Delta) → couche Gold en étoile, raconté « comme en entretien ».
- **Entretien blanc** technique (PySpark + Fabric + modélisation + CI/CD).

---

## Note pratique
- **PySpark** se pratique **maintenant** (notebook ; Claude exécute pour valider).
- **Fabric** = surtout **concepts** au début (répond à l'entretien) ; le hands-on vient avec le compte d'essai. Pas besoin d'attendre le compte pour être prêt à répondre.
