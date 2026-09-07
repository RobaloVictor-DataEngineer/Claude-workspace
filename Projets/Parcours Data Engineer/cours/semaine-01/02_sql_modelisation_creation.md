# Semaine 1 · SQL — Modélisation & création de tables (bonnes pratiques)

> Session de l'après-midi. Tu m'as dit que ton point faible, c'est créer/modifier/supprimer des
> tables et bien modéliser. On attaque donc par là : tu vas **construire une vraie petite base
> réutilisable** en comprenant chaque choix. On l'interrogera (SELECT, JOIN, GROUP BY) à la
> prochaine session SQL.

---

## 1. Vocabulaire de base (sigles définis une fois)

- **SGBD** = Système de Gestion de Base de Données (ici PostgreSQL) : le logiciel qui stocke et gère les données.
- **Table** : un tableau (lignes × colonnes). Une table = un type d'objet (clients, produits...).
- **Ligne** (enregistrement) : un objet précis (un client). **Colonne** (champ) : une caractéristique (son prénom).
- **PK** = *Primary Key* (clé primaire) : la colonne qui identifie de façon **unique** chaque ligne (souvent un `id`).
- **FK** = *Foreign Key* (clé étrangère) : une colonne qui **pointe vers la PK d'une autre table**. C'est le lien entre deux tables.
- **DDL** = *Data Definition Language* : les commandes qui créent/modifient la **structure** (`CREATE`, `ALTER`, `DROP`).

---

## 2. Les bonnes pratiques de modélisation (ton point faible — lis bien)

1. **Une clé primaire technique sur chaque table.** Un `id` auto-incrémenté (type `SERIAL`), neutre et stable. On n'utilise pas le nom ou l'email comme identifiant : ça change et ça peut se répéter.
2. **Ne jamais répéter une information → on la référence.** Au lieu de réécrire le nom du client dans chaque commande, la commande stocke juste `id_client` (une FK). C'est la **normalisation** : chaque info vit à un seul endroit. Si le client change de nom, on corrige une seule ligne au lieu de mille.
3. **Le bon type pour chaque colonne** : `INTEGER` (entiers), `VARCHAR(n)` (texte court borné), `NUMERIC(10,2)` (nombre exact — pour l'argent, **jamais** `FLOAT` qui arrondit mal), `DATE` (dates), `BOOLEAN` (vrai/faux).
4. **Des contraintes pour protéger les données** : `NOT NULL` (obligatoire), `UNIQUE` (pas de doublon), `CHECK (...)` (une règle, ex : `quantite > 0`), `PRIMARY KEY`, `REFERENCES` (la FK).
5. **Nommage propre et constant** : minuscules, `snake_case` (mots_séparés_par_underscore), **sans accents ni espaces**, noms explicites. Reste cohérent (ex : toujours `id_xxx` pour les clés).

---

## 3. Notre base « boutique »

Quatre tables : `clients`, `produits`, `commandes`, `lignes_commande` (revois le schéma envoyé dans le chat). Les relations :

- un client passe plusieurs commandes → `commandes.id_client` pointe vers `clients` : relation **1 à N** (un client, plusieurs commandes) ;
- une commande contient plusieurs produits, et un produit apparaît dans plusieurs commandes → on ne peut pas relier directement : on crée une table au milieu, `lignes_commande`, qui porte les deux FK. C'est une **table de liaison**, qui résout une relation **N à N**.

> **LE concept à retenir :** quand deux tables sont en relation « plusieurs à plusieurs »
> (une commande a plusieurs produits, un produit est dans plusieurs commandes), on crée une
> 3e table au milieu qui contient les deux clés étrangères. C'est la table de liaison.

---

## 4. Le script de création, expliqué

Le script complet est dans `setup_boutique.sql`. Les points nouveaux pour toi :

```sql
CREATE TABLE clients (
    id_client        SERIAL PRIMARY KEY,     -- entier auto-incrémenté + clé primaire
    prenom           VARCHAR(50) NOT NULL,   -- texte max 50 car., obligatoire
    ville            VARCHAR(50),            -- facultatif (pas de NOT NULL)
    date_inscription DATE NOT NULL
);
```

```sql
CREATE TABLE commandes (
    id_commande   SERIAL PRIMARY KEY,
    id_client     INTEGER NOT NULL REFERENCES clients(id_client), -- FK vers clients
    date_commande DATE NOT NULL
);
```

`REFERENCES clients(id_client)` crée la clé étrangère : PostgreSQL **refusera** une commande dont le client n'existe pas. C'est l'**intégrité référentielle** — pas de commande orpheline.

```sql
CREATE TABLE lignes_commande (
    id_ligne    SERIAL PRIMARY KEY,
    id_commande INTEGER NOT NULL REFERENCES commandes(id_commande),
    id_produit  INTEGER NOT NULL REFERENCES produits(id_produit),
    quantite    INTEGER NOT NULL CHECK (quantite > 0)  -- règle de validation
);
```

---

## 5. Modifier et supprimer (ALTER, DROP, DELETE, TRUNCATE) — à ne pas confondre

- `ALTER TABLE produits ADD COLUMN stock INTEGER;` → **modifie la structure** (ajoute une colonne).
- `DROP TABLE produits;` → **supprime la table entière** (structure + données). Irréversible.
- `DELETE FROM produits WHERE id_produit = 4;` → **supprime des lignes** ciblées ; la table reste.
- `TRUNCATE TABLE produits;` → vide **toutes** les lignes d'un coup ; la table reste.

Mémo : `DROP` = je jette le tableau ; `DELETE`/`TRUNCATE` = je gomme des lignes dedans ; `ALTER` = je change les colonnes.

> Pourquoi `DROP TABLE IF EXISTS ...` en haut du script ? Pour pouvoir **relancer** le script
> autant de fois que tu veux : il efface d'abord les tables si elles existent, puis les recrée
> proprement. Pratique pour repartir d'une base propre.

---

## 6. À retenir

- PK = identifie chaque ligne (un `id` `SERIAL`). FK = pointe vers la PK d'une autre table → c'est le lien.
- On ne répète pas l'info, on la référence (normalisation).
- Relation N↔N = table de liaison au milieu (ici `lignes_commande`).
- DDL : `CREATE` (créer), `ALTER` (modifier la structure), `DROP` (supprimer la table). `DELETE`/`TRUNCATE` suppriment des lignes.
- Bon type + `NOT NULL` + `CHECK` = données fiables. Nommage `snake_case`, sans accents.

---

## 7. Exercices

> **Ce qu'ils entraînent :** installer la base, puis créer/modifier une table toi-même en
> appliquant les bonnes pratiques — exactement ton point faible. Mets tes réponses dans
> `exercices/sql/s1_modelisation.sql` et envoie-moi le fichier ; je corrige.

**Étape 0 — installer la base (à faire d'abord).** Ouvre `setup_boutique.sql` dans DBeaver, sélectionne tout (Ctrl+A) et exécute (Alt+X exécute tout le script dans DBeaver). Tu dois voir les données des tables `clients` et `produits` s'afficher. C'est ta base réutilisable.

1. Écris la requête qui affiche **toutes les commandes du client n°1** (table `commandes`, filtre sur `id_client`). *(Indice : `SELECT ... FROM ... WHERE ...`.)*

2. **Création (DDL).** Crée une table `fournisseurs` en respectant les bonnes pratiques : une PK `id_fournisseur` auto-incrémentée, un `nom` texte obligatoire, une `ville` texte facultative, un `email` texte **unique**. *(Indice : `SERIAL PRIMARY KEY`, `NOT NULL`, `UNIQUE`.)*

3. **Modification (ALTER).** Ajoute à la table `produits` une colonne `stock` de type entier.

4. **Suppression (DELETE).** Écris la requête qui supprimerait le produit dont l'`id_produit` vaut 4. *(Tu peux ne pas l'exécuter si tu veux garder ta donnée.)*

5. **Réflexion (pas de code).** En une phrase : pourquoi stocke-t-on `id_client` dans `commandes` plutôt que d'y réécrire le nom et la ville du client ?

---

*Quand tu as fait les exercices, envoie-moi ton fichier `.sql`. Ensuite, prochaine session SQL : interroger cette base (SELECT, WHERE, GROUP BY, JOIN).*
