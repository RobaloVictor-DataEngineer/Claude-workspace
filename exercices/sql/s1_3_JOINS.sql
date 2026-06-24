-- Q0 (initialisation)
INSERT INTO clients (prenom, nom, ville, date_inscription) VALUES ('Emma', 'Roux', 'Bordeaux', '2025-06-01');

-- Q1 
select * from lignes_commande;
select * from produits p;

select p.nom, SUM(lc.quantite)
from lignes_commande lc 
inner join produits p on p.id_produit = lc.id_produit
group by p.nom;


-- Q2
select cl.prenom, cl.ville, c.date_commande 
from commandes c 
inner join clients cl on cl.id_client = c.id_client;

-- Q3
select cl.prenom, c.id_commande 
from clients cl
left join commandes c on cl.id_client = c.id_client;

-- Q4 
-- Si jamais on remplace left join par inner join alors Emma n'apparaitra pas
-- car elle n'a pas de commandes et comme inner prend les correspondance dans les 2 tables
-- alors Emma n'apparaitra pas 

-- Q5
select cl.prenom, p.nom 
from clients cl
inner join commandes c on c.id_client = cl.id_client
left join lignes_commande lc on lc.id_commande = c.id_commande 
left join produits p on p.id_produit = lc.id_produit; 

-- Comme de ce que j'ai vu il n'y a qu'Emma qui n'a pas de commande donc pas de produit
