# Semaine 2 · SQL — Alias, JOINs multiples & sous-requêtes

> Session SQL. Tu sais déjà faire un `JOIN` (INNER/LEFT) entre deux tables. Ici on monte d'un cran :
> donner des **alias** pour écrire des requêtes lisibles, **enchaîner plusieurs JOINs** (3-4 tables)
> pour reconstituer une commande complète, et utiliser des **sous-requêtes** (une requête dans une
> requête). C'est exactement ce qu'on te demandera en entretien data engineer : naviguer entre des
> tables liées par des clés.

> Base utilisée : ta base **boutique** (script `cours/semaine-01/setup_boutique.sql`).
> Schéma : `clients` ← `commandes` ← `lignes_commande` → `produits`.

```
clients(id_client, prenom, nom, ville, date_inscription)
   │ id_client
commandes(id_commande, id_client, date_commande)
   │ id_commande
lignes_commande(id_ligne, id_commande, id_produit, quantite)
   │ id_produit
produits(id_produit, nom, categorie, prix)
```

---

## 1. Pourquoi ce thème

Les vraies données vivent dans **plusieurs tables reliées par des clés** (FK = Foreign Key = clé
étrangère, une colonne qui pointe vers la clé primaire d'une autre table). Une commande, c'est un
client + une date + des lignes + des produits : quatre tables à recoller. Savoir enchaîner les
JOINs et glisser une sous-requête au bon endroit, c'est le cœur du métier — et le type de question
qu'on pose systématiquement en entretien SQL.

---

## 2. Les alias (`AS`)

Un **alias** est un nom court qu'on donne à une table ou à une colonne, le temps de la requête.
Sur les colonnes, il rend le résultat lisible ; sur les tables, il évite de réécrire le nom entier
et lève les ambiguïtés quand deux tables ont une colonne de même nom (`nom` existe dans `clients`
ET dans `produits`).

```sql
SELECT  c.prenom AS prenom_client,        -- alias de COLONNE (titre affiché)
        p.nom    AS nom_produit
FROM    clients   AS c                      -- alias de TABLE : "clients" devient "c"
JOIN    commandes AS co ON co.id_client = c.id_client
JOIN    lignes_commande AS lc ON lc.id_commande = co.id_commande
JOIN    produits  AS p  ON p.id_produit = lc.id_produit;
```

Le mot-clé `AS` est facultatif (`FROM clients c` marche aussi), mais l'écrire est plus clair au
début. Une fois l'alias `c` défini, on préfixe chaque colonne par `c.` / `p.` / etc.

---

## 3. JOINs multiples (recoller 3-4 tables)

On chaîne les `JOIN` : chaque nouveau `JOIN ... ON ...` raccroche une table de plus, via la clé qui
les relie. Lis-le comme un chemin : clients → commandes → lignes_commande → produits.

```sql
SELECT  c.prenom, c.nom, co.date_commande, p.nom AS produit, lc.quantite
FROM    clients c
JOIN    commandes       co ON co.id_client   = c.id_client       -- client -> ses commandes
JOIN    lignes_commande lc ON lc.id_commande = co.id_commande    -- commande -> ses lignes
JOIN    produits        p  ON p.id_produit   = lc.id_produit;    -- ligne   -> le produit
```

Chaque `ON` dit **comment** les deux tables se relient (clé étrangère = clé primaire). Si tu oublies
un `ON`, tu obtiens un produit cartésien (toutes les combinaisons) — résultat faux et énorme.

Astuce calcul : le montant d'une ligne = `lc.quantite * p.prix`.

```sql
SELECT  c.prenom, p.nom AS produit, lc.quantite, p.prix,
        lc.quantite * p.prix AS montant_ligne     -- colonne calculée
FROM    clients c
JOIN    commandes       co ON co.id_client   = c.id_client
JOIN    lignes_commande lc ON lc.id_commande = co.id_commande
JOIN    produits        p  ON p.id_produit   = lc.id_produit;
```

---

## 4. Les sous-requêtes (une requête dans une requête)

Une **sous-requête** est un `SELECT` entre parenthèses, utilisé à l'intérieur d'un autre. Trois cas
courants :

### a) Sous-requête scalaire (renvoie UNE seule valeur)

Utile pour comparer à un agrégat. Ici : les produits plus chers que la moyenne.

```sql
SELECT nom, prix
FROM   produits
WHERE  prix > (SELECT AVG(prix) FROM produits);   -- la sous-requête renvoie un seul nombre
```

L'intérieur s'exécute d'abord (`AVG(prix)` = prix moyen), puis le `WHERE` compare chaque ligne à
cette valeur.

### b) Sous-requête avec `IN` (renvoie UNE liste)

Garde les lignes dont la valeur figure dans la liste renvoyée par la sous-requête. Ici : les clients
qui ont au moins une commande.

```sql
SELECT prenom, nom
FROM   clients
WHERE  id_client IN (SELECT id_client FROM commandes);   -- liste des id_client présents dans commandes
```

C'est le `IN` que tu connais, mais alimenté par une requête au lieu d'une liste écrite à la main —
exactement comme `isin([...])` en pandas.

### c) Sous-requête dans le `FROM` (table dérivée)

On peut traiter le résultat d'un `SELECT` comme une table temporaire, à laquelle on donne un alias.

```sql
SELECT categorie, prix_max
FROM ( SELECT categorie, MAX(prix) AS prix_max     -- table dérivée
       FROM   produits
       GROUP BY categorie ) AS stats               -- alias OBLIGATOIRE sur une table dérivée
WHERE prix_max > 50;
```

> JOIN ou sous-requête ? Souvent les deux marchent. Règle simple au début : **JOIN** quand tu veux
> afficher des colonnes de plusieurs tables ; **sous-requête** quand tu veux juste filtrer/comparer
> à un calcul intermédiaire.

---

## 5. À retenir

- **Alias** : `FROM clients AS c` puis `c.colonne` — lisibilité + lève les ambiguïtés de noms.
- **JOINs multiples** : un `JOIN ... ON ...` par table à recoller, en suivant les clés ; jamais de JOIN sans `ON`.
- Colonne calculée en SQL : `lc.quantite * p.prix AS montant_ligne`.
- **Sous-requête scalaire** (1 valeur) → comparaison (`> (SELECT AVG...)`).
- **Sous-requête `IN`** (1 liste) → filtre d'appartenance, comme `isin` en pandas.
- **Sous-requête dans `FROM`** (table dérivée) → alias obligatoire.

---

## 6. Exercices

> **Ce qu'ils entraînent :** naviguer dans un schéma relationnel — relier plusieurs tables par leurs
> clés, et isoler une information via une sous-requête. C'est LA compétence SQL qu'on teste en
> entretien data engineer. Écris tes requêtes dans `exercices/sql/s2_3_sousrequetes_jointures.sql`
> (base boutique ; relance `setup_boutique.sql` avant si besoin). Commente chaque requête en une
> ligne (à quoi elle répond).

1. Avec des **alias**, affiche pour chaque commande : prénom + nom du client et la date de commande (JOIN `clients` + `commandes`).

2. **JOIN à 4 tables** : affiche prénom du client, nom du produit et quantité, pour chaque ligne de commande (`clients` → `commandes` → `lignes_commande` → `produits`).

3. Ajoute à la requête précédente une **colonne calculée** `montant_ligne` = `quantite × prix`, et trie par montant décroissant.

4. **Sous-requête scalaire** : affiche les produits dont le `prix` est **supérieur à la moyenne** des prix.

5. **Sous-requête `IN`** : affiche les clients (prénom, nom) qui ont **au moins une commande**.

6. À l'inverse, avec `NOT IN` : affiche les clients qui **n'ont jamais commandé**.

7. **Sous-requête `IN` enchaînée** : affiche les noms des produits qui ont été commandés au moins une fois (indice : `id_produit IN (SELECT id_produit FROM lignes_commande)`).

8. **Table dérivée** (sous-requête dans `FROM`) : pour chaque catégorie de produit, le prix maximum ; ne garde que les catégories dont ce maximum dépasse 50.

9. **Réflexion (pas de code).** En une phrase : quand préfères-tu un JOIN, et quand une sous-requête ?

---

*Quand c'est fait, envoie-moi le fichier `.sql`. Ça boucle la Semaine 2 côté apprentissage ; il
restera le livrable de la semaine (notebook d'analyse exploratoire) avant de passer à la S3.*
