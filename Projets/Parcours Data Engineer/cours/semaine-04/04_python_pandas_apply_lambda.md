# Semaine 4 · Python — `apply` et `lambda`

> Session Python. Parfois, aucune méthode pandas toute faite ne fait exactement ce que tu veux (classer
> un montant en tranches selon ta propre règle, combiner deux colonnes avec une logique « maison »).
> `apply` te permet d'appliquer **ta propre fonction** à chaque valeur d'une colonne (ou à chaque ligne).
> Et `lambda` sert à écrire une petite fonction **en une ligne**, sur place. Duo très courant en pandas.

---

## 1. Pourquoi ce thème

Tu sais déjà transformer une colonne quand l'opération est simple (`df["prix"] * 1.2`). Mais dès que la
règle a des **conditions** (« si le montant > 200 alors 'gros', sinon 'petit' ») ou qu'elle **croise
plusieurs colonnes**, il te faut une fonction. `apply` applique cette fonction à toute la colonne d'un
coup ; `lambda` évite d'écrire un `def` complet pour les cas courts.

---

## 2. `lambda` : une fonction en une ligne

Une **lambda** est une fonction **anonyme** (sans nom) qu'on écrit sur place :

```python
# fonction classique
def double(x):
    return x * 2

# la même en lambda
double = lambda x: x * 2       # lambda <paramètre> : <valeur renvoyée>
```

`lambda x: x * 2` se lit « une fonction qui prend `x` et renvoie `x * 2` ». Il n'y a pas de `return` : ce
qui suit les `:` est directement la valeur renvoyée.

---

## 3. `apply` sur une colonne (Series)

`apply` exécute la fonction **sur chaque valeur** de la colonne et renvoie une nouvelle colonne.

```python
df["prix_ttc"] = df["prix"].apply(lambda p: round(p * 1.2, 2))   # applique à chaque prix
```

Le plus utile : **catégoriser** avec une règle conditionnelle.

```python
def tranche(prix):
    if prix > 200:
        return "cher"
    elif prix > 50:
        return "moyen"
    else:
        return "abordable"

df["gamme"] = df["prix"].apply(tranche)   # une fonction nommée quand la logique a plusieurs cas
```

Retiens : **lambda** pour une transformation courte sur une ligne ; **`def` + `apply`** dès que la règle
a plusieurs conditions (plus lisible qu'une lambda à rallonge).

---

## 4. `apply` sur les lignes : `axis=1` (croiser plusieurs colonnes)

**En une phrase :** tu mets `axis=1` dès que ton calcul a besoin de **plusieurs colonnes de la même
ligne** en même temps. `axis` ne règle qu'une chose : est-ce que ta fonction reçoit une **colonne** ou
une **ligne** ?

```
Ta table :
   nom     service  salaire
   Alice   Data      40000

apply(f)          →  f reçoit une COLONNE à la fois : d'abord ["Alice"], puis ["Data"], puis [40000]
   (axis=0, défaut)   → impossible de croiser service ET salaire (ils arrivent séparément)

apply(f, axis=1)  →  f reçoit une LIGNE entière : {nom:"Alice", service:"Data", salaire:40000}
                     → tu peux lire ligne["service"] ET ligne["salaire"] ensemble ✅
```

Donc pour une règle qui **dépend de deux colonnes** (le service *et* l'ancienneté), c'est `axis=1` :

```python
def prime(ligne):                                   # 'ligne' = une ligne entière
    if ligne["service"] == "Data" and ligne["anciennete"] >= 3:
        return ligne["salaire"] * 0.10
    return ligne["salaire"] * 0.05

df["prime"] = df.apply(prime, axis=1)               # axis=1 = "traite chaque LIGNE"
```

**Avant / après** — ce que la colonne `prime` ajoute :

AVANT (`df["prime"] = df.apply(prime)`) :

```
nom    service  salaire  anciennete
Alice  Data     40000    5
Bob    RH       30000    8VV
```

APRÈS  (`df["prime"] = df.apply(prime, axis=1)`) :

```
nom    service  salaire  anciennete   prime
Alice  Data     40000    5            4000.0     <- Data ET anciennete >= 3  -> 10 %
Bob    RH       30000    8            1500.0     <- sinon                    ->  5 %
```

Retiens l'image : **sans `axis=1`**, ta fonction voit les colonnes une par une (elle ne peut pas les
croiser) ; **avec `axis=1`**, elle voit chaque ligne en entier (elle peut combiner les colonnes).

---

## 5. Le piège à connaître : `apply` est lent, préfère le vectorisé

`apply` exécute ta fonction Python **ligne par ligne** : sur des milliers/millions de lignes, c'est
**beaucoup plus lent** qu'une opération **vectorisée** (appliquée à toute la colonne d'un bloc par
pandas). Quand une version vectorisée existe, choisis-la.

```python
# ❌ inutilement lent : apply pour une simple multiplication
df["ttc"] = df["prix"].apply(lambda p: p * 1.2)

# ✅ vectorisé : pandas fait l'opération sur toute la colonne d'un coup
df["ttc"] = df["prix"] * 1.2
```

Règle : **`apply` seulement quand il n'y a pas d'équivalent vectorisé** (logique conditionnelle
complexe, croisement de colonnes). Pour un calcul arithmétique simple, reste en vectorisé.

---

## 6. À retenir

- **`lambda x: ...`** = petite fonction anonyme en une ligne (pas de `return`, la valeur suit les `:`).
- **`col.apply(fonction)`** applique ta fonction à **chaque valeur** d'une colonne (idéal pour catégoriser).
- **`def` + `apply`** dès que la règle a plusieurs conditions ; **`lambda`** pour les cas courts.
- **`df.apply(fonction, axis=1)`** = traiter **chaque ligne** (croiser plusieurs colonnes).
- **`apply` est lent** : quand une opération **vectorisée** existe (`df["a"] * df["b"]`), préfère-la.

---

## 7. Exercice

> **Ce que tu dois en retenir :** appliquer ta propre logique à une colonne (`apply`), croiser plusieurs
> colonnes ligne par ligne (`axis=1`), et surtout **savoir quand `apply` est inutile** (préférer le
> vectorisé). C'est ce qui sépare un code pandas lent d'un code propre. Travaille dans
> `exercices/python/s4_4_pandas_apply_lambda.ipynb` (exemples à exécuter en haut, énoncés en dessous).
> Données : `exercices/python/data/employes.csv` (`nom`, `service`, `salaire`, `anciennete` en années).
> **À toi de choisir tes outils.**

1. Crée une colonne `tranche_salaire` qui vaut `"bas"` si le salaire est inférieur à 35 000, `"moyen"` entre 35 000 et 45 000 (inclus), et `"élevé"` au-dessus. (Il te faut une règle à plusieurs conditions.)

2. Crée une colonne `salaire_annuel_charge` = salaire × 1,42 (charges patronales). **Attention :** ici, quelle est la façon la plus efficace de faire — et pourquoi ? Justifie ton choix en commentaire.

3. Crée une colonne `prime` calculée **ligne par ligne** selon cette règle métier : les employés du service `"Data"` avec au moins **5 ans** d'ancienneté touchent **12 %** de leur salaire ; tous les autres, **6 %**. (Tu dois croiser deux colonnes.)

4. Combien d'employés touchent la prime à 12 % ? (à toi de le déduire du résultat de la question 3)

5. **Réflexion (pas de code).** En une phrase : dans quel cas utilises-tu `apply`, et dans quel cas vaut-il mieux **ne pas** l'utiliser ?

---

*Quand c'est fait, envoie-moi le notebook. Il restera un dernier thème pour compléter la S4 : lire des
données depuis une **API** (`requests`) et les transformer en pandas. Puis le **mini-projet cumulatif S1 → S4**.*
