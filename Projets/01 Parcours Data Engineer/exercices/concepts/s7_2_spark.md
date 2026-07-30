# Semaine 7 · Exercice — Intro Spark

> Réponds **par écrit**, sous chaque question. Réponses courtes et précises, comme en entretien.
> Tout ce qui est demandé a été vu dans la fiche `02_intro_spark.md`.

---

## Partie A — Transformation ou action ?

**1.** Pour chacune de ces opérations Spark, dis si c'est une **transformation** (lazy, décrit un calcul)
ou une **action** (déclenche l'exécution, renvoie un résultat).

a) `filter`
b) `count`
c) `select`
d) `show`
e) `groupBy`
f) `write`
g) `withColumn`
h) `collect`

**Réponses** :

a) `filter` : transformation

b) `count` : action

c) `select` : transformation

d) `show` : action

e) `groupBy` : transformation

f) `write` : action

g) `withColumn` : transformation

h) `collect` : action

---

## Partie B — Lazy evaluation

**2.** Voici un enchaînement PySpark :

```python
df2 = df.filter(df["montant"] > 100)     # ligne 1
df3 = df2.groupBy("ville").sum()         # ligne 2
df3.show()                               # ligne 3
```

a) À **quelle ligne** Spark exécute-t-il réellement les calculs ? Pourquoi les deux premières ne
déclenchent-elles rien ?
b) En une phrase : quel **avantage** Spark tire-t-il d'attendre l'action pour tout exécuter ?

**Réponse a** : A la ligne 3, elle va garder les 2 première ligne dans un plan car ce sont des opérations de transformation (filter, groupBy)

**Réponse b** : Cela permet à Spark d'optimiser les opérations de transformation avant de lancer une action d'affichage / agrégat (ex : sélectionner les colonnes pertinentes)

---

## Partie C — Traduire pandas → PySpark

**3.** Voici un traitement en **pandas**. Réécris-le en **PySpark** (en t'appuyant sur les exemples de la
fiche) : le chargement du CSV, le filtre, puis l'agrégation.

```python
import pandas as pd
df = pd.read_csv("ventes.csv")
df_gros = df[df["montant"] > 50]
resultat = df_gros.groupby("ville")["montant"].sum()
```

**Réponse (PySpark)** :

```python
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = SparkSession.builder.getOrCreate()
df = spark.read_csv("ventes.csv", header=True, inferSchema=True)
df_gros = df.filter(df["montant"] > 50)
resultat = df_gros.groupBy("ville")["montant"].sum()

```

---

## Partie D — Le bon outil

**4.** Pour chacun de ces deux cas, dis si tu partirais sur **pandas** ou **Spark**, et justifie en une
phrase.

a) Un fichier CSV de 20 Mo à nettoyer sur ton PC.
b) 800 Go de logs répartis sur un cluster, à agréger.

**Réponse a** : **Python** : car petit fichier on a pas besoin d'utiliser un cluster de machine une seule suffit 
**Réponse b** : **Spark** : Beaucoup trop de Go en plus répartis en cluster donc spark pour aggréger

---

## Partie E — Question d'entretien

**5.** Un recruteur te demande : « **Quelle est la différence entre pandas et Spark, et quand utiliser
l'un ou l'autre ?** » Réponds en 2 ou 3 phrases (parle du distribué, de la taille des données, et du
côté *lazy* de Spark).

**Réponse** : La différence c'est que Spark est un système distribué c'est à dire que l'on va diviser la prise en charge du code par un cluster de machine c'est à dire un groupe de machines qui vont faiure tourner le code en parallèle. 
On utilise en général Spark lorsque'on a un volume de données énorme (centaines de Go ou plus). De plus comparé à Python, Spark utilise le lazy evaluation qui va séparer les actions en **transformations** et en **actions** les tranbsfromations ne s'exécutent pas et sont stockées dans un plan et ne seront exécuté que lorsqu'on aura une ligne d'action (*show*, *count*, etc...)
