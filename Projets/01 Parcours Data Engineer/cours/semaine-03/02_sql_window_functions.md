# Semaine 3 · SQL — Les window functions (fonctions de fenêtrage)

> Session SQL. Ce matin tu as vu `groupby` en pandas : il **réduit** plusieurs lignes à une seule
> par groupe. Les **window functions** font le calcul d'agrégat *mais gardent toutes les lignes* —
> chaque ligne reçoit en plus la valeur calculée sur son groupe. C'est un des sujets les plus
> demandés en entretien data engineer, et souvent le point qui départage les candidats.

> Base utilisée : ta base **boutique** (`cours/semaine-01/setup_boutique.sql`).
> Tables clés ici : `produits` (nom, categorie, prix) et `commandes` (date_commande).

---

## 1. Pourquoi ce thème

Question typique : « pour chaque produit, montre son prix **et** le prix moyen de sa catégorie, sur
la même ligne ». Avec `GROUP BY`, impossible : il écrase le détail (tu perds le produit). Les window
functions calculent l'agrégat **sans effacer les lignes** — exactement ce qu'on demande pour classer,
comparer à une moyenne, ou faire un total cumulé. Indispensable en entretien et en poste.

---

## 2. `GROUP BY` vs window : l'idée clé

```
GROUP BY categorie (RÉDUIT)              AVG(prix) OVER (PARTITION BY categorie) (GARDE TOUT)

 categorie    │ prix_moyen               nom          categorie   │ prix   │ prix_moy_cat
 ─────────────┼───────────               ─────────────────────────┼────────┼──────────────
 Informatique │ 112.93                   Clavier      Informatique │  89.90 │ 112.93
 Papeterie    │   6.20                   Souris       Informatique │  29.90 │ 112.93
                                         Écran        Informatique │ 219.00 │ 112.93
   (2 lignes)                            Cahier       Papeterie    │   4.50 │   6.20
                                         Stylo        Papeterie    │   7.90 │   6.20
                                                       (toutes les lignes conservées)
```

À gauche on perd les produits ; à droite chaque produit garde sa ligne **et** reçoit la moyenne de sa
catégorie à côté. C'est toute la différence.

---

## 3. La structure d'une window function

```sql
fonction() OVER ( PARTITION BY colonne   -- découpe en "fenêtres" (= groupes). Facultatif.
                  ORDER BY colonne )      -- ordre à l'intérieur de la fenêtre. Selon la fonction.
```

- **`OVER (...)`** = « applique cette fonction sur une fenêtre de lignes » (c'est ce qui en fait une window function).
- **`PARTITION BY`** = l'équivalent du `GROUP BY`, mais *sans* réduire : il découpe en groupes. Absent = toute la table est une seule fenêtre.
- **`ORDER BY`** (dans le `OVER`) = ordonne les lignes dans la fenêtre ; obligatoire pour numéroter, classer, cumuler, ou regarder la ligne d'avant/d'après.

---

## 4. Numéroter et classer : `ROW_NUMBER`, `RANK`, `DENSE_RANK`

Ces fonctions attribuent un numéro selon l'ordre demandé.

```sql
SELECT nom, categorie, prix,
       ROW_NUMBER() OVER (PARTITION BY categorie ORDER BY prix DESC) AS num,
       RANK()       OVER (PARTITION BY categorie ORDER BY prix DESC) AS rang,
       DENSE_RANK() OVER (PARTITION BY categorie ORDER BY prix DESC) AS rang_dense
FROM produits;
```

Différence sur les ex æquo :
- **`ROW_NUMBER`** : numéro unique, toujours 1,2,3… même en cas d'égalité.
- **`RANK`** : même rang pour les ex æquo, puis **saute** (1,1,3).
- **`DENSE_RANK`** : même rang pour les ex æquo, **sans sauter** (1,1,2).

`ROW_NUMBER ... ORDER BY prix DESC` te donne « le plus cher = 1 » dans chaque catégorie.

---

## 5. Agrégat fenêtré : comparer chaque ligne à son groupe

Un agrégat (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`) suivi de `OVER (PARTITION BY ...)` calcule la valeur
du groupe **et la répète sur chaque ligne** du groupe.

```sql
SELECT nom, categorie, prix,
       AVG(prix) OVER (PARTITION BY categorie) AS prix_moyen_categorie,
       prix - AVG(prix) OVER (PARTITION BY categorie) AS ecart_a_la_moyenne
FROM produits;
```

Ici pas besoin d'`ORDER BY` : on veut juste la moyenne de la catégorie en face de chaque produit,
et l'écart de chacun à cette moyenne. Impossible à faire proprement avec un simple `GROUP BY`.

---

## 6. Total cumulé (running total)

En ajoutant `ORDER BY` dans le `OVER`, l'agrégat se calcule « au fil des lignes » : chaque ligne
cumule jusqu'à elle. Classique pour un chiffre d'affaires cumulé dans le temps.

```sql
SELECT date_commande,
       COUNT(*) OVER (ORDER BY date_commande) AS commandes_cumulees
FROM commandes;
```

La lecture : à chaque date, « combien de commandes depuis le début jusqu'ici ».

---

## 7. Regarder la ligne d'avant / d'après : `LAG` / `LEAD`

`LAG` renvoie une valeur de la **ligne précédente**, `LEAD` de la **ligne suivante** (dans l'ordre du
`OVER`). Parfait pour calculer un écart entre deux dates ou deux valeurs successives.

```sql
SELECT date_commande,
       LAG(date_commande)  OVER (ORDER BY date_commande) AS commande_precedente,
       LEAD(date_commande) OVER (ORDER BY date_commande) AS commande_suivante
FROM commandes;
```

La première ligne n'a pas de précédent (`LAG` = NULL), la dernière pas de suivant (`LEAD` = NULL).

---

## 8. À retenir

- Window function = agrégat/numérotation **qui garde toutes les lignes** (≠ `GROUP BY` qui réduit).
- Structure : `fonction() OVER (PARTITION BY ... ORDER BY ...)`.
- `PARTITION BY` = grouper sans réduire ; `ORDER BY` dans le `OVER` = ordonner la fenêtre.
- `ROW_NUMBER` (1,2,3), `RANK` (1,1,3), `DENSE_RANK` (1,1,2) pour numéroter/classer.
- `AVG()/SUM() OVER (PARTITION BY ...)` = comparer chaque ligne à la valeur de son groupe.
- `ORDER BY` dans le `OVER` d'un agrégat = **total cumulé**.
- `LAG` / `LEAD` = valeur de la ligne précédente / suivante.
- **Filtrer sur le résultat d'une window function** (ex. « garder rang ≤ 2 ») se fait dans une **sous-requête** : on ne peut pas mettre une window function dans un `WHERE`.

---

## 9. Exercices

> **Ce qu'ils entraînent :** répondre à des questions qui exigent de garder le détail *tout en*
> calculant sur un groupe — classer dans une catégorie, comparer à une moyenne, cumuler dans le
> temps, mesurer un écart entre deux lignes. C'est le cœur des questions SQL d'entretien.
> Écris tes requêtes dans `exercices/sql/s3_2_window_functions.sql` (base boutique). Commente chaque
> requête en une ligne. **À toi de choisir la bonne fonction — rien n'est imposé.**

1. Pour chaque catégorie, classe les produits du plus cher au moins cher et attribue-leur un numéro de classement (1 = le plus cher de sa catégorie).

2. Affiche chaque produit avec, sur la même ligne, le **prix moyen de sa catégorie**.

3. Ajoute une colonne qui montre de combien chaque produit **s'écarte** du prix moyen de sa catégorie (positif = plus cher que la moyenne).

4. Liste les commandes par date, avec le **nombre cumulé de commandes** depuis la première.

5. Pour chaque commande, affiche la **date de la commande précédente**, et le nombre de jours écoulés depuis (indice : une fonction qui regarde la ligne d'avant).

6. Ne garde que les **2 produits les plus chers de chaque catégorie** (indice : classe-les d'abord, puis filtre le classement — et souviens-toi qu'on ne peut pas filtrer une window function directement dans un `WHERE`).

7. **Réflexion (pas de code).** En une phrase : quelle est la différence entre `GROUP BY` et une window function ?

---

*Quand c'est fait, envoie-moi le fichier `.sql`. Ensuite, dernier thème de la S3 : ta **première
classe Python** (OOP — programmation orientée objet). Puis on bouclera la semaine par le mini-projet
de synthèse.*
