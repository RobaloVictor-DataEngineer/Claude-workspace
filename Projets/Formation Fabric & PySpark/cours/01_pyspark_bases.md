# Module 1 — PySpark : les bases (DataFrame, sélectionner, filtrer, calculer)

**PySpark** = l'interface Python de **Spark**, le moteur qui traite les données **distribuées** (réparties sur plusieurs machines). On manipule des **DataFrame Spark** : comme un tableau pandas, mais distribué et **paresseux** (*lazy* : rien ne se calcule avant une **action** comme `show()`).

Deux objets d'entrée :
- **SparkSession** = la **porte d'entrée** de Spark (on l'appelle `spark`). C'est elle qui crée/lit les DataFrame.
- **DataFrame** = le **tableau** (lignes + colonnes typées).

> On importe presque toujours : `from pyspark.sql import functions as F` (la boîte à outils des fonctions de colonnes : `F.col`, `F.sum`, `F.when`…).

Dans toute la fiche, on travaille sur ce petit jeu de données **`employes`** :

```
 id | nom   | service | salaire | anciennete
  1 | Alice | IT      | 3200.0  | 6
  2 | Bob   | IT      | 2500.0  | 2
  3 | Chloe | RH      | 2800.0  | 9
  4 | David | Ventes  | 2100.0  | 1
  5 | Emma  | Ventes  | 3000.0  | 5
```

---

## Exemple 1 — Ouvrir Spark et créer un DataFrame

```python
from pyspark.sql import SparkSession, functions as F

spark = SparkSession.builder.getOrCreate()   # la "porte d'entrée" Spark

# créer un DataFrame à la main : liste de lignes + liste de noms de colonnes
employes = spark.createDataFrame(
    [(1,"Alice","IT",3200.0,6), (2,"Bob","IT",2500.0,2), (3,"Chloe","RH",2800.0,9),
     (4,"David","Ventes",2100.0,1), (5,"Emma","Ventes",3000.0,5)],
    ["id","nom","service","salaire","anciennete"],
)
```

En vrai (dans Fabric), on lit plutôt un fichier : `spark.read.csv("chemin.csv", header=True, inferSchema=True)` — **`read.csv`** avec un **point** (piège classique : ce n'est pas `read_csv`).

## Exemple 2 — Inspecter (les 4 réflexes)

```python
employes.show()          # affiche les lignes (c'est une ACTION)
employes.printSchema()   # les colonnes et leurs TYPES
employes.count()         # nombre de lignes -> 5
employes.columns         # liste des noms de colonnes
```

`printSchema()` donne :
```
root
 |-- id: long
 |-- nom: string
 |-- salaire: double
 ...
```

## Exemple 3 — Sélectionner des colonnes (`select`) + renommer (`alias`)

```python
# ne garder que certaines colonnes, et renommer "salaire" en "paie"
employes.select("nom", F.col("salaire").alias("paie")).show()
```
`F.col("salaire")` = « la colonne salaire ». `.alias("paie")` = la renommer dans le résultat.

## Exemple 4 — Filtrer des lignes (`filter` / `where`)

```python
# les employés du service IT qui gagnent plus de 2600
employes.filter((F.col("service")=="IT") & (F.col("salaire")>2600)).show()
# -> Alice
```
Règles à retenir : chaque condition **entre parenthèses**, `&` = ET, `|` = OU (pas `and`/`or`). `filter` et `where` font la même chose.

## Exemple 5 — Créer une colonne (`withColumn`) + colonne conditionnelle (`F.when`)

```python
# colonne calculée : salaire annuel = salaire * 12
employes.withColumn("salaire_annuel", F.col("salaire")*12).show()

# colonne conditionnelle : "senior" si ancienneté >= 5, sinon "junior"
employes.withColumn(
    "niveau", F.when(F.col("anciennete")>=5, "senior").otherwise("junior")
).show()
```
`withColumn("nom_colonne", expression)` ajoute (ou remplace) une colonne. `F.when(condition, valeur_si_vrai).otherwise(valeur_si_faux)` = le « si… sinon… » de Spark.

## Exemple 6 — Tout chaîner + trier (`orderBy`) + l'action

```python
# lire "comme une phrase" : prends les employés payés > 2600,
# garde nom + salaire, trie du plus payé au moins payé, puis AFFICHE.
(employes
    .filter(F.col("salaire") > 2600)
    .select("nom", "salaire")
    .orderBy(F.col("salaire").desc())      # .desc() = décroissant
    .show())
# -> Alice 3200, Emma 3000, Chloe 2800
```
**Lazy :** `filter`, `select`, `orderBy` ne calculent **rien** tout seuls (ce sont des **transformations**, empilées dans un plan) ; c'est `show()` (**action**) qui déclenche le calcul. Sur plusieurs lignes, **tout entre `( … )`**.

---

## À retenir
- `spark` = la SparkSession (porte d'entrée) ; on crée un DataFrame avec `createDataFrame(...)` ou on lit avec `spark.read.csv(...)`.
- Inspecter : `show()`, `printSchema()`, `count()`, `columns`.
- `select("a", F.col("b").alias("c"))` — choisir/renommer des colonnes.
- `filter((cond1) & (cond2))` — filtrer des lignes (`&`/`|`, parenthèses obligatoires).
- `withColumn("nouvelle", expression)` — créer une colonne ; `F.when(...).otherwise(...)` pour une colonne conditionnelle.
- `orderBy(F.col("x").desc())` — trier.
- **Transformations** (lazy) vs **action** (`show`, `count`) : rien ne se calcule avant l'action.

*Exercices associés : `exercices/pyspark/bac_a_sable_pyspark.ipynb` (dataset **livres**, problèmes neufs).*
