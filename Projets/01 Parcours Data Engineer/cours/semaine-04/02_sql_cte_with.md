# Semaine 4 · SQL — Les CTE (`WITH ... AS`)

> Session SQL. Une **CTE** (Common Table Expression = « expression de table commune ») est un
> **résultat intermédiaire nommé**, défini avec `WITH`, que tu réutilises dans la suite de ta requête.
> C'est l'outil qui rend **lisibles** les requêtes compliquées : au lieu d'imbriquer des sous-requêtes
> les unes dans les autres, tu poses des étapes claires, de haut en bas. Très apprécié en entretien.

> Base utilisée : ta base **boutique** (`cours/semaine-01/setup_boutique.sql`).
> Rappel : `lignes_commande` relie `commandes` et `produits` ; montant d'une ligne = `quantite × prix`.

---

## 1. Pourquoi ce thème

Souviens-toi de ton exercice « top 2 par catégorie » (S3) : tu as dû mettre une sous-requête **dans le
`FROM`** pour filtrer un `RANK()`. Ça marche, mais dès que les étapes s'empilent, la requête devient
illisible (des parenthèses dans des parenthèses). Une **CTE** donne un **nom** à chaque étape et se lit
dans l'ordre, comme des variables intermédiaires en Python. Même résultat, mais clair — et une étape
peut être **réutilisée** plusieurs fois.

---

## 2. La syntaxe de base

```sql
WITH ca_par_client AS (                       -- on nomme une étape intermédiaire
    SELECT id_client, SUM(lc.quantite * p.prix) AS ca
    FROM   commandes co
    JOIN   lignes_commande lc ON lc.id_commande = co.id_commande
    JOIN   produits        p  ON p.id_produit   = lc.id_produit
    GROUP BY id_client
)
SELECT *                                       -- puis on s'en sert comme d'une table
FROM   ca_par_client
WHERE  ca > 100;
```

Lecture : « **avec** une table temporaire `ca_par_client` (= le CA de chaque client), sélectionne ceux
dont le CA dépasse 100 ». La CTE vit **le temps de la requête** ; ce n'est pas une vraie table stockée.

---

## 3. CTE vs sous-requête dans le `FROM` : même résultat, plus lisible

Les deux écritures ci-dessous donnent exactement la même chose. Compare la lisibilité :

```sql
-- Sous-requête imbriquée (table dérivée) : on lit de l'intérieur vers l'extérieur
SELECT * FROM (
    SELECT id_client, SUM(lc.quantite * p.prix) AS ca
    FROM commandes co
    JOIN lignes_commande lc ON lc.id_commande = co.id_commande
    JOIN produits p ON p.id_produit = lc.id_produit
    GROUP BY id_client
) AS t
WHERE ca > 100;

-- CTE : on lit de haut en bas, chaque étape a un nom
WITH ca_par_client AS ( ... même SELECT ... )
SELECT * FROM ca_par_client WHERE ca > 100;
```

Bonus : plus besoin de bricoler un alias `AS t` obligatoire (le piège PostgreSQL de la S2) — la CTE
**est** son propre nom.

---

## 4. Enchaîner plusieurs CTE

On peut définir **plusieurs** CTE en les séparant par une virgule ; une CTE peut s'appuyer sur la
précédente. C'est là que la lisibilité devient un vrai atout.

```sql
WITH
ca_par_client AS (                              -- étape 1 : CA de chaque client
    SELECT co.id_client, SUM(lc.quantite * p.prix) AS ca
    FROM   commandes co
    JOIN   lignes_commande lc ON lc.id_commande = co.id_commande
    JOIN   produits        p  ON p.id_produit   = lc.id_produit
    GROUP BY co.id_client
),
moyenne AS (                                    -- étape 2 : le CA moyen, calculé à partir de l'étape 1
    SELECT AVG(ca) AS ca_moyen FROM ca_par_client
)
SELECT c.prenom, c.nom, cpc.ca                  -- étape finale : on combine tout
FROM   ca_par_client cpc
JOIN   clients c ON c.id_client = cpc.id_client
CROSS JOIN moyenne m
WHERE  cpc.ca > m.ca_moyen;                      -- clients au-dessus de la moyenne
```

Chaque bloc est une brique nommée : on lit `ca_par_client`, puis `moyenne`, puis la requête finale.

---

## 5. CTE + window function : le combo lisible

Ton « top 2 par catégorie » (S3) devient limpide : on calcule le classement dans une CTE, on filtre
après. Rappel : on **ne peut pas** filtrer une window function dans un `WHERE` — la CTE règle ça
proprement.

```sql
WITH classement AS (
    SELECT nom, categorie, prix,
           RANK() OVER (PARTITION BY categorie ORDER BY prix DESC) AS rang
    FROM   produits
)
SELECT nom, categorie, prix
FROM   classement
WHERE  rang <= 2;                                -- filtrer le rang : possible ici, pas dans le SELECT d'origine
```

---

## 6. À retenir

- **CTE** = résultat intermédiaire **nommé**, défini avec `WITH nom AS ( ... )`, utilisable ensuite comme une table.
- Elle vit **le temps de la requête** (ce n'est pas une table stockée).
- Même pouvoir qu'une sous-requête dans le `FROM`, mais **lisible de haut en bas** et **réutilisable**.
- Plusieurs CTE : séparées par des virgules ; une CTE peut utiliser la précédente.
- Combo clé (entretien) : **CTE + window function** pour filtrer un `RANK()`/`ROW_NUMBER()` proprement.

---

## 7. Exercices

> **Ce que tu dois en retenir :** découper une requête en étapes nommées et lisibles avec `WITH`, au
> lieu d'empiler des sous-requêtes. C'est ce qu'on attend d'un code SQL « propre » en entretien et en
> poste. Écris tes requêtes dans `exercices/sql/s4_2_cte_with.sql` (base boutique). Commente chaque
> requête. **À toi de structurer — plusieurs approches marchent, choisis la plus claire.**

1. Calcule le chiffre d'affaires (CA) de chaque client (somme de `quantité × prix` sur ses commandes), et n'affiche que les clients dont le CA dépasse **150**. Structure ta requête avec une étape intermédiaire nommée.

2. En repartant du CA par client, affiche **prénom + nom + CA** des clients dont le CA est **supérieur au CA moyen** de tous les clients.

3. Pour chaque **ville**, donne le CA total de ses clients, classé du plus élevé au plus faible.

4. Affiche, **par catégorie de produit**, le produit qui rapporte le plus de CA (indice : classe les produits par CA à l'intérieur de chaque catégorie, puis ne garde que le premier — pense à l'endroit où filtrer un classement).

5. **Réflexion (pas de code).** En une phrase : qu'apporte une CTE par rapport à une sous-requête imbriquée dans le `FROM` ?

---

*Quand c'est fait, envoie-moi le fichier `.sql`. On aura alors couvert merge/concat + CTE ; il restera
`pivot_table`/`apply` et un flux API→pandas pour compléter la S4, puis le mini-projet cumulatif S1→S4.*
