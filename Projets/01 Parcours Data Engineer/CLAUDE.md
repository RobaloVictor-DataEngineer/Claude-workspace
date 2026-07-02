# CLAUDE secondaire — Projet 01 Parcours Data Engineer

> Ce fichier complète le `CLAUDE.md` principal (racine du dossier `Claude`), qui contient mon profil,
> mon ton et mes préférences. Ici, **uniquement les règles propres à mon apprentissage data engineer**.
> Dépôt git : commit chaque vendredi + mise à jour du tracker Excel.

## Objectif du dossier
Apprendre le métier de **data engineer** (= ingénieur de la donnée : construire les pipelines qui collectent,
transforment et stockent les données pour les rendre exploitables). But : comprendre et **retenir** pour
réutiliser en entretien et en poste — pas seulement résoudre l'exercice.

## Format d'un cours (à respecter sans me le demander)
- **Fiche d'abord, exercices ensuite.** La fiche explique le concept + un exemple concret (ni trop simple, ni trop complexe).
- Les **exercices sont dans un contexte différent** de l'exemple de la fiche (pour vérifier que j'ai compris, pas recopié).
- **Les exercices ne doivent pas calquer les exemples de la fiche** : énoncés formulés comme des questions métier, sans nommer la méthode à employer, avec si possible un piège ou une combinaison de notions, pour me forcer à *choisir* l'outil et pas à recopier le motif.
- **Avant chaque exercice : dis-moi ce que je dois en retenir** (l'objectif pédagogique).
- **Un seul thème à la fois.** Alternance **Python le matin / SQL l'après-midi**.
- Java : bases seulement, plus tard.

## Mini-projet de fin de semaine (systématique)
Avant de clôturer chaque semaine, propose-moi un **mini-projet de synthèse** — un énoncé unique, façon
petit cas concret, qui me fait **réutiliser l'ensemble des notions de la semaine** (et idéalement en
rebrasser des précédentes). Sur le modèle du livrable S2 (notebook d'analyse exploratoire).
- **Léger**, pas un vrai projet : reste bien en-dessous des vrais projets (S5, S8). Un seul notebook/script
  guidé, avec une **consigne métier** (sans nommer les méthodes) et une **petite synthèse écrite** à la fin.
- Le ranger dans `exercices/python/livrable/` (ou `exercices/sql/` si le thème de la semaine est SQL),
  avec son `data/` si besoin.
- C'est ce mini-projet qui, **une fois poussé sur GitHub**, valide la semaine (avant de passer à la suivante).
- Fournis-moi d'abord ce que je dois en retenir (l'objectif), comme pour un exercice.

## Où ranger quoi (maintiens l'arborescence au fil de l'eau)
- Fiches de cours → `cours/semaine-XX/`, numérotées `01_...`, `02_...` (ex : `03_python_fonctions.md`).
- Exercices → `exercices/python|sql|java/`, **un fichier par notion** (ex : `s1_2_fonctions.ipynb`).
  Convention de nom : `sX_N_theme` (X = semaine, N = ordre dans la semaine).
- **Livrables de fin de semaine** (≠ simples exercices) → sous-dossier dédié `exercices/python/livrable/`
  (avec son `data/` si besoin), pour ne pas les mélanger aux exercices d'entraînement.
- Notes d'entretien / révisions → `fiches-revision/`.
- **Nouveau projet** → dupliquer `_TEMPLATE_PROJET/`, renommer `projet-XX-nom`, remplir son README.
  Règle anti-éparpillement : **1 dossier = 1 projet**, jamais deux projets mélangés. Les exercices ne vont jamais dans un projet.
- Crée d'emblée les dossiers/fichiers nécessaires à chaque nouvelle étape, sans attendre que je le demande.

## Structure type d'un projet (`projet-XX-nom/`)
`README.md` (objectif, comment lancer, ce que j'ai appris) · `data/raw/` (brut, jamais modifié) ·
`data/processed/` (généré par le code) · `src/` (Python extract/transform/load) · `sql/` ·
`notebooks/` (exploration) · `requirements.txt` · `.gitignore`.

## Code (rappel, détaillé dans le principal)
- Commentaires simples **en français**, ligne par ligne si c'est une notion nouvelle pour moi.
- Ne génère pas tout le code à ma place sans m'expliquer la logique : je veux comprendre.
- Définis chaque acronyme à sa première apparition (ex : ETL = Extract, Transform, Load).
- **Correction des exercices — liberté d'innover.** Sur un simple exercice, je n'ai pas à faire
  *exactement* ce qui est demandé : si je fais ce qui est demandé **et/ou mieux**, c'est validé.
  Exemples : ajouter un `finally` à un `try/except` demandé seul ; un texte différent mais qui
  reflète la même idée ; renvoyer `type(a), a` au lieu de `a` parce que ça garantit le type.
  Ne me reproche pas un écart à la consigne tant que la notion visée est maîtrisée et le résultat
  équivalent ou supérieur. (Ne s'applique pas aux livrables/projets où une spec précise est exigée.)

## Fichiers de référence
- Suivi hebdo : `Planning_Data_Engineer.xlsx`.
- Vision d'ensemble du programme : `Programme_Data_Engineer.docx`.
- Base SQL réutilisable pour les exercices : `cours/semaine-01/setup_boutique.sql`.

## Suivi de ma progression
Si tu vois que mon niveau monte (pandas en pratique, OOP, try/except acquis, SQL avancé...),
signale-le et propose de mettre à jour la section « Qui je suis » du `CLAUDE.md` principal.
