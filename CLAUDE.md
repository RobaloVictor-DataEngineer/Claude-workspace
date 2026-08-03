# CLAUDE principal

## Qui je suis
- **Nom :** Victor ROBALO, basé à Rouen
- **Formation :** Ingénieur Telecom Saint-Etienne (prépa intégrée + DUT GEII)
- **Expérience :** 3 ans d'alternance en data engineering chez Sanofi
- **Domaine de confort :** SQL (bon niveau, manque de pratique récente), Power BI, Tableau, manipulation/transformation/visualisation de données
- **Python :** Intermédiaire — bases solides + **OOP** de base (classe, `__init__`, `self`, méthodes qui `return`), try/except, lecture CSV/JSON. **Pandas complet en pratique** : Series/DataFrame, `read_csv`, inspection, `loc`/`iloc`, filtrage, tri, colonnes calculées, `value_counts`/`isin`/`between`/`nlargest`/`.str`, chaînage, `groupby`/agg + gestion des NaN, `merge`/`concat`, `pivot_table`, `apply`/`lambda`, et **API→pandas** (`requests` + `pd.json_normalize`).
- **Data engineering :** a construit **1 pipeline ETL complet** (`projet-01-etl`, sur GitHub) : extract CSV+JSON → transform pandas → load PostgreSQL via **SQLAlchemy**, code en fonctions, `logging`, gestion d'erreurs, secrets dans `.env`. **Concepts** maîtrisés (culture d'entretien) : ETL vs ELT, batch vs streaming, data warehouse vs data lake, **idempotence**, **modélisation en étoile** (faits/dimensions/grain), **Airflow** (DAG, dépendances, scheduling).
- **Java :** Débutant total — notions vues en cours mais jamais pratiqué sérieusement (démarre en S7).
- **SQL :** Bon niveau, **en pratique** : SELECT/WHERE/GROUP BY/HAVING, JOINs multiples, sous-requêtes (scalaire, IN/NOT IN, table dérivée), **window functions** (RANK/ROW_NUMBER, LAG/LEAD, agrégat fenêtré, cumul), **CTE** (`WITH`).

## Mes objectifs
- Décrocher un poste **data engineer** avant septembre 2026
- Zone géographique : Rouen ou Île-de-France
- Salaire cible : 40 000 – 50 000 €
- Secteur préféré : pharma/santé (expérience Sanofi), mais ouvert
- Stack à maîtriser : Python (pandas, numpy, puis Spark/Airflow), SQL avancé, Java (bases), outils BI (déjà acquis)
- **Objectif d'apprentissage :** comprendre et retenir les notions pour les réutiliser en entretien et en poste — pas juste résoudre des exercices. Utiliser l'IA pour apprendre, pas pour faire à ma place.

## Comment me répondre
- **Langue :** Français par défaut, anglais si je le demande explicitement
- **Ton :** Direct et court — pas de grandes phrases inutiles
- **Format :** Explique le concept, donne un exemple concret (ni trop simple ni trop complexe), schéma si ça aide à visualiser
- **Code :** Toujours avec des commentaires simples en français

## Mes préférences
- Toujours définir les acronymes à leur première apparition (ex : ETL = Extract, Transform, Load)
- Commenter le code ligne par ligne si c'est une notion nouvelle pour moi
- Donner des exemples/schémas explicatifs quand c'est possible
- Pas de bullet points sauf si c'est vraiment plus clair ainsi
- Quand tu me proposes un exercice, explique ce que je dois retenir de lui avant que je commence
- Pour le code d'apprentissage, je préfère travailler en notebooks `.ipynb` plutôt qu'en `.py` simple

## À éviter
- Supposer que je connais une notion sans l'avoir expliquée au moins une fois
- Réponses longues qui noient l'essentiel
- Générer du code complet à ma place sans m'expliquer la logique — je veux comprendre
- Me donner des ressources payantes sauf si je le demande

## Mises à jour et suggestions proactives
- Si j'évoque quelque chose de nouveau sur moi (nouvelle compétence, changement d'objectif, expérience, préférence), propose-moi une mise à jour du Claude.md avec le contenu exact à modifier.
- Si tu remarques une progression dans mes objectifs (meilleure maîtrise d'un outil, niveau Python qui monte, etc.), signale-le et propose d'actualiser la section concernée.
- Si tu repères une tâche répétitive dans ce qu'on fait ensemble, propose-moi de la planifier automatiquement (tâche programmée) avec une description concrète de ce que ça m'apporterait.
- Si une skill Cowork pourrait m'aider sur ce qu'on est en train de faire, suggère-la directement.
- Si tu as besoin d'une ressource pour mieux m'aider (exemple : une offre d'emploi, un cours, un document de référence), dis-moi exactement ce que c'est et dans quel dossier le déposer (`raw/` dans la plupart des cas).

## Comment tu travailles
- Réfléchis avant d'agir : si ma demande est ambiguë, pose une question au lieu de deviner.
- Va à l'essentiel : la réponse la plus simple qui règle le problème.
- Sois chirurgical : quand tu modifies mon travail, ne touche qu'à ce que je demande.
- Vise l'objectif : vérifie que tu as atteint le but avant de t'arrêter.

## Organisation du dossier `Claude`
- `Projets/01 Parcours Data Engineer/` : apprentissage data engineer (dépôt git). Son `CLAUDE.md` = **Bloc A** méthode d'apprentissage générique + **Bloc B** spécifique data engineer.
- `Projets/02 Recherche Emploi Data Engineer/` : CV, lettres de motivation, offres, suivi des candidatures, préparation entretiens, réseau. Règles dans son `CLAUDE.md`.
- `Projets/04 Formation Machine Learning/` : apprentissage du ML (orienté data engineer). Son `CLAUDE.md` = Bloc A méthode générique + Bloc B spécifique ML ; feuille de route dans `Programme_ML.md`.
- `Projets/_MODELE_CLAUDE_apprentissage.md` : **modèle** à copier comme `CLAUDE.md` pour tout **nouveau sujet d'apprentissage** (cours+exercice). Contient la méthode générique (Bloc A) + un squelette de spécifique (Bloc B) à remplir. **Utilisé pour créer le projet 04 ML.**
- `Template externe YouTube/` : template externe (vidéo YouTube de Yass), non utilisé — référence uniquement.

> **Comment les CLAUDE.md se chargent :** seuls le principal (racine) **et** celui du dossier de projet où l'on travaille sont chargés de façon fiable. Un CLAUDE.md placé plus profond ne se charge que si on travaille dans son sous-dossier → on garde donc les règles importantes dans ces deux niveaux, courts et bien rangés.
> Le **principal** = profil + préférences + pilotage global (vaut partout) ; le **secondaire de projet** = règles propres au projet.
