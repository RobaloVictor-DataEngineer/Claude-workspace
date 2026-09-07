# Semaine 2 · Python — Pandas, sélection & filtrage avancés

> Session Python (suite). Tu maîtrises charger, inspecter, `loc`/`iloc`, filtrer, trier, colonne
> calculée. On ajoute maintenant les outils qui rendent ton code **plus court et plus lisible** :
> compter des valeurs, filtrer sur une liste ou un intervalle, sortir un top N, manipuler du texte,
> et enchaîner les opérations proprement. Ce sont les gestes d'une vraie première exploration de
> données — la partie qu'on te demandera de montrer sur un dataset en entretien.

---

## 1. Pourquoi ce thème

Filtrer une valeur à la fois et trier « à la main » marche, mais devient vite verbeux. pandas
fournit des raccourcis pensés pour l'analyse : `value_counts` pour profiler une colonne, `isin`
et `between` pour des filtres expressifs, `nlargest` pour un top N, l'accesseur `.str` pour le
texte. Moins de code = moins de bugs, et c'est ce vocabulaire-là qui distingue quelqu'un qui
« connaît pandas » de quelqu'un qui le bricole.

> Fil rouge des exemples : une petite table de salariés (`nom`, `salaire`, `service`).
> Les exercices portent sur un **autre** dataset (des commandes e-commerce).

---

## 2. `value_counts()` — compter les occurrences

Sur une colonne, `value_counts()` compte combien de fois chaque valeur apparaît, triées de la
plus fréquente à la moins fréquente. C'est le premier réflexe pour « profiler » une colonne
catégorielle (= une colonne de catégories/étiquettes, pas de nombres).

```python
df["service"].value_counts()
# Data    2
# RH      1
# Name: service, dtype: int64

df["service"].value_counts(normalize=True)   # en proportion (0.66 / 0.33) au lieu du compte brut
```

---

## 3. `isin([...])` — filtrer sur plusieurs valeurs

Plutôt que d'enchaîner des `|` (ou) pour tester plusieurs valeurs, `isin` prend une **liste** et
renvoie `True` si la valeur y figure.

```python
# Au lieu de :  df[(df["service"] == "Data") | (df["service"] == "RH")]
df[df["service"].isin(["Data", "RH"])]        # plus court, plus lisible
```

---

## 4. `between(a, b)` — filtrer sur un intervalle

`between` teste si une valeur est dans l'intervalle `[a, b]` (**bornes incluses** par défaut).

```python
# Au lieu de :  df[(df["salaire"] >= 39000) & (df["salaire"] <= 42000)]
df[df["salaire"].between(39000, 42000)]       # salaires entre 39000 et 42000 inclus
```

---

## 5. `nlargest` / `nsmallest` — un top N direct

Pour « les N plus grandes valeurs », `nlargest(n, "colonne")` fait en une fois le tri décroissant
**et** le `head(n)`. Plus clair que `sort_values(...).head(n)`.

```python
df.nlargest(2, "salaire")     # les 2 salaires les plus élevés
df.nsmallest(2, "salaire")    # les 2 plus bas
```

---

## 6. L'accesseur `.str` — manipuler du texte

Sur une colonne de texte, `.str` donne accès aux méthodes de chaîne **vectorisées** (= appliquées
à toute la colonne d'un coup, sans boucle). Les plus utiles :

```python
df["nom"].str.upper()                 # tout en majuscules
df["nom"].str.contains("li")          # True si "li" est dans le nom (Alice, Chloé... -> selon casse)
df["nom"].str.startswith("A")         # commence par "A"
df["nom"].str.len()                   # longueur de chaque chaîne
```

Combiné à un filtre booléen, `.str.contains` sert à chercher un motif :

```python
df[df["nom"].str.contains("o")]       # toutes les lignes dont le nom contient un "o"
```

Astuce : `df["col"].str.contains("texte", case=False)` ignore la casse (majuscules/minuscules).

---

## 7. Enchaîner les opérations proprement

En vrai, on combine : filtrer → trier → ne garder que quelques colonnes. On peut tout écrire à la
suite ; pour rester lisible, on coupe avec des `\` ou on met le tout entre parenthèses.

```python
# « Les salariés du service Data, triés par salaire décroissant, colonnes nom + salaire »
(
    df[df["service"] == "Data"]          # 1) filtre
      .sort_values("salaire", ascending=False)   # 2) tri
      [["nom", "salaire"]]               # 3) sélection de colonnes
)
```

L'ordre compte : chaque étape s'applique au résultat de la précédente. C'est exactement la logique
d'une requête SQL (`WHERE` puis `ORDER BY` puis `SELECT`), mais en pandas.

---

## 8. À retenir

- `value_counts()` profile une colonne catégorielle (compte par valeur, `normalize=True` pour des %).
- `isin([...])` filtre sur **une liste** de valeurs ; `between(a, b)` sur un **intervalle** (bornes incluses).
- `nlargest(n, "col")` / `nsmallest` = top N direct (tri + head en un appel).
- `.str.contains / .upper / .startswith / .len` = méthodes texte appliquées à toute la colonne.
- On **enchaîne** filtre → tri → sélection ; chaque étape agit sur le résultat de la précédente.

---

## 9. Exercices

> **Ce qu'ils entraînent :** faire une vraie première exploration d'un dataset « métier » avec un
> vocabulaire pandas plus riche — profiler les colonnes (`value_counts`), filtrer de façon
> expressive (`isin`, `between`, `.str`), sortir un top N (`nlargest`) et enchaîner les opérations.
> C'est le genre de manipulation que tu feras dès qu'on te confie un fichier en poste. Travaille
> dans `exercices/python/s2_2_pandas_intermediaire.ipynb` (exemples déjà dedans, à exécuter ;
> énoncés en dessous). Dataset : `exercices/python/data/commandes.csv` (commandes e-commerce :
> date, client, catégorie, produit, quantité, prix unitaire, ville).

1. Charge `data/commandes.csv` dans `cmd`, affiche `head()` et `info()`. Combien de commandes, quelles colonnes, des valeurs manquantes ?

2. Avec `value_counts`, affiche le **nombre de commandes par catégorie**, puis par **ville**. Quelle catégorie revient le plus ?

3. Crée une colonne calculée `montant` = `quantite` × `prix_unitaire`.

4. Avec `nlargest`, affiche les **5 commandes au plus gros montant** (colonnes `client`, `produit`, `montant`).

5. Avec `isin`, garde uniquement les commandes des catégories `"Informatique"` et `"Mobilier"`.

6. Avec `between`, garde les commandes dont le `prix_unitaire` est **entre 50 et 200 inclus**.

7. Avec `.str`, affiche les commandes dont le `produit` **contient** `"Clavier"` (peu importe la casse). Bonus : affiche la colonne `client` en majuscules.

8. **Enchaînement** : les commandes de la catégorie `"Informatique"` dont le `montant` dépasse 300, triées par `montant` décroissant, en n'affichant que `client`, `produit`, `montant`.

9. **Réflexion (pas de code).** En une phrase chacune : à quoi sert `value_counts`, et pourquoi `isin([...])` est préférable à plusieurs `|` ?

---

*Quand c'est fait, envoie-moi le notebook. Ensuite on bascule sur la session SQL de la semaine :
sous-requêtes, alias et JOINs multiples.*
