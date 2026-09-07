# Semaine 6 · Concepts — La modélisation en étoile (faits & dimensions)

> Comment **organiser les tables** d'un data warehouse pour que les analyses soient rapides et simples ?
> La réponse standard, c'est le **schéma en étoile** : une table centrale d'**événements** (les faits)
> entourée de tables de **contexte** (les dimensions). C'est un grand classique d'entretien, et ta table
> de la S5 en est déjà un embryon.

---

## 1. L'idée en une image

```
                 dim_temps
                     │
   dim_produit ── FAITS_ventes ── dim_client
                     │
                 dim_magasin
```

Au centre, la table de **faits** = les **événements mesurables** (une vente, un clic, une commande).
Autour, les **dimensions** = le **contexte** de ces événements (quel produit, quel client, quel jour,
quel magasin). Reliées par des clés, ça dessine une **étoile** — d'où le nom.

---

## 2. Faits vs dimensions — la distinction clé

**En une phrase :** une table de **faits** contient ce qu'on **mesure** (des nombres qu'on additionne) ;
une table de **dimension** contient ce par quoi on **filtre ou regroupe** (des étiquettes).

| | Table de FAITS | Table de DIMENSION |
|---|---|---|
| Contient | des **mesures** chiffrées (quantité, montant) + des **clés** vers les dimensions | des **attributs descriptifs** (nom, catégorie, ville, pays) |
| Répond à | « combien ? » | « qui / quoi / quand / où ? » |
| Taille | **beaucoup** de lignes (1 par événement) | **peu** de lignes (1 par produit, par client…) |
| Exemple | `faits_ventes` : id_produit, id_client, id_date, quantite, montant | `dim_produit` : id_produit, nom, catégorie, fournisseur |

Test rapide pour trancher : **est-ce que ça s'additionne ?** Si oui (montant, quantité) → c'est une
**mesure**, donc un fait. Si c'est une étiquette (« Bureautique », « Paris ») → c'est une **dimension**.

---

## 3. Le grain — la question à se poser EN PREMIER

Le **grain** d'une table de faits, c'est **ce que représente une ligne**. On le définit avant tout le
reste, parce qu'il détermine tout le modèle.

```
Grain « une ligne = une ligne de commande »   → très fin (le plus courant)
Grain « une ligne = une commande entière »     → plus grossier
Grain « une ligne = le total d'un jour »       → agrégé
```

Règle : on choisit le grain **le plus fin utile**, parce qu'on peut toujours agréger un grain fin
(sommer par jour), mais jamais **détailler** un grain grossier (on a perdu l'info). En entretien,
« quel est le grain de ta table de faits ? » est une question fréquente.

---

## 4. Les clés qui relient l'étoile

Chaque dimension a une **clé primaire** (ex. `id_produit`). La table de faits stocke ces clés comme
**clés étrangères** : c'est elles qui raccrochent chaque événement à son contexte.

```
faits_ventes                          dim_produit
┌──────────────┐                      ┌───────────────────────────┐
│ id_produit ●─┼──────────────────────► id_produit (clé primaire) │
│ id_client    │                      │ nom, categorie, prix      │
│ id_date      │                      └───────────────────────────┘
│ quantite     │
│ montant      │       Analyser = joindre les faits aux dimensions
└──────────────┘       (le JOIN que tu connais déjà)
```

Analyser, c'est **joindre** les faits aux dimensions : « CA par catégorie » = `faits_ventes` JOIN
`dim_produit`, puis `GROUP BY categorie`. Exactement ce que tu fais depuis la S3.

---

## 5. Pourquoi ce modèle (et pas juste « tout normaliser ») ?

En base **transactionnelle** (celle d'une appli), on **normalise** à fond : on évite toute répétition,
les données sont éclatées en beaucoup de petites tables. C'est parfait pour **écrire** vite et sans
incohérence.

Le schéma en étoile fait **l'inverse** : il **dénormalise** un peu (une dimension regroupe plusieurs
niveaux, ex. produit + catégorie + fournisseur dans une seule `dim_produit`). On accepte un peu de
répétition **en échange de requêtes analytiques simples et rapides** : moins de jointures, un modèle
qu'un analyste comprend d'un coup d'œil.

| | Base transactionnelle (normalisée) | Data warehouse (étoile, dénormalisé) |
|---|---|---|
| Optimisé pour | écrire (transactions) | **lire / analyser** |
| Nb de tables | beaucoup | peu (faits + quelques dimensions) |
| Jointures pour analyser | nombreuses | peu |

---

## 6. Ton projet vu comme une étoile

Ta table `ventes_catalogues_propres` (S5) est en fait une étoile **déjà aplatie en une seule table** :

```
Les MESURES (faits)          : quantite, montant
Les clés / dimensions        : produit_id → (nom, categorie, prix, fournisseur_nom, fournisseur_pays)
                               ville, date
```

Proprement modélisé, tu aurais : `faits_ventes` (vente_id, produit_id, date, ville, quantite, montant)
au centre, et `dim_produit` (produit_id, nom, categorie, prix, fournisseur_nom, fournisseur_pays) autour.
Ta jointure de la phase Transform (`ventes` ⋈ `catalogue`), c'est littéralement **relier un fait à sa
dimension produit**.

---

## 7. À retenir

- **Schéma en étoile** = 1 table de **faits** au centre + des tables de **dimensions** autour, reliées par des clés.
- **Fait** = ce qu'on **mesure** (s'additionne : quantité, montant) ; **dimension** = ce par quoi on **filtre/regroupe** (étiquettes : catégorie, ville).
- **Grain** = ce que représente une ligne de faits ; le définir **en premier**, choisir le plus **fin** utile.
- **Dénormalisé** exprès : un peu de répétition contre des analyses simples et rapides (≠ base transactionnelle normalisée).
- Analyser une étoile = **joindre** faits + dimensions puis `GROUP BY` (ce que tu sais déjà faire).

---

## 8. Exercice

> **Ce que tu dois en retenir :** regarder un jeu de données et savoir **découper** ce qui est mesure
> (fait) de ce qui est contexte (dimension), fixer le **grain**, et dessiner l'étoile. C'est un exercice
> d'entretien très courant. Réponds par écrit dans `exercices/concepts/s6_2_modelisation_etoile.md`.

---

*Dernier thème de la S6 : **Airflow** — orchestrer et planifier un pipeline (DAG, tâches, ordre d'exécution).*
