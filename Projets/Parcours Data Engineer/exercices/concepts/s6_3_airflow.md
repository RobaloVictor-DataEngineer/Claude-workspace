# Semaine 6 · Exercice — Airflow

> Réponds **par écrit**, sous chaque question. Réponses courtes et précises, comme en entretien.
> Les questions 4 à 6 portent sur **ton projet** (`projet-01-etl`).

---

## Partie A — Vocabulaire

**1.** Que signifie le sigle **DAG** ? Explique en une phrase ce que veulent dire les mots « orienté » et
« acyclique » dans le contexte d'un pipeline.

Réponse : DAG = **Directed Ayclic Graph** c'est le plan du pipeline. "Orienté" car on définit un ordre de tâche Extraire puis Transformer puis Charger et acyclique car on ne revient jamais à une étape précédente.


**2.** Associe chaque élément à sa définition (écris « a-… , b-… , c-… »).

Éléments : a) tâche · b) opérateur · c) `>>`
Définitions : 1) définit l'ordre entre les tâches · 2) une étape du DAG · 3) le type de tâche (ce qu'elle exécute)

Réponse :a-2, b-3, c-1

---

## Partie B — Lire un DAG

Voici un DAG (extrait) :

```python
with DAG(dag_id="rapport_quotidien", schedule="0 6 * * *", catchup=False) as dag:
    extraire   = PythonOperator(task_id="extraire",   python_callable=extraire_ventes)
    nettoyer   = PythonOperator(task_id="nettoyer",   python_callable=nettoyer_ventes)
    charger    = PythonOperator(task_id="charger",    python_callable=charger_bdd)
    notifier   = PythonOperator(task_id="notifier",   python_callable=envoyer_mail)

    extraire >> nettoyer >> charger >> notifier
```

**3.** Réponds :
a) À quelle heure et à quelle fréquence ce DAG se lance-t-il ?
b) Si la tâche `nettoyer` échoue, est-ce que `charger` s'exécute quand même ? Pourquoi ?
c) Combien de tâches ce DAG contient-il, et laquelle s'exécute en dernier ?

Réponse a : Tous les jours à 6h00
Réponse b : Non car il faut que `nettoyer` soit entièrement validé pour que`charger` s'exécute
Réponse c : 4 tâches et c'est la tâche `notifier` qui s'exécute en dernier

---

## Partie C — Ton projet (`projet-01-etl`)

**4.** Écris la ligne de dépendances (`>>`) qui orchestre ton pipeline, avec des tâches nommées
`t_extract`, `t_transform`, `t_load`.

Réponse : `t_extract` >> `t_transform` >> `t_load`.

**5.** Tu veux que ton pipeline tourne **tous les jours à 4h du matin**. Écris l'expression **cron**
correspondante (`schedule="..."`).

Réponse : schedule="0 4 * * *"

**6.** Tu ajoutes `retries=3` à ton DAG : Airflow pourra donc relancer une tâche jusqu'à 3 fois. En une
phrase, explique pourquoi le fait que ton pipeline soit **idempotent** (ton `if_exists="replace"`) est
indispensable pour que ces re-tentatives ne créent pas de problème.

Réponse : Car si on doit charger les données 3 fois ça évite d'avoir des doublons, le fait d'être idempotent va remplacer les données existantes par les nouvelles si elles existent déjà.

---

## Partie D — Question d'entretien

**7.** Un recruteur te demande : « **Ton pipeline de la S5, comment le mettrais-tu en production ?** »
Rédige ta réponse en 3 ou 4 phrases (parle d'Airflow, du DAG `extract >> transform >> load`, de la
planification, des retries, et fais le lien avec l'idempotence).

Réponse : Tout d'abord comme on souhaiterait avoir les données de manière périodique et automatique je vais utiliser Airflow. Je vais d'abord configurer les argument par défaut (dictionnaire) avec ``default_arg = {"retries": 3, "retry_delay": timedelta(minutes=5)}`` pour faire en sorte que de rééssayer 3 fois une étape du pipeline en cas d'échec avec un intervalle de 5min entre chaque réexécution.

Ensuite on va configurer le pipeline (DAG) comme ceci : ``[extraire_src1, extraire_src2, ....] >> transform >> load`` pour s'assurer que si il y a un problème avec une source on relancera l'étape que pour elle.

Dans les arguments du DAG on écrit ``schedule=0 6 * * *`` pour lancer le pipeline tous les jours à 6h00 du matin.

**--> Résultat :** étant donné que notre ETL est idempotent si on recommence l'étape `load` 3 fois on ne va pas réécrire 3 fois les données mais remplacés uniquement les données qui existent déjà par leurs équivalent dans le nouveau chargement, seules les nouvelles données sont ajoutées à la suite.
