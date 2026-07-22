# Semaine 6 · Exercice — Modélisation en étoile

> Réponds **par écrit**, sous chaque question. Réponses courtes et précises, comme en entretien.
> Les questions 4 et 5 portent sur **ton projet** (`projet-01-etl`).

---

## Partie A — Faits ou dimension ?

**1.** Pour chacune de ces colonnes, dis si elle appartient plutôt à une table de **faits** (une mesure)
ou à une table de **dimension** (un attribut descriptif). Justifie la 1re et la dernière en une phrase
(le test « est-ce que ça s'additionne ? »).

a) `montant_ttc`
b) `nom_client`
c) `quantite_vendue`
d) `categorie_produit`
e) `ville_magasin`
f) `nombre_articles`

**Réponses** : 

a) `montant_ttc` : faits,

b) `nom_client` : dimension,

c) `quantite_vendue` : faits,

d) `categorie_produit` : dimension,

e) `ville_magasin` : faits,

f) `nombre_articles` : faits


---

## Partie B — Modéliser un cas concret

> Contexte : une chaîne de cinéma veut analyser ses **entrées** (billets vendus). On dispose, pour chaque
> billet : la date et l'heure de la séance, le film (titre, genre, durée), le cinéma (nom, ville), le
> tarif appliqué (plein / réduit / abonné) et le prix payé.

**2.** Propose un schéma en étoile : nomme **la table de faits** et **les tables de dimensions**, et pour
chacune indique les colonnes que tu y mets. (Écris-le en liste, pas besoin de dessin.)

**Réponse** :
- `faits_ventes` : `id_vente`, `id_films`, `id_cinema`, `id_tarif`, `prix_paye`, `date_debut`, `date_fin`
- `dim_film` : `id_films`, `titre`, `genre`, `duree`
- `dim_cinéma` : `id_cinema`, `nom`, `ville` 
- `dim_tarif` : `id_tarif`, `tarif_applique`

**3.** Quel est le **grain** de ta table de faits (que représente une ligne) ? Réponds en une phrase.

**Réponse** : Il est fin, **une ligne = un billet vendu**.

---

## Partie C — Ton projet (`projet-01-etl`)

**4.** Dans ta table `ventes_catalogues_propres`, cite **deux colonnes qui sont des mesures (faits)** et
**trois colonnes qui sont des attributs de dimension**.

**Réponse** :
- Mesures (faits) : `quantite`, `montant`
- Attributs de dimension : `ville`, `nom`, `categorie`

**5.** Si tu remodélisais ton projet proprement en étoile, tu séparerais la grande table en une table de
faits et une dimension produit. Écris, en liste, les colonnes de chacune :

**Réponse** : 
- `faits_ventes` : `ventes_id`, `produit_id`, `quantite`, `montant`, `date`
- `dim_produit` : `produit_id`, `ville`, `nom`, `categorie`, `prix`, `fournisseur_nom`, `fournisseur_pays`

---

## Partie D — Questions d'entretien

**6.** En une phrase : pourquoi choisit-on le grain **le plus fin** utile plutôt qu'un grain déjà agrégé ?

**Réponse** : Parce que si on prend le grain le plus fin on a les infos complètes qu'on peut ensuite modeler en un schéma en étoile par exemple dans le cas précédent si j'aggrège les données pour avoir le montant_total par ville et fournisseur je perds beaucoup d'info.

**7.** En deux phrases : pourquoi un data warehouse en étoile est-il **dénormalisé** (accepte de la
répétition), alors qu'une base d'application cherche au contraire à tout normaliser ?

**Réponse** : une base d'application est normalisée (beaucoup de petites tables reliées) pour écrire vite et sans incohérence alors que l'étoile dénormalise pour lire/analyser vite.
