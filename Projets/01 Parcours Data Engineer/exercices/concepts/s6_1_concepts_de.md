# Semaine 6 · Exercice — Concepts data engineering

> Réponds **par écrit**, sous chaque question, en 1 à 3 phrases. Ce sont des réponses d'entretien :
> vise la clarté, pas la longueur. Les questions 5 à 8 portent sur **ton propre projet** (`projet-01-etl`).

---

## Partie A — Classer des situations

**1.** Pour chacune de ces trois situations, dis si c'est de l'**ETL** ou de l'**ELT**, et justifie en une phrase.

a) Une équipe déverse chaque nuit les fichiers bruts de 12 boutiques dans Snowflake, puis lance des requêtes SQL dans Snowflake pour construire les tables propres.

b) Un script Python lit un CSV, supprime les doublons, calcule des totaux, et insère uniquement le résultat final dans PostgreSQL.

c) Une entreprise copie telles quelles les tables de son logiciel de caisse dans BigQuery, et l'équipe analytics écrit ensuite des vues SQL pour les nettoyer.

Réponse a : **ELT** --> on extrait les donner puis on les transforme directement dans la BDD

Réponse b : **ETL** --> les données sont extraites puis transformées directement en python avant d'être chargé dans la BDD

Réponse c : **ELT** --> --> on extrait les donner puis on les transforme directement dans la BDD 

---

**2.** Pour chacun de ces trois besoins, dis si tu partirais sur du **batch** ou du **streaming**, et justifie en une phrase.

a) Un rapport de chiffre d'affaires envoyé à la direction chaque lundi matin.

b) Le blocage d'une carte bancaire dès qu'une transaction suspecte est détectée.

c) La consolidation mensuelle des notes de frais pour la comptabilité.

Réponse a : **batch** --> groupe de données envoyés de manière **périodique** (hebdomadaire)

Réponse b : **streaming** --> Pas d'intervalles, ici dès qu'un changement arrive la carte est bloqué (continu)

Réponse c : **batch** --> groupe de données envoyés de manière **périodique** (mensuelle)

---

**3.** Pour chacun de ces trois stockages, dis si on décrit plutôt un **data warehouse** ou un **data lake**, et justifie en une phrase.

a) On y dépose pêle-mêle des logs serveur, des photos de produits et des exports CSV, sans schéma défini, « au cas où on en aurait besoin ».

b) Des tables structurées, nettoyées et documentées, alimentant les tableaux de bord Power BI de l'entreprise.

c) Le schéma des données n'est décidé qu'au moment où un data scientist vient les exploiter.

Réponse a : **data lake** --> les données stockées sont brutes et non transformé

Réponse b : **data warehouse** --> entrepôt de données structurées 

Réponse c : **data lake** --> car si les données étaient bien structuré, pas besoin de de faire des schémas de données "à la demande"

---

## Partie B — Idempotence

**4.** Voici deux versions d'une étape de chargement. Dis laquelle est **idempotente**, explique pourquoi, et décris ce qui se passe concrètement si on relance le script **trois fois** dans chaque cas.

```python
# Version 1
df.to_sql("ventes", engine, if_exists="append", index=False)

# Version 2
df.to_sql("ventes", engine, if_exists="replace", index=False)
```

Réponse : La **version 2** est idempotente car avec l'argument if_exists si on met "replace" ça va remplacer les données de la table par celles que l'on charge tandis qu'avec "append" on va rajouter à la suite.

---

## Partie C — Ton projet (`projet-01-etl`)

**5.** Ton pipeline de la S5 est-il un **ETL** ou un **ELT** ? Justifie en désignant l'endroit précis où la transformation a lieu dans ton code.

Réponse : C'est un **ETL** car on va d'abord extraire + transformer les données avant de les charger, on enclenche la phase de transformation à cette ligne **"df = transform(ventes, catalogues)"** ce qui va déclencher le script **transform.py**

---

**6.** Ton pipeline fonctionne-t-il en **batch** ou en **streaming** ? Justifie en une phrase.

Réponse : je dirais **batch** car on sfonctionne sur des groupes de données (fichiers CSV et json) mais les données ne vont pas être ajoutés en continu si on rajoute des données dans les fichiers

---

**7.** Ton pipeline est-il **idempotent** ? Cite la **ligne de code exacte** qui répond à la question, et dis ce qui se passerait si tu la remplaçais par l'autre mode d'écriture.

Réponse : Oui, il l'est, car on a cette ligne **df.to_sql(table, engine, if_exists="replace", index=False)** avec l'argument **if_exists="replace"** qui m'assure que les nouvelles données remplaceront les anciennes au lieu de les rajouter en plus

---

**8.** Ta table `ventes_catalogues_propres` dans PostgreSQL relève-t-elle plutôt de la logique **data warehouse** ou **data lake** ? Justifie en une phrase.

Réponse : Je dirais **Data wharehouse** car les données sont stockées au propre dans la table, elles ne sont pas envoyés sous forme bruts, on les mets au propre avant. 

---

## Partie D — Question d'entretien

**9.** Un recruteur te demande : « **Pourquoi ne pas tout faire en streaming, puisque c'est plus moderne ?** » Rédige ta réponse en 2 ou 3 phrases.

Réponse : Tout dépend des données que l'on a ainsi quer de la demande. Dans la plupart des cas le batch fonctionne car très peu coûteux et beaucoup moins complexe à mettre en place.
          On utilisera le streaming pour du suivi en temps réel ou la détection de fraude par exemple. 
