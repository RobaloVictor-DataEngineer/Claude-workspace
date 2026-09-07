# Semaine 2 · Python — Pandas, les fondamentaux

> Session Python. Jusqu'ici tu lisais un CSV (CSV = Comma-Separated Values, un fichier texte où
> les colonnes sont séparées par des virgules) avec le module `csv`, ligne par ligne, en
> dictionnaires. **pandas** fait le même travail en une ligne, et te donne en plus un objet
> taillé pour filtrer, trier et calculer sur des milliers de lignes d'un coup. C'est l'outil
> central de ton futur métier : la partie **T** (Transform) de tout pipeline ETL passe par lui.

---

## 1. Pourquoi ce thème pour un data engineer

**pandas** (le nom vient de *panel data*) est la bibliothèque Python de manipulation de données
tabulaires. Dans un pipeline **ETL** (Extract, Transform, Load = Extraire, Transformer, Charger),
c'est l'outil du **T** : tu charges des données brutes, tu les nettoies, tu les croises, tu
calcules de nouvelles colonnes, puis tu renvoies un tableau propre vers une base ou un fichier.

Concrètement, ce que tu faisais à la main avec des boucles `for` et des `dict`, pandas le fait
en une expression, plus vite et plus lisiblement. C'est aussi ce qu'on te demandera de montrer
en entretien dès qu'on parle de traitement de données.

---

## 2. Installation et import

```python
# Dans le terminal, une seule fois :   pip install pandas
import pandas as pd        # convention universelle : on importe pandas sous l'alias "pd"
```

`pd` est l'alias standard. Tout le monde l'écrit comme ça — autant prendre l'habitude.

---

## 3. Les deux objets de base : Series et DataFrame

pandas repose sur deux structures. La **Series** est une colonne unique (un tableau 1D avec un
index). Le **DataFrame** est un tableau entier (plusieurs colonnes = plusieurs Series qui
partagent le même index de lignes). Visuellement :

```
         Series (1 colonne)                 DataFrame (un tableau)
        index │ valeur                  index │ nom      │ salaire
        ──────┼───────                  ──────┼──────────┼────────
          0   │ 38000                     0   │ Alice    │ 38000
          1   │ 41000                     1   │ Bob      │ 41000
          2   │ 45000                     2   │ Chloé    │ 45000
```

L'**index** est l'étiquette de chaque ligne (par défaut 0, 1, 2…). C'est important : pandas
travaille par étiquettes, pas seulement par position.

```python
# Une Series à partir d'une liste
salaires = pd.Series([38000, 41000, 45000])
# 0    38000
# 1    41000
# 2    45000

# Un DataFrame à partir d'un dictionnaire : chaque clé = un nom de colonne
df = pd.DataFrame({
    "nom": ["Alice", "Bob", "Chloé"],
    "salaire": [38000, 41000, 45000],
    "service": ["Data", "Data", "RH"],
})
```

---

## 4. Lire un CSV : `read_csv`

```python
df = pd.read_csv("employes.csv")   # lit tout le fichier d'un coup dans un DataFrame
```

Une ligne remplace toute ta lecture manuelle avec `DictReader`. pandas devine les colonnes
(la première ligne du CSV) et les types (nombre, texte) tout seul.

---

## 5. Regarder ses données avant tout

Premier réflexe d'un data engineer : ne jamais traiter à l'aveugle, on **inspecte** d'abord.

```python
df.head()        # les 5 premières lignes (df.head(3) pour 3)
df.tail()        # les 5 dernières
df.shape         # (nb_lignes, nb_colonnes) -> ex. (3, 3)
df.columns       # la liste des noms de colonnes
df.dtypes        # le type de chaque colonne (int64, object pour du texte...)
df.info()        # résumé : colonnes, types, valeurs non-nulles
df.describe()    # stats sur les colonnes numériques (moyenne, min, max, quartiles)
```

`info()` et `describe()` répondent en deux lignes à « combien de lignes, quels types, y a-t-il
des trous, quel ordre de grandeur ». À faire systématiquement à l'ouverture d'un dataset.

---

## 6. Sélectionner des colonnes

```python
df["salaire"]              # une colonne -> renvoie une Series
df[["nom", "salaire"]]     # plusieurs colonnes -> liste de noms, renvoie un DataFrame
```

Retiens la nuance : **un crochet** pour une colonne (Series), **double crochet** pour plusieurs
(DataFrame). Le double crochet, c'est juste « je te passe une liste de noms ».

---

## 7. Sélectionner des lignes : `loc` vs `iloc`

C'est LE point qui pose problème au début, donc on le pose clairement :

- **`loc`** = sélection par **étiquette** (le nom de l'index, le nom de la colonne).
- **`iloc`** = sélection par **position** (le numéro, comme on indexe une liste). Le `i` = *integer*.

```python
df.loc[0]                    # la ligne dont l'étiquette d'index est 0
df.loc[0, "nom"]             # croisement ligne-étiquette 0 / colonne "nom" -> "Alice"
df.loc[0:2, ["nom","salaire"]]  # lignes d'étiquette 0 à 2 INCLUSE, colonnes nommées

df.iloc[0]                   # la 1re ligne (position 0)
df.iloc[0, 1]                # 1re ligne, 2e colonne (positions) -> 38000
df.iloc[0:2]                 # les 2 premières lignes (position 0 et 1, 2 EXCLUE)
```

Piège à mémoriser : avec `loc` la borne de fin est **incluse** (`0:2` = 0,1,2) ; avec `iloc`
elle est **exclue** (`0:2` = 0,1), exactement comme le slicing d'une liste Python classique.

---

## 8. Filtrage booléen (le plus utilisé)

L'idée : on écrit une condition, pandas la teste sur chaque ligne et renvoie un masque de
`True`/`False`, puis on ne garde que les `True`.

```python
df["salaire"] > 40000        # Series de True/False, une par ligne
df[df["salaire"] > 40000]    # on garde uniquement les lignes où c'est True
```

Plusieurs conditions : chaque condition entre **parenthèses**, et on combine avec `&` (et) ou
`|` (ou). Attention, ce ne sont pas `and`/`or` ici.

```python
df[(df["salaire"] > 40000) & (df["service"] == "Data")]   # salaire > 40000 ET service Data
```

---

## 9. Trier : `sort_values`

```python
df.sort_values("salaire")                      # tri croissant (par défaut)
df.sort_values("salaire", ascending=False)     # décroissant
df.sort_values(["service", "salaire"])         # par service, puis par salaire
```

`sort_values` ne modifie pas `df` : il **renvoie** une copie triée. Pour garder le résultat,
réassigne (`df = df.sort_values(...)`) ou passe `inplace=True`.

---

## 10. Créer une colonne calculée

On affecte une nouvelle colonne ; l'opération s'applique à **toute la colonne d'un coup**
(pas besoin de boucle) — c'est la grande force de pandas.

```python
df["salaire_annuel"] = df["salaire"] * 12      # nouvelle colonne à partir d'une autre
df["augmente"] = df["salaire"] * 1.05          # +5 % sur toute la colonne
```

---

## 11. À retenir

- **Series** = une colonne (1D) ; **DataFrame** = un tableau (2D). Les deux ont un **index**.
- `pd.read_csv("fichier.csv")` lit tout le fichier en une ligne.
- Toujours **inspecter** d'abord : `head()`, `info()`, `describe()`, `shape`.
- Colonnes : `df["col"]` (Series) vs `df[["a","b"]]` (DataFrame).
- **`loc` = par étiquette** (fin incluse) ; **`iloc` = par position** (fin exclue).
- Filtre booléen : `df[df["col"] > x]` ; conditions multiples entre `()` avec `&` / `|`.
- `sort_values(...)` renvoie une copie triée (réassigne-la).
- Colonne calculée = opération sur la colonne entière, sans boucle.

---

## 12. Exercices

> **Ce qu'ils entraînent :** ouvrir un dataset inconnu et te repérer dedans avec pandas — le
> charger, l'inspecter, sélectionner par étiquette et par position, filtrer, trier, et créer une
> colonne calculée. C'est exactement la séquence de gestes que tu répéteras sur n'importe quel
> jeu de données en poste. Travaille dans le notebook `exercices/python/s2_1_pandas_fondamentaux.ipynb`
> (les cellules d'exemple sont déjà dedans, à exécuter pour voir pandas tourner ; les énoncés
> sont en dessous). Le dataset est `exercices/python/data/villes.csv` (villes françaises :
> population, superficie en km², région).

1. Importe pandas, charge `data/villes.csv` dans un DataFrame `villes`, et affiche les **3 premières lignes**.

2. Inspecte le dataset : affiche sa **forme** (`shape`), ses **types** de colonnes, et le résumé statistique (`describe`). En une phrase de commentaire : combien de villes, et quelles colonnes sont numériques ?

3. Affiche **uniquement** les colonnes `ville` et `population`.

4. Avec `iloc`, affiche la **2e ligne** du tableau. Puis, avec `loc`, affiche la valeur de la colonne `ville` pour la ligne d'index `0`.

5. **Filtre** : garde uniquement les villes de **plus de 200 000 habitants**.

6. **Filtre multiple** : les villes de la région `"Normandie"` **et** de plus de 100 000 habitants. (Indice : chaque condition entre parenthèses, combinées avec `&`.)

7. **Tri** : affiche les villes triées par population **décroissante**. Quelle est la plus peuplée ?

8. **Colonne calculée** : crée une colonne `densite` = population / superficie (habitants par km²). Puis affiche les villes triées par densité décroissante.

9. **Réflexion (pas de code).** En une phrase : quelle est la différence entre `loc` et `iloc` ?

---

*Quand c'est fait, envoie-moi le notebook. Ensuite, session SQL de la semaine : sous-requêtes,
alias et JOINs multiples sur ta base boutique.*
