-- ============================================================
--  Semaine 4 · SQL — Les CTE (WITH ... AS)
--  Base : boutique (relancer cours/semaine-01/setup_boutique.sql si besoin)
--  Rappel : montant d'une ligne = quantite * prix (lignes_commande JOIN produits)
--
--  Écris ta requête sous chaque énoncé, commente-la.
--  À toi de structurer avec WITH — choisis la version la plus lisible.
-- ============================================================

-- 1) CA de chaque client (somme de quantité * prix sur ses commandes) ;
--    n'affiche que les clients dont le CA dépasse 150. (une étape intermédiaire nommée)
WITH ca_clients_table AS (
    select c.id_client, SUM(lc.quantite * p.prix) as ca_client 
    from clients c
    join commandes co on c.id_client = co.id_client
    join lignes_commande lc on co.id_commande = lc.id_commande
    join produits p on lc.id_produit = p.id_produit
    group by c.id_client
)
select * 
from ca_clients_table
where ca_client > 150;

-- 2) En repartant du CA par client : prénom + nom + CA des clients
--    dont le CA est SUPÉRIEUR au CA moyen de tous les clients.
with ca_client_table_2 AS (
    select c.nom, c.prenom, SUM(p.prix * lc.quantite) as ca_client
    from clients c 
    join commandes co on c.id_client = co.id_client
    join lignes_commande lc on co.id_commande = lc.id_commande
    join produits p on lc.id_produit = p.id_produit
    group by c.nom, c.prenom
),
moyenne_ca_client AS (
    select AVG(ca_client) as ca_moyen
    from ca_client_table_2
)
select * -- ou  SELECT cct2.nom, cct2.prenom, cct2.ca_client from... pour ne pas afficher le ca_moyen (vérification)
from ca_client_table_2 cct2
cross join moyenne_ca_client
where cct2.ca_client > ca_moyen;


-- 3) [énoncé reformulé — l'ancien mot « classé » était ambigu : il pouvait dire "trier" OU "attribuer un rang"]

-- 3a) TRIER (le sens visé) : calcule le CA total des clients de CHAQUE VILLE (une ligne par ville),
--     puis TRIE les villes du CA le plus élevé au plus faible.
WITH ca_client AS (
    select c.id_client, c.ville, SUM(lc.quantite * p.prix) as ca_client
    from clients c
    join commandes co on c.id_client = co.id_client
    join lignes_commande lc on co.id_commande = lc.id_commande
    join produits p on lc.id_produit = p.id_produit
    group by c.id_client, c.ville
)
select ville, SUM(ca_client) as ca_ville
from ca_client
group by ville
order by ca_ville desc;              -- ORDER BY = TRIER les villes (pas de rang créé)

-- 3b) CLASSER : dans chaque ville, attribue un RANG aux clients selon leur CA.
--     (ta version d'origine — parfaitement valable pour cette autre lecture)
WITH ca_clients_table AS (
    select c.ville, c.id_client, SUM(lc.quantite * p.prix) as ca_client
    from clients c
    join commandes co on c.id_client = co.id_client
    join lignes_commande lc on co.id_commande = lc.id_commande
    join produits p on lc.id_produit = p.id_produit
    group by c.id_client
),
rank_ca AS (
    select *,
           RANK() OVER(PARTITION BY cct.ville order by cct.ca_client desc) as rang
    from ca_clients_table cct
)
select *
from rank_ca;

-- 4) Par catégorie de produit, le produit qui rapporte le plus de CA.
--    (indice : classe les produits par CA dans chaque catégorie, puis garde le 1er —
--     et souviens-toi où l'on peut filtrer un classement)

WITH ca_produits AS (
    select p.categorie, p.nom, SUM(lc.quantite * p.prix) as ca_produit
    from produits p 
    join lignes_commande lc on p.id_produit = lc.id_produit
    group by p.categorie, p.nom
    order by p.categorie
), 
rank_ca AS (
    select *,
           RANK() OVER (PARTITION BY cap.categorie order by cap.ca_produit desc) as rang_produit
    from ca_produits cap
)
select rca.categorie, rca.nom , rca.ca_produit 
from rank_ca rca
where rca.rang_produit = 1
order by rca.ca_produit desc;

-- 5) Réflexion (en commentaire) : qu'apporte une CTE par rapport à une sous-requête
--    imbriquée dans le FROM ?
--
