# Semaine 6 · Concepts — Le vocabulaire du data engineer

> Changement de registre : cette semaine, peu de code, beaucoup de **concepts**. Ce sont les questions
> qu'on te posera en entretien **avant** de te faire coder : « ETL ou ELT ? », « quelle différence entre
> un data warehouse et un data lake ? », « ton pipeline est-il idempotent ? ». Tu viens de construire un
> vrai pipeline — tu vas pouvoir raccrocher chaque concept à **ce que tu as fait toi-même**.

---

## 1. ETL vs ELT — l'ordre des opérations

Même trois lettres, ordre différent. La question est : **où** transforme-t-on les données ?

**ETL — on transforme AVANT de charger** (c'est ce que tu as fait en S5) :

```
Sources ──► [Python/pandas : nettoyage, jointures] ──► Base : données DÉJÀ propres
```

**ELT — on charge d'abord, on transforme APRÈS, dans la base** :

```
Sources ──► Base : données BRUTES telles quelles ──► [SQL dans la base] ──► tables propres
```

| | ETL | ELT |
|---|---|---|
| Transformation | avant le chargement, hors de la base | après, **dans** la base |
| Outil de transfo | Python / pandas / Spark | SQL (la puissance de la base) |
| On charge | uniquement le propre | tout le brut |
| Adapté quand | volumes modérés, base peu puissante | base très puissante (BigQuery, Snowflake), gros volumes |

**Pourquoi l'ELT est devenu courant :** les bases cloud modernes sont si puissantes qu'il est plus
efficace d'y déverser le brut et de transformer en SQL, que de tout faire transiter par une machine
Python. **Ton projet S5 est un ETL** : tu nettoies dans pandas, tu ne charges que le résultat propre.

---

## 2. Data warehouse vs data lake — où stocke-t-on ?

**En une phrase :** un **entrepôt** (warehouse) range des données **déjà structurées et propres** ; un
**lac** (lake) stocke **tout, brut**, dans son format d'origine.

| | Data warehouse (entrepôt) | Data lake (lac) |
|---|---|---|
| Contenu | données **structurées**, nettoyées, modélisées | **tout** : CSV, JSON, images, logs, brut |
| Schéma | défini **à l'écriture** (on range avant) | défini **à la lecture** (on range au moment d'exploiter) |
| Utilisateurs | analystes, BI, dashboards | data scientists, exploration |
| Exemples | PostgreSQL, Snowflake, BigQuery | stockage objet type S3, Azure Data Lake |
| Risque | rigide, coûteux à faire évoluer | devient un « data swamp » (marécage) si mal gouverné |

Image simple : l'entrepôt, c'est une **bibliothèque** (tout est classé, on trouve vite) ; le lac, c'est un
**grenier** (on garde tout, on triera plus tard). Ta table `ventes_catalogues_propres` dans PostgreSQL,
c'est un mini **data warehouse**.

---

## 3. Batch vs streaming — à quel rythme ?

**En une phrase :** en **batch**, on traite des données **par paquets, à intervalles réguliers** ; en
**streaming**, on traite **chaque événement au fil de l'eau**, en continu.

| | Batch (par lots) | Streaming (flux continu) |
|---|---|---|
| Rythme | toutes les nuits, toutes les heures… | en continu, à la milliseconde |
| Latence | minutes à heures | secondes ou moins |
| Cas typiques | reporting quotidien, facturation, consolidation | détection de fraude, alertes, suivi temps réel |
| Complexité | simple, rejouable | nettement plus complexe |
| Outils | cron, Airflow | Kafka, Spark Streaming, Flink |

Règle de bon sens (à dire en entretien) : **le batch suffit dans l'immense majorité des cas**. Le
streaming coûte cher en complexité, on ne le choisit que si le métier a réellement besoin du temps réel.
**Ton pipeline S5 est du batch** : tu le lances, il traite tout le fichier d'un coup.

---

## 4. Idempotence — le concept qui rassure les recruteurs

**En une phrase :** un traitement est **idempotent** si le **relancer plusieurs fois** donne **exactement
le même résultat** qu'une seule exécution — sans doublons ni effets cumulés.

Pourquoi c'est capital : un pipeline plante en pleine nuit, on le relance le matin. S'il n'est pas
idempotent, on se retrouve avec des lignes en double et des chiffres faux.

**PAS idempotent** — chaque exécution ajoute :

```
Lancement 1 : la table contient 21 lignes
Lancement 2 : la table contient 42 lignes   ❌ (les mêmes données en double)
```

**Idempotent** — chaque exécution remplace :

```
Lancement 1 : la table contient 21 lignes
Lancement 2 : la table contient 21 lignes   ✅ (résultat identique)
```

En pratique, c'est le choix du mode d'écriture :

```python
df.to_sql(table, engine, if_exists="replace", index=False)   # ✅ idempotent : on remplace la table
df.to_sql(table, engine, if_exists="append",  index=False)   # ❌ non idempotent : on ajoute à la suite
```

**Bonne nouvelle : ton pipeline S5 est déjà idempotent**, parce que tu as utilisé `if_exists="replace"`.
Tu peux le relancer dix fois, tu auras toujours tes 21 lignes. C'est un argument à sortir en entretien.

---

## 5. À retenir

- **ETL** = transformer **avant** de charger (Python/pandas) ; **ELT** = charger le brut puis transformer **dans** la base (SQL). Ton projet S5 = ETL.
- **Data warehouse** = données structurées et propres, schéma défini **à l'écriture** ; **data lake** = tout le brut, schéma défini **à la lecture**.
- **Batch** = par paquets à intervalles réguliers (suffit presque toujours) ; **streaming** = au fil de l'eau (temps réel, plus complexe).
- **Idempotence** = relancer le traitement donne le même résultat. `if_exists="replace"` ✅ / `"append"` ❌.

---

## 6. Exercice

> **Ce que tu dois en retenir :** savoir **nommer** ce que tu fais et **justifier** tes choix — c'est ce
> qui se joue dans la partie « questions de culture » d'un entretien. Plusieurs questions portent
> directement sur **ton propre projet ETL** : c'est exactement ainsi qu'on t'interrogera dessus.
> Réponds par écrit dans `exercices/concepts/s6_1_concepts_de.md`.

---

*Prochains thèmes de la S6 : la **modélisation en étoile** (tables de faits et de dimensions), puis
**Airflow** (DAG, tâches, planification) pour orchestrer un pipeline.*
