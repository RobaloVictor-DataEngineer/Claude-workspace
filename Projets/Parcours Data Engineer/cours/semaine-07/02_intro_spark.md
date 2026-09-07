# Semaine 7 · Spark — Introduction (pandas à grande échelle)

> Dernier thème de la S7. **Spark** est l'outil qu'on sort quand les données sont **trop grosses pour une
> seule machine** (des téraoctets, des milliards de lignes). Bonne nouvelle : conceptuellement, un
> DataFrame Spark ressemble beaucoup à un DataFrame pandas — tu vas surtout apprendre **ce qui change** et
> **pourquoi**. Objectif de survol : comprendre les 2 idées clés (distribué + *lazy*) et savoir en parler.

---

## 1. Le problème que Spark résout

pandas charge **toutes les données dans la mémoire (RAM) d'UNE machine**. Si ton fichier fait 500 Go, ça
ne rentre pas — pandas plante. **Spark** découpe les données en morceaux et les répartit sur **plusieurs
machines** (un *cluster*) qui travaillent **en parallèle**. C'est le **calcul distribué**.

```
   pandas                          Spark
   ┌─────────────┐                 ┌────────┐ ┌────────┐ ┌────────┐
   │ 1 machine   │                 │machine1│ │machine2│ │machine3│   ... (un cluster)
   │ toute la RAM│                 │ 1/3 des│ │ 1/3 des│ │ 1/3 des│
   │ = 1 limite  │                 │ données│ │ données│ │ données│
   └─────────────┘                 └────────┘ └────────┘ └────────┘
   OK jusqu'à ~ la RAM             les machines calculent EN PARALLÈLE
```

Règle de bon sens (à dire en entretien) : **pandas** pour ce qui tient sur une machine (jusqu'à quelques
Go) ; **Spark** quand ça dépasse. On ne sort pas Spark pour un fichier de 10 Mo — c'est un marteau-pilon.

---

## 2. Le DataFrame Spark : comme pandas, en distribué

Un **DataFrame Spark** est un tableau lignes/colonnes, comme en pandas — mais réparti sur le cluster. On
le manipule avec une API très proche. **PySpark** = l'interface Python de Spark.

pandas :

```python
import pandas as pd
df = pd.read_csv("ventes.csv")
df[df["montant"] > 100]                      # filtrer
df.groupby("ville")["montant"].sum()         # agréger
```

PySpark :

```python
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = SparkSession.builder.getOrCreate()   # point d'entrée Spark
df = spark.read.csv("ventes.csv", header=True, inferSchema=True)
df.filter(df["montant"] > 100)               # filtrer
df.groupBy("ville").sum("montant")           # agréger
```

Tu retrouves tes réflexes : filtrer, grouper, agréger. La syntaxe change un peu (`filter` au lieu des
crochets, `groupBy` avec un B majuscule), mais **la logique est la même**.

---

## 3. L'idée clé n°1 — *lazy evaluation* (évaluation paresseuse)

**En une phrase :** Spark **ne calcule rien tant que tu ne lui demandes pas explicitement un résultat**.
Il note tes opérations dans un **plan**, et n'exécute tout qu'au dernier moment.

On distingue donc deux familles d'opérations :

- **Transformations** (`filter`, `select`, `groupBy`, `withColumn`…) : elles **décrivent** un calcul mais
  **ne l'exécutent pas**. Spark les empile dans son plan (elles sont *lazy*).
- **Actions** (`show`, `count`, `collect`, `write`…) : elles **déclenchent** vraiment l'exécution de tout
  le plan et **renvoient un résultat**.

```python
df2 = df.filter(df["montant"] > 100)   # TRANSFORMATION -> rien ne se calcule encore
df3 = df2.groupBy("ville").sum()       # TRANSFORMATION -> toujours rien
df3.show()                             # ACTION -> MAINTENANT Spark exécute tout d'un coup
```

**Pourquoi c'est malin :** en attendant l'action, Spark voit **toute la chaîne** et peut l'**optimiser**
(ex. ne lire que les colonnes utiles, filtrer au plus tôt). C'est LA grande différence avec pandas, où
**chaque ligne s'exécute immédiatement**.

> Différence à retenir : **pandas = immédiat** (chaque opération calcule tout de suite) ;
> **Spark = paresseux** (rien ne s'exécute avant une **action**).

---

## 4. L'idée clé n°2 — transformations vs actions (le tableau)

| | Transformation | Action |
|---|---|---|
| Fait quoi | **décrit** un calcul, ne l'exécute pas | **déclenche** l'exécution, renvoie un résultat |
| Exécution | *lazy* (différée) | immédiate |
| Exemples | `filter`, `select`, `groupBy`, `withColumn` | `show`, `count`, `collect`, `write` |
| Renvoie | un nouveau DataFrame (plan) | des données / un fichier / un nombre |

Réflexe pour trancher : « est-ce que ça me **rend un résultat concret** (des lignes, un nombre, un
fichier) ? » → **action**. Sinon, ça ne fait que **préparer** → **transformation**.

---

## 5. À retenir

- **Spark** = traiter des données **trop grosses pour une machine**, en les **distribuant** sur un cluster qui calcule en parallèle. **PySpark** = son interface Python.
- **DataFrame Spark** ≈ DataFrame pandas, mais distribué ; API proche (`filter`, `groupBy`, `sum`…).
- **Lazy evaluation** : Spark **n'exécute rien** avant une **action** — il empile les **transformations** dans un plan qu'il optimise.
- **Transformations** (`filter`, `select`, `groupBy`, `withColumn`) = *lazy*, décrivent ; **Actions** (`show`, `count`, `collect`, `write`) = déclenchent + renvoient.
- Choix : **pandas** si ça tient sur une machine (≤ quelques Go) ; **Spark** au-delà. Pas de Spark pour un petit fichier.

---

## 6. Exercice

> **Ce que tu dois en retenir :** reconnaître transformation vs action, comprendre pourquoi Spark est
> paresseux, et savoir dire **quand** on choisit Spark plutôt que pandas. Pur conceptuel, pas de cluster à
> installer. Réponds par écrit dans `exercices/concepts/s7_2_spark.md`.

---

*Fin des nouveaux thèmes de la S7 (Java + Spark). Côté planning : c'est la semaine où tu **lances tes
premières candidatures**. Ensuite, S8 : 2e projet portfolio.*
