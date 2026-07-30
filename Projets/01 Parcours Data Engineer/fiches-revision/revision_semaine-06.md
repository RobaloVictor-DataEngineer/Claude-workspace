# Fiche de révision — Semaine 6 (Concepts Data Engineering + Airflow)

> Antisèche entretien. Semaine sans code ou presque : le **vocabulaire** du data engineer (ETL/ELT, warehouse/lake, batch/streaming, idempotence), la **modélisation en étoile**, et **Airflow**. Chaque notion se raccroche à ton projet `projet-01-etl/` (S5).

---

### ETL vs ELT — l'ordre des opérations
**Idée :** ETL = Extract, Transform, Load (Extraire, Transformer, Charger) — on **transforme avant** de charger (Python/pandas) ; ELT = on **charge le brut d'abord**, puis on transforme **dans** la base (SQL).
**Syntaxe :** pas de code — c'est un choix d'architecture. ETL : `pandas → base propre`. ELT : `base brute → SQL → tables propres`.
**Piège :** l'ELT n'est pas "mieux" dans l'absolu — il suppose une base assez puissante (BigQuery, Snowflake) pour transformer en SQL. Ton projet S5 est un **ETL**.

### Data warehouse vs data lake
**Idée :** un **warehouse** (entrepôt) stocke des données déjà **structurées et propres**, schéma défini **à l'écriture** ; un **lake** (lac) stocke **tout, brut**, schéma défini **à la lecture**.
**Syntaxe :** pas de code — warehouse = PostgreSQL/Snowflake/BigQuery ; lake = stockage objet type S3.
**Piège :** un data lake mal gouverné devient un « data swamp » (marécage) — tout est là mais rien n'est exploitable. Ta table `ventes_catalogues_propres` = un mini data warehouse.

### Batch vs streaming
**Idée :** **batch** = traiter des données **par paquets**, à intervalles réguliers ; **streaming** = traiter **chaque événement en continu**, au fil de l'eau.
**Syntaxe :** pas de code — batch : cron/Airflow ; streaming : Kafka/Spark Streaming.
**Piège :** le streaming coûte cher en complexité — on ne le choisit que si le métier a un vrai besoin de temps réel. Le batch suffit dans l'immense majorité des cas. Ton pipeline S5 = batch.

### Idempotence
**Idée :** un traitement est **idempotent** si le **relancer plusieurs fois** donne exactement le **même résultat** qu'une seule fois — sans doublons ni effets cumulés.
**Syntaxe :**
```python
df.to_sql(table, engine, if_exists="replace", index=False)   # idempotent : remplace la table
df.to_sql(table, engine, if_exists="append",  index=False)   # NON idempotent : ajoute à chaque fois
```
**Piège :** `if_exists="replace"` n'est **pas** un upsert ligne à ligne — ça **écrase et recrée toute la table**. Le résultat est idempotent, mais le mécanisme n'est pas une mise à jour fine.

### Modélisation en étoile — faits vs dimensions
**Idée :** une table de **faits** contient ce qu'on **mesure** (des nombres qui s'additionnent : quantité, montant) ; une table de **dimension** contient ce par quoi on **filtre/regroupe** (des étiquettes : catégorie, ville, client).
**Syntaxe :** test rapide — « est-ce que ça s'additionne ? » Oui → fait. Non (étiquette) → dimension. `faits_ventes(produit_id, client_id, date, quantite, montant)` + `dim_produit(produit_id, nom, categorie)`.
**Piège :** un attribut se rattache au bon **objet**, pas au premier qui passe — `ville` décrit la vente/le lieu (côté faits ou dimension lieu), **pas** `dim_produit`.

### Le grain d'une table de faits
**Idée :** le **grain** = ce que représente **une ligne** de la table de faits. Il se définit **en premier**, avant tout le reste du modèle.
**Syntaxe :** pas de code — grain fin : « une ligne = une ligne de commande » ; grain grossier : « une ligne = une commande entière » ou « un total par jour ».
**Piège :** on choisit toujours le grain **le plus fin utile** — on peut agréger un grain fin après coup (sommer par jour), mais on ne peut jamais **redétailler** un grain déjà grossier (info perdue).

### Dénormalisation (warehouse vs base transactionnelle)
**Idée :** une base **transactionnelle** normalise à fond (peu de répétition, beaucoup de petites tables) pour bien **écrire** ; un data warehouse en étoile **dénormalise** un peu pour des analyses simples et rapides.
**Syntaxe :** pas de code — `dim_produit` regroupe produit + catégorie + fournisseur dans **une seule** table, au lieu de les éclater en 3.
**Piège :** dénormaliser n'est pas une erreur de modélisation ici — c'est un choix assumé : un peu de répétition contre moins de jointures à l'analyse.

### DAG — le plan du pipeline
**Idée :** DAG = Directed Acyclic Graph (graphe orienté sans cycle) = les tâches d'un pipeline **et** l'ordre dans lequel elles s'enchaînent.
**Syntaxe :**
```python
extract_task >> transform_task >> load_task   # "puis" : ordre garanti
```
**Piège :** **Acyclic** = jamais de retour en arrière (pas de boucle `load → extract`). Sans dépendance déclarée (`>>`), Airflow ne garantit **aucun ordre** entre les tâches.

### Opérateurs Airflow (`PythonOperator`)
**Idée :** une **tâche** est créée par un **opérateur**, qui définit son type d'action (exécuter une fonction Python, une commande shell, une requête SQL).
**Syntaxe :**
```python
extract_task = PythonOperator(task_id="extract", python_callable=extract)
```
**Piège :** `task_id` est le nom de la tâche **dans le DAG** (affiché dans l'interface), pas le nom de la fonction Python appelée.

### `schedule` — syntaxe cron
**Idée :** le `schedule` dit à Airflow **à quelle fréquence** relancer le DAG, via une expression cron à 5 champs (minute, heure, jour du mois, mois, jour de la semaine).
**Syntaxe :** `schedule="0 2 * * *"` → tous les jours à 2h00. `"0 8 * * 1"` → tous les lundis à 8h.
**Piège :** l'ordre des champs est fixe (minute d'abord, pas heure) — `*` veut dire « chaque », pas « jamais ».

### `retries` — pourquoi l'idempotence est indispensable ici
**Idée :** Airflow peut **rejouer automatiquement** une tâche qui échoue (panne réseau passagère) — mais ça ne marche que si la tâche est **idempotente**, sinon la relancer crée des doublons.
**Syntaxe :**
```python
default_args = {"retries": 3, "retry_delay": timedelta(minutes=5)}
```
**Piège :** `retries` sans idempotence (ex. `if_exists="append"`) est dangereux — chaque nouvelle tentative ajouterait les données une fois de plus.

---

*Statut : Semaine 6 terminée (cours + 3 exercices écrits corrigés dans `exercices/concepts/`). Prochaine étape : Semaine 7 — Java (survol) + intro Spark.*
