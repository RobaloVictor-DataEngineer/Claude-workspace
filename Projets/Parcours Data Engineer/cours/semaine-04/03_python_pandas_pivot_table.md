# Semaine 4 · Python — Les tableaux croisés : `pivot_table`

> Session Python. Tu connais déjà les **tableaux croisés dynamiques** d'Excel / Power BI (ton monde du
> BI). `pivot_table` en pandas, c'est exactement ça : prendre une colonne pour les **lignes**, une autre
> pour les **colonnes**, et remplir la grille avec un **calcul** (somme, moyenne…). C'est un `groupby`
> présenté en **grille 2D** — parfait pour comparer deux dimensions d'un coup.

---

## 1. Pourquoi ce thème

Un `groupby(["region", "categorie"])` te donne le résultat en **liste** (une ligne par combinaison).
Pour *comparer* — « quelle région vend le plus de quelle catégorie ? » — une **grille** régions ×
catégories est bien plus lisible. `pivot_table` produit cette grille. C'est le même calcul qu'un
`groupby`, juste **remis en forme** pour l'œil (et pour un rapport).

---

## 2. La structure de `pivot_table`

Quatre paramètres à connaître :

```python
df.pivot_table(
    index="region",       # ce qui va en LIGNES
    columns="categorie",  # ce qui va en COLONNES
    values="montant",     # la colonne de valeurs à calculer
    aggfunc="sum",        # le calcul dans chaque case (sum, mean, count...)
)
```

Lecture du résultat : une **grille** où chaque case = « pour cette région (ligne) et cette catégorie
(colonne), la somme des montants ».

```
categorie      Bureautique  Informatique  Mobilier
region
Nord                  120           850       300
Sud                    90           610       450
```

---

## 3. C'est un `groupby` remis en grille

Ces deux écritures calculent la **même chose** ; `pivot_table` ne fait que déplier le résultat en 2D :

```python
df.groupby(["region", "categorie"])["montant"].sum()        # résultat en liste (index à 2 niveaux)
df.pivot_table(index="region", columns="categorie",
               values="montant", aggfunc="sum")             # même chose, en grille
```

Retiens : **`groupby` = liste**, **`pivot_table` = grille**. Pour l'analyse et les rapports, la grille
est souvent plus parlante ; pour enchaîner d'autres calculs, la liste est souvent plus pratique.

---

## 4. Les cases vides deviennent NaN — le piège

Si une combinaison n'existe pas dans les données (aucune vente de Mobilier au Nord), la case
correspondante est **NaN** (valeur manquante). Ça peut fausser une lecture ou un calcul ensuite. On la
remplit avec `fill_value` :

```python
df.pivot_table(index="region", columns="categorie", values="montant",
               aggfunc="sum", fill_value=0)   # les cases sans données -> 0 au lieu de NaN
```

Ici `fill_value=0` est justifié : « pas de vente » = un montant de **0**. (À l'inverse, souviens-toi
qu'on ne met pas 0 quand la valeur est *inconnue* mais existe — comme un budget manquant en S3.)

---

## 5. Les totaux : `margins`

`margins=True` ajoute une ligne et une colonne de **totaux** (le « Total général » des tableaux croisés
Excel) :

```python
df.pivot_table(index="region", columns="categorie", values="montant",
               aggfunc="sum", fill_value=0, margins=True, margins_name="Total")
```

---

## 6. Changer le calcul

`aggfunc` accepte les mêmes fonctions que `groupby` (`"sum"`, `"mean"`, `"count"`, `"max"`…), et même
une **liste** pour plusieurs calculs d'un coup :

```python
df.pivot_table(index="region", columns="categorie", values="montant", aggfunc="mean")   # moyenne par case
df.pivot_table(index="region", values="montant", aggfunc=["sum", "count"])              # 2 calculs
```

---

## 7. À retenir

- `pivot_table` = **tableau croisé** : `index` (lignes) × `columns` (colonnes), rempli par `aggfunc` sur `values`.
- C'est un **`groupby` remis en grille 2D** — même calcul, présentation plus lisible pour comparer deux dimensions.
- Cases sans données = **NaN** → `fill_value=0` quand « absence = 0 » (mais pas quand la valeur est inconnue).
- `margins=True` ajoute les **totaux** ligne/colonne.
- `aggfunc` : `"sum"`, `"mean"`, `"count"`… ou une liste pour plusieurs calculs.

---

## 8. Exercice

> **Ce que tu dois en retenir :** présenter un croisement de deux dimensions sous forme de **grille**
> lisible, choisir le bon calcul, et gérer proprement les cases vides. C'est le geste « tableau de bord »
> que tu faisais en BI, mais en pandas. Travaille dans `exercices/python/s4_3_pandas_pivot_table.ipynb`
> (exemples à exécuter en haut, énoncés en dessous). Données : `exercices/python/data/ventes_magasins.csv`
> (des ventes avec `region`, `categorie`, `trimestre`, `montant`). **À toi de choisir tes outils.**

1. Construis une grille avec les **régions en lignes** et les **catégories en colonnes**, chaque case contenant le **chiffre d'affaires total = la somme des `montant`**. Une case ressort vide : repère-la, explique pourquoi elle est vide, et remplis-la avec une valeur qui a du sens ici (justifie ton choix).

2. Sur cette même grille, ajoute les **totaux** (une ligne « total » par région, une colonne « total » par catégorie). En lisant ces totaux : quelle **région** a la plus grande somme de CA ? Quelle **catégorie** ?

3. Refais la même grille régions × catégories, mais chaque case contenant cette fois la **moyenne des `montant`** (le montant moyen d'une vente, pas la somme). Qu'est-ce qui change par rapport à la question 1, et qu'est-ce que ça t'apprend en plus ?

4. Construis une grille avec les **régions en lignes** et les **trimestres en colonnes**, chaque case contenant la **somme des `montant`**. Un trimestre a-t-il une somme nettement plus élevée que les autres (saisonnalité) ?

5. **Réflexion (pas de code).** En une phrase : quelle est la différence entre `groupby` et `pivot_table`, et quand préfères-tu l'un plutôt que l'autre ?

---

*Quand c'est fait, envoie-moi le notebook. Il restera, pour compléter la S4 : `apply`/`lambda` et un flux
**API → pandas** (`requests`), puis le **mini-projet cumulatif S1 → S4**.*
