-- Vérification post-chargement (à exécuter dans DBeaver, après avoir lancé le pipeline)
-- Objectif : confirmer que la table ventes_propres a bien été créée et remplie.

-- TODO 1 : compter le nombre de lignes de ventes_propres.
select count(*) from ventes_catalogues_propres

-- TODO 2 : afficher le chiffre d'affaires total par ville (somme des montant, trié décroissant).
select ville, sum(montant) as CA_total
from ventes_catalogues_propres
group by ville
order by sum(montant) desc

