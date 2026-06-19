-- ============================================================
--  Base "boutique" - script de création réutilisable
--  À exécuter dans DBeaver (connecté à PostgreSQL).
--  Tu peux le relancer autant de fois que tu veux :
--  il supprime puis recrée tout proprement.
-- ============================================================

-- 1) On efface d'abord (dans l'ordre inverse des dépendances :
--    on supprime les tables "enfants" avant les "parents").
DROP TABLE IF EXISTS lignes_commande;
DROP TABLE IF EXISTS commandes;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS clients;

-- 2) Création des tables
CREATE TABLE clients (
    id_client        SERIAL PRIMARY KEY,     -- SERIAL = entier auto-incrémenté ; PRIMARY KEY = clé primaire
    prenom           VARCHAR(50) NOT NULL,   -- texte (max 50 caractères), obligatoire
    nom              VARCHAR(50) NOT NULL,
    ville            VARCHAR(50),            -- facultatif (pas de NOT NULL)
    date_inscription DATE NOT NULL
);

CREATE TABLE produits (
    id_produit SERIAL PRIMARY KEY,
    nom        VARCHAR(100) NOT NULL,
    categorie  VARCHAR(50),
    prix       NUMERIC(10,2) NOT NULL        -- NUMERIC = nombre exact (idéal pour de l'argent)
);

CREATE TABLE commandes (
    id_commande   SERIAL PRIMARY KEY,
    id_client     INTEGER NOT NULL REFERENCES clients(id_client),  -- FK : pointe vers clients
    date_commande DATE NOT NULL
);

CREATE TABLE lignes_commande (
    id_ligne    SERIAL PRIMARY KEY,
    id_commande INTEGER NOT NULL REFERENCES commandes(id_commande), -- FK vers commandes
    id_produit  INTEGER NOT NULL REFERENCES produits(id_produit),   -- FK vers produits
    quantite    INTEGER NOT NULL CHECK (quantite > 0)               -- CHECK = règle : quantité positive
);

-- 3) Insertion des données (on ne précise pas les id : SERIAL les attribue 1, 2, 3...)
INSERT INTO clients (prenom, nom, ville, date_inscription) VALUES
('Victor', 'Robalo', 'Rouen', '2025-01-15'),
('Sarah',  'Martin', 'Paris', '2025-02-03'),
('Karim',  'Benali', 'Rouen', '2025-02-20'),
('Lina',   'Costa',  'Lyon',  '2025-03-10'),
('Tom',    'Leroy',  'Paris', '2025-04-01');

INSERT INTO produits (nom, categorie, prix) VALUES
('Clavier mécanique', 'Informatique', 89.90),
('Souris sans fil',   'Informatique', 29.90),
('Écran 27 pouces',   'Informatique', 219.00),
('Cahier',            'Papeterie',    4.50),
('Stylo (lot de 10)', 'Papeterie',    7.90),
('Casque audio',      'Audio',        59.90);

INSERT INTO commandes (id_client, date_commande) VALUES
(1, '2025-03-01'),
(2, '2025-03-05'),
(1, '2025-04-10'),
(3, '2025-04-12'),
(4, '2025-05-02'),
(5, '2025-05-15');

INSERT INTO lignes_commande (id_commande, id_produit, quantite) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 5),
(3, 5, 2),
(4, 6, 1),
(4, 2, 1),
(5, 1, 1),
(5, 3, 1),
(5, 6, 2),
(6, 5, 3);

-- 4) Vérification rapide
SELECT * FROM clients;
SELECT * FROM produits;
