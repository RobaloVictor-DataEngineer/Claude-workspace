# Parcours Data Engineer — Victor Robalo

Espace de travail unique pour tous mes projets et exercices.
Planning détaillé dans `Programme_Data_Engineer.docx`, suivi hebdo dans `Planning_Data_Engineer.xlsx`.

## Comment je m'organise (règle anti-éparpillement)
- **1 dossier = 1 projet.** Je ne mélange jamais deux projets.
- **Nouveau projet ?** Je copie `_TEMPLATE_PROJET/`, je le renomme `projet-XX-nom`, je remplis son README.
- **Les exercices** (entraînement) vont dans `exercices/`, jamais dans un projet.
- **Chaque vendredi** : je commite la semaine sur GitHub et je mets à jour le tracker Excel.

## Contenu
| Dossier | Quoi |
|---|---|
| `_TEMPLATE_PROJET/` | Modèle à dupliquer pour chaque nouveau projet |
| `projet-01-etl/` | 1er pipeline ETL — Semaine 5 |
| `projet-02-portfolio/` | Projet portfolio orchestré — Semaine 8 |
| `exercices/` | Entraînement Python / SQL / Java |
| `fiches-revision/` | Mes notes pour les entretiens |

## Structure type d'un projet
```
projet-XX-nom/
├── README.md          <- objectif, comment lancer, ce que j'ai appris
├── data/raw/          <- données brutes (jamais modifiées)
├── data/processed/    <- données transformées (générées par le code)
├── src/               <- code Python (extract / transform / load)
├── sql/               <- requêtes SQL
├── notebooks/         <- exploration Jupyter
├── requirements.txt   <- bibliothèques à installer
└── .gitignore
```
