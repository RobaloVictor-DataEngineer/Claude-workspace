# CLAUDE — Projet 04 Formation Machine Learning

> Complète le `CLAUDE.md` **principal** (racine : profil, ton, préférences, pilotage).
> Deux blocs : **A. MÉTHODE D'APPRENTISSAGE** (générique, identique à mes autres formations) ·
> **B. SPÉCIFIQUE** à cette formation ML.

---

# A. MÉTHODE D'APPRENTISSAGE (générique — tout sujet cours+exercice)

## Principe
Apprendre pour **comprendre et retenir** (réutiliser en entretien et en poste), pas seulement résoudre l'exercice. Utiliser l'IA pour **apprendre**, pas pour faire à ma place.

## Format d'un cours
- **Fiche d'abord** (le concept + un exemple concret, ni trop simple ni trop complexe), **exercices ensuite**.
- **Avant chaque exercice : me dire ce que je dois en retenir** (l'objectif pédagogique).
- **Un seul thème à la fois.**

## Comment j'apprends (pédagogie)
- **Phrase simple d'abord** (langage courant), PUIS un **visuel** : mini tableau **AVANT/APRÈS empilé** (jamais côte à côte), ou comparaison **avec/sans**, ou petit schéma. Jamais la définition technique seule.
- J'accroche avec des **métaphores** et en **lisant le code « comme une phrase »**.
- **Définir chaque acronyme** à sa 1re apparition (ex. ML = Machine Learning). **Code commenté en français**, ligne par ligne si la notion est nouvelle.
- Ne jamais **supposer** que je connais une notion sans l'avoir expliquée au moins une fois.

## Exercices (règles strictes)
- **Couverture cours ⇒ exo (obligatoire).** Tout ce qu'un exercice demande doit **avoir été montré dans la fiche AVANT** (notion, geste, syntaxe). Sens obligatoire **exo ⇒ présent dans le cours** ; l'inverse est optionnel. Avant d'envoyer : vérifier que chaque geste demandé a un exemple en fiche ; sinon, **l'ajouter à la fiche**.
- **Jamais un calque de l'exemple.** Contexte / données **différents** ; énoncé « **question métier** » sans nommer la méthode ; chaque exo **combine ≥ 2 notions**, OU demande de **choisir** l'outil, OU contient un **piège**. Test : « ça se résout en recopiant un exemple en changeant juste un nom ? » → à refaire.
- **Consigne fermée et précise.** JAMAIS « pose-toi une question de ton choix ». Laisser le choix de l'**outil** est bon ; jamais le choix de **quoi faire**. Une seule interprétation par question.
- **Vocabulaire technique exact.** Ne jamais employer un mot vague pour une opération précise.
- **Liberté d'innover à la correction.** Si je fais ce qui est demandé **et/ou mieux**, c'est validé. *(Sauf livrables/projets à spec précise.)*

## Sécurité — NE JAMAIS écraser mon travail
- **Ne jamais régénérer/réécrire from scratch un fichier qui contient MON travail** (notebooks, scripts, livrables) : ça écrase mes réponses. Interdit.
- Toujours **lire** mon fichier d'abord, puis **retouches ciblées** uniquement.
- « Corrige l'exercice X » = **corriger MA copie**, pas réécrire l'énoncé. Si ambigu → demander.
- *(Ne concerne pas les fichiers d'instructions comme ce `CLAUDE.md`.)*

---

# B. SPÉCIFIQUE — Formation Machine Learning

## Objectif
Apprendre les **fondamentaux du Machine Learning** (ML = apprentissage automatique : faire apprendre à un programme à prédire à partir de données) avec **scikit-learn**, dans une optique **data engineer** :
comprendre, entraîner et évaluer un modèle, préparer proprement les données, et surtout **faire le lien ML ↔ data engineering** (pipelines de features, servir un modèle, MLOps). But : renforcer mon profil pour la recherche d'emploi — pas devenir data scientist, mais **savoir dialoguer avec les data scientists et industrialiser leurs modèles**.

## Pré-requis (déjà acquis, à réutiliser)
Python + **pandas complet** (manipulation, `groupby`, `merge`, gestion des NaN…), notebooks `.ipynb`, un peu de stats de base. On s'appuie dessus au lieu de tout réexpliquer.

## Rythme / organisation
- **Théorie (fiche) puis pratique (notebook)**, un seul thème à la fois. Code en notebooks `.ipynb`, commenté en français.
- Chaque grande étape = une « semaine » (`cours/semaine-XX/`). Voir `Programme_ML.md` pour la feuille de route.
- **Mini-projet de synthèse cumulatif** en fin d'étape (même principe que le parcours data engineer).

## Où ranger quoi
- Fiches de cours → `cours/semaine-XX/`, numérotées `01_...`, `02_...`.
- Exercices → `exercices/python/` (notebooks, un fichier par notion, nom `sX_N_theme`) ; questionnaires écrits → `exercices/concepts/`.
- Jeux de données d'entraînement → `data/`.
- Notes de révision → `fiches-revision/`.
- **Projet ML de portfolio** → un dossier `projet-XX-nom/` (README, data/, notebooks/, src/, requirements.txt).

## Fichiers de référence
- Feuille de route : `Programme_ML.md` · Reprise inter-session : `REPRISE.md` (à créer au démarrage de la S1).

## Suivi de ma progression
Si mon niveau ML monte, le **signaler** et proposer d'actualiser mon profil dans le `CLAUDE.md` principal (une ligne « Machine Learning »).
