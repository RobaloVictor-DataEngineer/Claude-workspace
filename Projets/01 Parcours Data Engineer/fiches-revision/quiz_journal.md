# Journal du quiz de réactivation (anti-répétition + points faibles)

> Tenu par la tâche programmée `quiz-reactivation-data-eng`.
> - **Anti-répétition** : la tâche ajoute chaque jour la date + les thèmes/questions posés, pour ne pas les reposer les ~3 jours suivants.
> - **Points à retravailler** : notions récemment ratées, à re-tester en priorité. Mises à jour à la correction.

## Points à retravailler (prioritaires)
- (À compléter au fil des corrections.)

## Historique des questions posées

### 03/08/2026
1. (priorité S4) Pandas `merge` : piège du `how="inner"` par défaut
2. (priorité S2) SQL : pourquoi une table dérivée (sous-requête dans le `FROM`) doit avoir un alias en PostgreSQL
3. (priorité S3) Python OOP : une méthode qui calcule doit `return` ou `print` ? pourquoi
4. SQL : `LAG`/`LEAD` — usage et exemple
5. SQL : CTE (`WITH`) — avantage vs sous-requête imbriquée
6. Pandas : différence `.isin()` vs `.between()`
7. Pandas : à quoi sert `pd.json_normalize` ?
8. Concepts DE : ETL vs ELT — différence principale
9. Concepts DE : idempotence — définition + pourquoi important avec Airflow
10. Java (S7, nouveau) : à quoi sert le mot-clé `this` dans une classe ?

### 31/07/2026
1. (priorité S6) `to_sql(if_exists="replace")` : upsert ligne à ligne ou autre chose ?
2. (priorité S6) Modélisation étoile : placement de l'attribut `ville` (faits vs dimension)
3. (priorité S5) `drop_duplicates()` : nécessité de l'affectation (`df = df.drop_duplicates()`)
4. SQL : lister les clients sans commande sans LEFT JOIN (sous-requête NOT IN/IN)
5. SQL : `RANK()` vs `ROW_NUMBER()` sur valeurs égales (rappel PARTITION BY)
6. Pandas : `groupby("categorie")["prix"].agg(["mean", "count"])`
7. Python OOP : pourquoi `self.solde` plutôt que `solde` dans une méthode
8. Concepts DE : batch vs streaming + exemple d'usage
9. Airflow : signification de l'opérateur `>>` entre deux tâches
10. Spark vs pandas : exécution distribuée (S7, nouveau)
