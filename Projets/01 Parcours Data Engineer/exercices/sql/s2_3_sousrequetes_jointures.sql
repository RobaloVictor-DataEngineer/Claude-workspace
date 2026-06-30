-- ============================================================
--  Semaine 2 · SQL — Alias, JOINs multiples & sous-requêtes
--  Base : boutique (relancer cours/semaine-01/setup_boutique.sql si besoin)
--  Schéma : clients <- commandes <- lignes_commande -> produits
--
--  Écris ta requête sous chaque énoncé, et commente-la en une ligne.
-- ============================================================

-- ----- PRÉPARATION (à exécuter UNE FOIS, après setup_boutique.sql) -----
-- Ajoute un client qui n'a jamais commandé + un produit jamais commandé,
-- pour que les exercices 6 (NOT IN) et 7 (IN) aient des réponses non vides.
INSERT INTO clients (prenom, nom, ville, date_inscription) VALUES
('Nora', 'Diaz', 'Lille', '2025-05-20');          -- aucun id dans commandes
INSERT INTO produits (nom, categorie, prix) VALUES
('Webcam HD', 'Informatique', 49.90);             -- aucun id dans lignes_commande
-- -----------------------------------------------------------------------


-- 1) Avec des ALIAS : pour chaque commande, prénom + nom du client et la date de commande.
--    (JOIN clients + commandes)
select c.prenom, c.nom, com.date_commande from commandes com
join clients c on c.id_client = com.id_client;

-- 2) JOIN à 4 tables : prénom du client, nom du produit, quantité, pour chaque ligne de commande.
--    (clients -> commandes -> lignes_commande -> produits)
select cl.prenom, lc.quantite, p.nom from clients as cl
join commandes as c on cl.id_client = c.id_client
join lignes_commande as lc on c.id_commande = lc.id_commande
join produits as p on lc.id_produit = p.id_produit
order by cl.prenom


-- 3) Reprends la requête 2 + colonne calculée montant_ligne = quantite * prix, triée par montant décroissant.
select cl.prenom, lc.quantite, p.nom, (lc.quantite * p.prix) as montant_ligne from clients as cl
join commandes as c on cl.id_client = c.id_client
join lignes_commande as lc on c.id_commande = lc.id_commande
join produits as p on lc.id_produit = p.id_produit
order by montant_ligne desc


-- 4) Sous-requête scalaire : les produits dont le prix est SUPÉRIEUR à la moyenne des prix.
select p.nom, p.prix
from produits as p 
where p.prix > (select AVG(prix) from produits)

-- 5) Sous-requête IN : les clients (prénom, nom) qui ont AU MOINS une commande.
select distinct cl.prenom, cl.nom from clients as cl -- DISTINCT car j'ai 2 Victor Robalo
join commandes as c on cl.id_client = c.id_client
where id_commande IN (select id_commande from commandes)

-- 6) Sous-requête NOT IN : les clients qui n'ont JAMAIS commandé.
select distinct cl.prenom, cl.nom from clients as cl -- DISTINCT car j'ai 2 Victor Robalo
join commandes as c on cl.id_client = c.id_client
where id_commande NOT IN (select id_commande from commandes)


-- 7) Sous-requête IN : les noms des produits commandés au moins une fois.
--    (indice : id_produit IN (SELECT id_produit FROM lignes_commande))
select p.nom from produits as p -- DISTINCT car j'ai plusieyurs produits commandé plusieurs fois par différents clients
join lignes_commande as lc on p.id_produit = lc.id_produit
where p.id_produit  IN (select id_ligne from lignes_commande)


-- 8) Table dérivée (sous-requête dans le FROM) : par catégorie, le prix maximum ;
--    garder seulement les catégories dont ce maximum dépasse 50.
select *
from (
    select categorie, MAX(prix) as prix_max 
    from produits
    group by categorie
    )
where prix_max > 50



-- 9) Réflexion (en commentaire) : quand préférer un JOIN, et quand une sous-requête ?
-- Un join pour relier et afficher le contenu de plusieurs tables
-- une sous requête pour filtrer a un scalaire
