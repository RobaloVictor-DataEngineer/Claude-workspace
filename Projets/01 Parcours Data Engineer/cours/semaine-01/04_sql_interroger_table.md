# Semaine 1 · SQL — Interroger une table (SELECT, WHERE, ORDER BY, agrégats, GROUP BY)

> Session SQL sur ta base boutique. On apprend à **lire et résumer** les données d'une seule
> table. Les **JOIN** (croiser plusieurs tables) seront la prochaine session SQL — un concept à
> part entière. Ici, on travaille donc avec les `id` quand il le faut.
>
> Pré-requis : avoir exécuté `setup_boutique.sql`. Exécute chaque requête une par une
> (curseur dans la requête + `Ctrl+E Ctrl+E` dans VS Code, ou `Ctrl+Entrée` dans DBeaver).

---

## 1. Le squelette d'une requête

Une requête de lecture suit toujours le même ordre de mots-clés :

```sql
SELECT   colonnes        -- QUOI afficher
FROM     table           -- D'OÙ
WHERE    condition        -- filtrer les LIGNES
GROUP BY colonne          -- regrouper
HAVING   condition        -- filtrer les GROUPES
ORDER BY colonne          -- trier le résultat
LIMIT    n;               -- limiter le nombre de lignes
```

Tu n'utilises que les lignes dont tu as besoin, mais **l'ordre est imposé** : `WHERE` toujours
avant `GROUP BY`, `ORDER BY` toujours à la fin, etc.

---

## 2. SELECT — choisir les colonnes

```sql
SELECT nom, prix FROM produits;     -- seulement 2 colonnes
SELECT * FROM produits;             -- * = toutes les colonnes
SELECT nom AS produit, prix AS tarif FROM produits;  -- AS = renommer l'affichage (alias)
```

---

## 3. WHERE — filtrer les lignes

Opérateurs : `=`, `<>` (différent), `<`, `>`, `<=`, `>=`, et on combine avec `AND` / `OR`.

```sql
SELECT * FROM produits WHERE prix > 50;
SELECT * FROM produits WHERE categorie = 'Informatique' AND prix < 100;
SELECT * FROM produits WHERE prix BETWEEN 10 AND 100;     -- entre 10 et 100 (bornes incluses)
SELECT * FROM produits WHERE categorie IN ('Audio', 'Papeterie');  -- dans une liste
SELECT * FROM produits WHERE nom LIKE '%audio%';          -- LIKE = motif ; % = n'importe quoi
```

> Le texte est entre **apostrophes simples** : `'Informatique'`. Les guillemets doubles, c'est pour les noms de colonnes.

---

## 4. ORDER BY et LIMIT — trier et limiter

```sql
SELECT nom, prix FROM produits ORDER BY prix;        -- croissant (ASC par défaut)
SELECT nom, prix FROM produits ORDER BY prix DESC;   -- décroissant
SELECT nom, prix FROM produits ORDER BY prix DESC LIMIT 3;  -- les 3 plus chers
```

---

## 5. Les agrégats — résumer une colonne en une valeur

`COUNT` (compter), `SUM` (somme), `AVG` (moyenne), `MIN`, `MAX`.

```sql
SELECT COUNT(*) FROM produits;        -- combien de produits en tout ?
SELECT AVG(prix) FROM produits;       -- prix moyen
SELECT MIN(prix), MAX(prix) FROM produits;  -- le moins cher / le plus cher
```

Sans `GROUP BY`, un agrégat renvoie **une seule ligne** (le résumé de toute la table).

---

## 6. GROUP BY — un résumé PAR groupe

```sql
-- Combien de produits et quel prix moyen, PAR catégorie ?
SELECT categorie, COUNT(*), AVG(prix)
FROM produits
GROUP BY categorie;
```

Règle d'or : **toute colonne du `SELECT` qui n'est pas un agrégat doit être dans le `GROUP BY`.**
Ici `categorie` est dans le `GROUP BY`, `COUNT(*)` et `AVG(prix)` sont des agrégats : c'est bon.

### HAVING — filtrer les groupes
`WHERE` filtre les **lignes** (avant regroupement) ; `HAVING` filtre les **groupes** (après).

```sql
-- Seulement les catégories qui ont plus d'un produit
SELECT categorie, COUNT(*)
FROM produits
GROUP BY categorie
HAVING COUNT(*) > 1;
```

---

## 7. À retenir

- Ordre imposé : `SELECT … FROM … WHERE … GROUP BY … HAVING … ORDER BY … LIMIT`.
- `WHERE` filtre des **lignes**, `HAVING` filtre des **groupes**.
- Un agrégat (`COUNT`, `SUM`, `AVG`…) résume ; avec `GROUP BY`, il résume **par groupe**.
- Toute colonne non-agrégée du `SELECT` doit être dans le `GROUP BY`.
- Texte entre apostrophes simples `'...'`.

---

## 8. Exercices

> **Volontairement sur d'autres tables/questions que les exemples** (clients, commandes,
> lignes_commande) pour que tu transfères le concept, pas que tu recopies. Mets tes réponses dans
> `exercices/sql/s1_interrogation.sql` et envoie-le-moi.

1. Affiche le **prénom** et la **ville** de tous les clients, triés par ville de A à Z.

2. Affiche les **commandes passées après le 1er avril 2025** (`date_commande > '2025-04-01'`), de la plus récente à la plus ancienne.

3. **Combien de clients** habitent à Rouen ? (un seul nombre en résultat)

4. **Pour chaque ville**, combien y a-t-il de clients ? (résumé par groupe)

5. Quelles **villes ont au moins 2 clients** ? (groupes filtrés)

6. (bonus, table `lignes_commande`) Pour chaque `id_produit`, quelle est la **quantité totale commandée** ? Trie du plus commandé au moins commandé. *(Indice : `SUM(quantite)`, `GROUP BY id_produit`, `ORDER BY ... DESC`.)*

---

*Quand c'est fait, envoie ton `.sql`. Prochaine session SQL : les JOIN, pour enfin afficher les
noms des clients et des produits à la place de leurs `id`.*
