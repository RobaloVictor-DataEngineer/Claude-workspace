-- Q1
select * from commandes c 
where c.id_client = 1;

-- Q2
create table fournisseurs (
	id_fournisseur serial primary key,
	nom varchar(50) not null,
	ville varchar(50),
	email varchar(50) unique 
	);

select * from fournisseurs;

-- Q3
alter table produits add column stock integer;
select * from produits;
-- Q4

delete from produits p where p.id_produit = 4; -- syntaxe bonne mais comme la colonne est une référence on ne peut la supprimer comme ça
                                               -- il faudrait supprimer toutes les autres références.
select * from produits;

-- Q5
-- Dans clients, id_client est la PK ; dans commandes, id_client est une FK qui pointe vers elle. 
-- On évite de recopier nom et ville (c'est la normalisation) : l'info vit à un seul endroit, donc si elle change on corrige une seule ligne et on évite les incohérences.