# Semaine 6 · Concepts — Airflow : orchestrer un pipeline

> Ton pipeline ETL de la S5, tu le lances **à la main** (`python src/main.py`). En vrai, un pipeline doit
> tourner **tout seul** : chaque nuit, dans le bon ordre, en réessayant si ça plante, en prévenant en cas
> d'échec. C'est le rôle d'un **orchestrateur**, et le standard du métier s'appelle **Airflow**. Pas de
> code à installer cette semaine — l'objectif est de **comprendre et savoir en parler** en entretien.

---

## 1. Le problème qu'Airflow résout

Un vrai pipeline, ce n'est pas « je clique sur Run ». C'est :

- le lancer **automatiquement** à heure fixe (chaque nuit à 2h),
- respecter **l'ordre** : `load` ne doit pas démarrer avant que `transform` ait fini,
- **réessayer** tout seul si une étape échoue (réseau, base momentanément indisponible),
- **alerter** en cas d'échec, et garder un **historique** de ce qui a tourné.

Faire ça avec un `cron` + des scripts devient vite ingérable. **Airflow** gère tout ça pour toi et
te donne une **interface web** pour surveiller.

---

## 2. Le DAG — le cœur d'Airflow

**En une phrase :** un **DAG** (Directed Acyclic Graph = graphe orienté sans cycle) est le **plan de ton
pipeline** : les tâches, et **dans quel ordre** elles s'enchaînent.

```
   extract  ──►  transform  ──►  load
   (tâche 1)     (tâche 2)       (tâche 3)
```

Décortiquons le sigle :
- **Directed** (orienté) : les flèches ont un sens — `extract` **puis** `transform` **puis** `load`.
- **Acyclic** (sans cycle) : on ne revient jamais en arrière (pas de boucle infinie `load → extract`).
- **Graph** (graphe) : des tâches reliées par des dépendances.

Un DAG peut être plus riche qu'une simple ligne — par exemple deux extractions en **parallèle** qui se
rejoignent :

```
   extract_csv  ──┐
                  ├──►  transform  ──►  load
   extract_api  ──┘
```

---

## 3. Tâches et opérateurs

Une **tâche** (task) = une étape du DAG. On la crée avec un **opérateur** (le « type » de tâche) :

- **PythonOperator** : exécute une fonction Python (ex. ta fonction `extract()`).
- **BashOperator** : exécute une commande shell.
- **SQLOperator** (Postgres, etc.) : exécute une requête SQL.

```python
extract_task = PythonOperator(task_id="extract", python_callable=extract)
```

Chaque tâche a un **`task_id`** (son nom dans le DAG) et pointe vers ce qu'elle doit faire.

---

## 4. Les dépendances : l'opérateur `>>`

C'est ce qui définit **l'ordre**. On lit `>>` comme « **puis** » :

```python
extract_task >> transform_task >> load_task
#   extract PUIS transform PUIS load
```

AVANT (des tâches sans lien — Airflow pourrait les lancer n'importe comment) :

```
extract      transform      load        (aucun ordre garanti)
```

APRÈS (`extract_task >> transform_task >> load_task`) :

```
extract  ──►  transform  ──►  load       (ordre garanti)
```

Pour du parallèle : `extract_csv >> transform` **et** `extract_api >> transform` → les deux extractions
doivent finir avant que `transform` démarre.

---

## 5. La planification (`schedule`) — la syntaxe cron

On dit à Airflow **à quelle fréquence** relancer le DAG, avec une expression **cron** (5 champs) :

```
schedule="0 2 * * *"     ->  tous les jours à 02h00
         │ │ │ │ │
         │ │ │ │ └── jour de la semaine (0-6)
         │ │ │ └──── mois (1-12)
         │ │ └────── jour du mois (1-31)
         │ └──────── heure (0-23)
         └────────── minute (0-59)
```

Exemples : `"0 * * * *"` = toutes les heures ; `"0 8 * * 1"` = tous les lundis à 8h. Le `*` = « chaque ».

---

## 6. Robustesse : retries et alertes

Airflow rejoue tout seul une tâche qui échoue, un nombre de fois défini :

```python
default_args = {
    "retries": 3,                          # jusqu'à 3 nouvelles tentatives
    "retry_delay": timedelta(minutes=5),   # 5 min entre chaque essai
}
```

Utile pour les pannes **passagères** (base momentanément injoignable). C'est là que ton pipeline doit
être **idempotent** (concept de la fiche 1) : puisqu'Airflow peut relancer une tâche, il faut que la
relancer ne crée pas de doublons — ton `if_exists="replace"` garantit ça.

---

## 7. Un DAG complet (ton ETL orchestré)

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
from src.extract import extract
from src.transform import transform
from src.load import load

default_args = {"retries": 2, "retry_delay": timedelta(minutes=5)}

with DAG(
    dag_id="pipeline_ventes",
    schedule="0 2 * * *",              # chaque nuit à 2h
    start_date=datetime(2026, 1, 1),
    catchup=False,                     # ne pas rejouer tout l'historique manqué
    default_args=default_args,
) as dag:

    t_extract   = PythonOperator(task_id="extract",   python_callable=extract)
    t_transform = PythonOperator(task_id="transform", python_callable=transform)
    t_load      = PythonOperator(task_id="load",      python_callable=load)

    t_extract >> t_transform >> t_load     # l'ordre du pipeline
```

C'est **exactement ton `main()` de la S5**, mais déclaré comme un DAG : Airflow le lancera chaque nuit,
dans l'ordre, avec des reprises en cas d'échec, et tu surveilleras le tout depuis une interface web.

---

## 8. Vocabulaire à reconnaître (pour l'entretien)

- **Scheduler** : le composant d'Airflow qui déclenche les DAG au bon moment.
- **Webserver / UI** : l'interface web où l'on voit les DAG, l'état des tâches (vert = réussi, rouge = échoué), les logs.
- **Run / instance de DAG** : une exécution datée du DAG (le run du 20/07, celui du 21/07…).
- **Backfill / catchup** : rejouer les exécutions passées manquées (souvent désactivé avec `catchup=False`).

---

## 9. À retenir

- **Airflow** = orchestrateur : lance des pipelines **automatiquement**, dans le **bon ordre**, avec **reprises** et **surveillance**.
- **DAG** = graphe orienté sans cycle = le plan du pipeline (les tâches + leur ordre).
- **Tâche** créée par un **opérateur** (`PythonOperator` pour lancer une fonction) ; ordre défini par **`>>`** (« puis »).
- **`schedule`** = fréquence en **cron** (`"0 2 * * *"` = chaque nuit à 2h).
- **`retries`** = re-tentatives auto → nécessite un pipeline **idempotent** (ton `if_exists="replace"`).
- Ton ETL S5 orchestré = `extract >> transform >> load` dans un DAG planifié.

---

## 10. Exercice

> **Ce que tu dois en retenir :** lire un DAG, en comprendre l'ordre et la planification, et savoir
> décrire comment on **industrialiserait** ton propre pipeline. « Comment planifierais-tu ce pipeline en
> prod ? » est une question d'entretien quasi systématique. Réponds par écrit dans
> `exercices/concepts/s6_3_airflow.md`.

---

*Après ça, la Semaine 6 est bouclée. La suite (S7) : Java (survol) et une intro à Spark.*
