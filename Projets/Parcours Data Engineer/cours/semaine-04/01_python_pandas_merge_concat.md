# Semaine 4 · Python — Combiner des DataFrames : `merge` et `concat`

> Session Python, début de la Phase 2 (Approfondissement). Jusqu'ici tu travaillais sur **un** tableau.
> En vrai, les données sont éclatées en plusieurs fichiers/tables qu'il faut **joindre**. `merge` est
> le **JOIN de pandas** (tu connais déjà le concept côté SQL) ; `concat` sert à **empiler** des tableaux.
> C'est un geste quotidien de data engineer, et le pont direct avec ce que tu sais faire en SQL.

---

## 1. Pourquoi ce thème

Un fichier de commandes n'a que des `id_client` ; les noms et villes sont dans un autre fichier. Pour
répondre à « quel CA par ville ? », il faut d'abord **joindre les deux tables** sur la clé commune. C'est
exactement une **jointure** SQL, mais en pandas. Et quand tu reçois les ventes de janvier, février, mars
dans trois fichiers, il faut les **empiler** : c'est `concat`.

---

## 2. `merge` : joindre deux DataFrames sur une clé (une jointure)

`merge` associe les lignes des deux tables qui partagent la même valeur de **clé**.

```python
import pandas as pd

commandes = pd.DataFrame({
    "id_commande": [1, 2, 3],
    "id_client":   [10, 11, 10],
    "montant":     [100, 250, 80],
})
clients = pd.DataFrame({
    "id_client": [10, 11, 12],
    "nom":       ["Alice", "Bob", "Chloé"],
    "ville":     ["Rouen", "Paris", "Lyon"],
})

pd.merge(commandes, clients, on="id_client")   # on = la colonne clé commune
```

Résultat : chaque commande reçoit le `nom` et la `ville` de son client. C'est le `JOIN ... ON ...` que
tu écris en SQL, exprimé en une ligne pandas.

---

## 3. Les quatre `how` (comme les JOINs SQL)

`how` décide **quelles lignes garder** quand une clé n'a pas de correspondance des deux côtés. C'est le
même vocabulaire qu'en SQL :

```
how="inner"  (défaut) → seulement les clés présentes DES DEUX côtés   (INNER JOIN)
how="left"            → toutes les lignes de GAUCHE, complétées si possible (LEFT JOIN)
how="right"           → toutes les lignes de DROITE                    (RIGHT JOIN)
how="outer"           → TOUTES les lignes des deux côtés               (FULL OUTER JOIN)
```

```python
pd.merge(commandes, clients, on="id_client", how="left")
```

Quand une ligne de gauche n'a pas de correspondance à droite, les colonnes de droite sont remplies avec
**NaN** (valeur manquante) — pas d'erreur, juste des trous. À toi de les repérer.

---

## 4. Le piège à connaître : `inner` supprime en silence

Par défaut (`inner`), une commande dont l'`id_client` **n'existe pas** dans la table clients **disparaît**
du résultat — sans avertissement. Exactement comme un `INNER JOIN` qui écarte les lignes sans
correspondance. Résultat : ton total peut être **faux** parce que des lignes ont sauté.

Le réflexe : **compare le nombre de lignes avant / après** le merge.

```python
print(len(commandes))                                   # 3
fusion = pd.merge(commandes, clients, on="id_client")   # inner
print(len(fusion))                                      # si < 3 -> des lignes ont été perdues !
```

Si tu veux **garder toutes** les commandes même sans client connu, utilise `how="left"` : les lignes
restent, avec des NaN côté client (tu peux ensuite les traiter avec `fillna`, comme en S3).

---

## 5. Clés de noms différents : `left_on` / `right_on`

Si la colonne clé ne porte pas le même nom dans les deux tables :

```python
pd.merge(commandes, clients, left_on="id_client", right_on="numero_client")
```

---

## 6. `concat` : empiler des tableaux

`concat` ne fait pas de jointure sur une clé : il **empile** des tableaux bout à bout.

```python
# Empiler des LIGNES (axis=0, par défaut) : ex. janvier + février
ventes_jan = pd.DataFrame({"produit": ["A", "B"], "qte": [10, 5]})
ventes_fev = pd.DataFrame({"produit": ["A", "C"], "qte": [7, 3]})
pd.concat([ventes_jan, ventes_fev], ignore_index=True)   # ignore_index = renumérote proprement
```

```python
# Coller des COLONNES (axis=1) : accoler deux tableaux côte à côte (mêmes lignes)
pd.concat([df_gauche, df_droite], axis=1)
```

Résumé de la distinction : **`merge` = joindre sur une clé** (une jointure, élargit en colonnes) ;
**`concat` = empiler** des tableaux de même structure (allonge en lignes, `axis=0`).

---

## 7. À retenir

- `pd.merge(a, b, on="cle")` = le **JOIN** de pandas ; **joint** deux tables sur une colonne commune.
- **`how`** : `inner` (défaut, intersection), `left`, `right`, `outer` — même logique que les JOINs SQL.
- **Piège `inner`** : les lignes sans correspondance **disparaissent** silencieusement → compare `len()` avant/après ; `how="left"` pour tout garder (trous en NaN).
- Clés de noms différents : `left_on=` / `right_on=`.
- `pd.concat([...])` = **empiler** : `axis=0` (lignes, défaut, + `ignore_index=True`), `axis=1` (colonnes).

---

## 8. Exercice

> **Ce que tu dois en retenir :** reconstituer une information éclatée sur deux fichiers en faisant une
> **jointure**, en choisissant le bon type (`inner` ou `left`), et en vérifiant que la jointure n'a pas
> fait disparaître de lignes. Travaille dans `exercices/python/s4_1_pandas_merge_concat.ipynb` (exemples
> à exécuter en haut, énoncés en dessous). **À toi de choisir tes outils.**
>
> **Trois jeux de données, déjà chargés dans le notebook :**
> - `commandes_web` — les commandes du **mois 1** (une ligne = une commande, avec un `client_id`, un `montant`).
> - `clients_web` — le **catalogue des clients connus** (`client_id`, nom, `segment`, `ville`).
> - `commandes_web_mois2` — les commandes du **mois 2** (même structure que le mois 1). **Ne sert qu'à la question 5.**

1. **Joins** les commandes du **mois 1** (`commandes_web`) avec le catalogue `clients_web`, pour ajouter à chaque commande le **segment** et la **ville** de son client. Combien de lignes obtiens-tu en résultat ?

2. Combien de commandes y a-t-il dans `commandes_web` au départ ? Compare avec le nombre de lignes obtenu à la question 1 : ta jointure a-t-elle **perdu des commandes** ? Explique pourquoi, puis refais la jointure de manière à **garder les 60 commandes du mois 1**, y compris celles dont le `client_id` n'est pas dans `clients_web` (les commandes « invité »).

3. Sur ce tableau complet (mois 1, toutes les commandes gardées), calcule le **chiffre d'affaires par segment** de client. Que fais-tu des commandes « invité » qui se retrouvent sans segment ?

4. Toujours sur ce tableau complet, calcule le **chiffre d'affaires par ville**, classé du plus élevé au plus faible.

5. Cette fois **sans le catalogue clients** : mets bout à bout les commandes du **mois 1** (`commandes_web`) et du **mois 2** (`commandes_web_mois2`) en un seul tableau, puis calcule le **chiffre d'affaires total des deux mois**. (indice : empiler deux tableaux de même structure, ce n'est pas une jointure.)

6. **Réflexion (pas de code).** En une phrase : quelle est la différence entre une jointure `inner` et une jointure `left`, et dans quel cas choisis-tu l'une plutôt que l'autre ?

---

*Quand c'est fait, envoie-moi le notebook. Ensuite, session SQL de la semaine : les **CTE** (`WITH ... AS`),
pour écrire des requêtes complexes de façon lisible.*
