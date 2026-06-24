# Semaine 1 · SQL — Les JOIN (croiser plusieurs tables)

> LA notion clé du SQL pour un data engineer. Tes données sont éclatées dans plusieurs tables
> (normalisation) ; le JOIN sert à les **recoller** pour afficher, par exemple, le nom du client
> à côté de sa commande. Pré-requis : base boutique installée.

---

## 1. Le problème que le JOIN résout

Dans `commandes`, tu n'as que `id_client` (un numéro), pas le nom. Le nom est dans `clients`.
Pour afficher « commande n°1 — Victor Robalo », il faut **relier** les deux tables sur leur clé
commune : `commandes.id_client = clients.id_client`. C'est exactement le rôle du JOIN.

---

## 2. INNER JOIN — les correspondances des deux côtés

```sql
SELECT c.id_commande, cl.prenom, cl.nom, c.date_commande
FROM commandes AS c
INNER JOIN clients AS cl
    ON c.id_client = cl.id_client;
```

- `FROM commandes AS c` : table de départ, alias `c`.
- `INNER JOIN clients AS cl` : la table qu'on rattache, alias `cl`.
- `ON c.id_client = cl.id_client` : **la condition de liaison** — on associe chaque commande à la
  ligne client qui a le même id.
- Devant chaque colonne, on précise la table (`c.` ou `cl.`) : obligatoire quand une colonne existe
  des deux côtés (ici `id_client`), et recommandé partout pour la clarté.

Résultat : chaque commande avec le nom de son client. `INNER` = on garde **uniquement** les lignes
qui ont une correspondance des deux côtés.

> C'est ici que les alias deviennent vraiment utiles : `c` et `cl` évitent de réécrire les noms de
> tables à chaque colonne.

---

## 3. LEFT JOIN — toutes les lignes de gauche

```sql
SELECT cl.prenom, cl.nom, c.id_commande
FROM clients AS cl
LEFT JOIN commandes AS c
    ON cl.id_client = c.id_client;
```

`LEFT JOIN` garde **toutes les lignes de la table de gauche** (`clients`), même celles sans
correspondance à droite. Pour un client sans commande, les colonnes de `commandes` valent `NULL`.

> Différence à retenir (revois le schéma envoyé dans le chat) :
> **INNER** = seulement les matchs · **LEFT** = tous les « gauche » + les matchs (NULL si pas de match).

---

## 4. Enchaîner plusieurs JOIN (pour aller plus loin)

Pour relier commande → client ET produits, on enchaîne les JOIN :

```sql
SELECT cl.prenom, p.nom AS produit, l.quantite
FROM commandes AS c
INNER JOIN clients AS cl         ON c.id_client = cl.id_client
INNER JOIN lignes_commande AS l  ON l.id_commande = c.id_commande
INNER JOIN produits AS p         ON p.id_produit = l.id_produit;
```

Chaque JOIN ajoute une table avec sa propre condition `ON`. Là, tu lis « qui a acheté quoi ».

---

## 5. À retenir

- JOIN = recoller des tables sur une clé commune, via `ON fk = pk`.
- `INNER JOIN` = seulement les lignes qui matchent des deux côtés.
- `LEFT JOIN` = toutes les lignes de gauche + les matchs (`NULL` à droite si pas de match).
- Préfixe tes colonnes avec l'alias de table (`c.`, `cl.`) ; les alias rendent le JOIN lisible.

---

## 6. Exercices

> Questions différentes des exemples. On crée d'abord un cas **sans correspondance** pour bien voir
> la différence INNER/LEFT. Réponses dans `exercices/sql/s1_jointures.sql`, puis envoie-le-moi.

**Étape 0 — ajoute une cliente sans commande** (pour l'exercice) :
```sql
INSERT INTO clients (prenom, nom, ville, date_inscription)
VALUES ('Emma', 'Roux', 'Bordeaux', '2025-06-01');
```

1. **(INNER JOIN)** Affiche, pour chaque **ligne de commande**, le **nom du produit** et la **quantité**. *(relie `lignes_commande` et `produits`)*

2. **(INNER JOIN)** Affiche chaque **commande** avec le **prénom et la ville du client** et la **date de commande**. *(relie `commandes` et `clients`)*

3. **(LEFT JOIN)** Affiche **tous les clients** et leur `id_commande` éventuel. Vérifie qu'Emma apparaît bien avec `id_commande` à `NULL`.

4. **(réflexion, pas de code)** Si tu remplaçais le `LEFT JOIN` de la Q3 par un `INNER JOIN`, qu'arriverait-il à Emma dans le résultat ? Pourquoi ?

5. **(bonus, 3 tables)** Affiche **quel client a acheté quel produit** : prénom du client + nom du produit. *(enchaîne `commandes`, `clients`, `lignes_commande`, `produits`)*

---

*Quand c'est fait, envoie ton `.sql`. Avec ça, tu auras bouclé tout le SQL « interrogation » de la
Semaine 1 — il te restera surtout le `try/except` en Python et le livrable (script CSV + repo).*
