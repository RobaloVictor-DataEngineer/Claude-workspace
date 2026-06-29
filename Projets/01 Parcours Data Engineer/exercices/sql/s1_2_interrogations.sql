-- Q1 
SELECT prenom, ville 
FROM clients AS c 
ORDER by ville; -- pas de précision sur le tri donc je trie en fonction de l'ordre de selection des colonnes


-- Q2
SELECT * 
FROM commandes cd
WHERE date_commande > '2025-04-01'
ORDER BY date_commande desc;

-- Q3
SELECT COUNT(*)
from clients c
WHERE  ville = 'Rouen'
;

-- Q4
SELECT ville, count(prenom)
from clients c
GROUP BY ville;



-- Q5
SELECT ville, count(prenom)
from clients c
GROUP BY ville
HAVING count(prenom) >= 2;

-- Q6 
select id_produit, sum(quantite)
from lignes_commande
GROUP BY id_produit
ORDER BY sum(quantite) DESC

