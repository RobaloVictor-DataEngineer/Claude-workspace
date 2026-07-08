-- ============================================================
--  Semaine 3 · SQL — Window functions (fonctions de fenêtrage)
--  Base : boutique (relancer cours/semaine-01/setup_boutique.sql si besoin)
--  Tables clés : produits (nom, categorie, prix), commandes (date_commande)
--
--  Écris ta requête sous chaque énoncé, commente-la en une ligne.
--  À toi de choisir la bonne fonction — rien n'est imposé.
-- ============================================================


-- 1) Pour chaque catégorie, classe les produits du plus cher au moins cher
--    et donne-leur un numéro de classement (1 = le plus cher de sa catégorie).
select nom, categorie, prix, 
    RANK() over (partition by categorie order by prix desc) AS "Rang"
    from produits;

-- On affiche le prix des produit pour chaque categorie, avec RANK() et le partition by 
-- Grâce au order by on trie les prix du + cher au - cher et donc ça définit correctemen,t le rang comme demandé
-- étant donné que je suis de la team "Si y'a 2 ex-aequo la personne après saute d'une place en dessous" d'où le RANK() et DENSE_RANK()

-- 2) Affiche chaque produit avec, sur la même ligne, le prix moyen de sa catégorie.
select nom, 
       AVG(prix) over (partition by categorie) as avg_categorie
from produits;


-- 3) Ajoute une colonne montrant de combien chaque produit s'écarte du prix moyen
--    de sa catégorie (positif = plus cher que la moyenne).
select nom, prix,
       AVG(prix) over (partition by categorie) as prix_moyen,
       prix - AVG(prix) over (partition by categorie) as "Ecart prix vs avg"
from produits;


-- 4) Liste les commandes par date, avec le nombre cumulé de commandes depuis la première.
select id_commande, date_commande,
       COUNT(*) over (order by date_commande) as cumul_commandes
from commandes;

-- 5) Pour chaque commande, affiche la date de la commande précédente
--    et le nombre de jours écoulés depuis. (indice : regarder la ligne d'avant)
select id_commande, date_commande,
       LAG(date_commande) over (partition by id_client order by date_commande) AS "Date de dernière commande",
       date_commande - (LAG(date_commande) over (partition by id_client order by date_commande)) as "Nb de jours écoulées"
from commandes;


-- 6) Ne garde que les 2 produits les plus chers de chaque catégorie.
--    (indice : classe-les d'abord, puis filtre le classement dans une sous-requête —
--     on ne peut pas filtrer une window function directement dans un WHERE)
select * from (
                SELECT nom, categorie, prix,
                       RANK() over (partition by categorie order by prix desc) as classement_prix
                from produits
              ) as s
where s.classement_prix < 3;


-- 7) Réflexion (en commentaire) : différence entre GROUP BY et une window function ?
-- GROUP BY d'une colonne va afficher une seule ligne par valeur dans la colonne + la/les aggrégation(s) (avg, count, etc.) 
-- Windows function va garder toutes les données mais va quand même faire le calcul d'aggégat
