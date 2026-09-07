# CLAUDE — Projet 01 Parcours Data Engineer

> Complète le `CLAUDE.md` **principal** (racine : profil, ton, préférences, pilotage).
> Deux blocs ci-dessous :
> - **A. MÉTHODE D'APPRENTISSAGE** — *générique*, vaut pour **tout sujet en cours+exercice** (copiée pour les futurs projets d'apprentissage via `Projets/_MODELE_CLAUDE_apprentissage.md`).
> - **B. SPÉCIFIQUE** à ce projet (data engineer).

---

# A. MÉTHODE D'APPRENTISSAGE (générique — tout sujet cours+exercice)

## Principe
Apprendre pour **comprendre et retenir** (réutiliser en entretien et en poste), pas seulement résoudre l'exercice. Utiliser l'IA pour **apprendre**, pas pour faire à ma place.

## Format d'un cours
- **Fiche d'abord** (le concept + un exemple concret, ni trop simple ni trop complexe), **exercices ensuite**.
- **Avant chaque exercice : me dire ce que je dois en retenir** (l'objectif pédagogique).
- **Un seul thème à la fois.**

## Comment j'apprends (pédagogie)
- **Phrase simple d'abord** (langage courant), PUIS un **visuel** : mini tableau **AVANT/APRÈS empilé** (jamais côte à côte, illisible), ou comparaison **avec/sans**, ou petit schéma. Jamais la définition technique seule.
- J'accroche avec des **métaphores** et en **lisant le code « comme une phrase »** (ex. liste = « boîte », élément = « feuille », `for e in boite` = « pour chaque feuille dans la boîte »).
- **Définir chaque acronyme** à sa 1re apparition (ex. ETL = Extract, Transform, Load). **Code commenté en français**, ligne par ligne si la notion est nouvelle.
- Ne jamais **supposer** que je connais une notion sans l'avoir expliquée au moins une fois.

## Exercices (règles strictes)
- **Couverture cours ⇒ exo (obligatoire).** Tout ce qu'un exercice demande de faire doit **avoir été montré dans la fiche AVANT** (chaque notion, geste, syntaxe). Sens obligatoire **exo ⇒ présent dans le cours** ; l'inverse (cours ⇒ exo) est seulement optionnel, si pertinent. Avant d'envoyer un exo : vérifier que chaque geste demandé a un exemple équivalent en fiche ; sinon, **l'ajouter à la fiche**.
- **Jamais un calque de l'exemple.** Contexte / données / colonnes **différents** ; énoncé « **question métier** » sans nommer la méthode ; chaque exo **combine ≥ 2 notions**, OU demande de **choisir** l'outil, OU contient un **piège**. Tests avant envoi : (1) « ça se résout en recopiant un exemple en changeant juste un nom ? » → à refaire ; (2) « quelle étape que l'exemple n'a PAS montrée cet exo exige-t-il ? » → si « aucune », c'est un calque.
- **Consigne fermée et précise.** JAMAIS « pose-toi une question de ton choix / surprends-moi ». Laisser le choix de l'**outil/méthode** est bon ; jamais le choix de **quoi faire**. Une seule interprétation possible par question.
- **Vocabulaire technique exact.** *trier / ranger* = mettre dans un ordre (`ORDER BY`, `sort_values`) — aucun rang créé. *classer / attribuer un rang* = numéroter (`RANK`/`DENSE_RANK`/`ROW_NUMBER`). Le mot « classé » ne désigne **jamais** un simple tri.
- **Liberté d'innover à la correction.** Sur un simple exercice, si je fais ce qui est demandé **et/ou mieux**, c'est validé (ex. un `finally` en plus ; `type(a), a` au lieu de `a`). Pas de reproche tant que la notion visée est maîtrisée et le résultat équivalent ou supérieur. *(Ne s'applique pas aux livrables/projets à spec précise.)*

## Sécurité — NE JAMAIS écraser mon travail
- **Ne jamais régénérer/réécrire from scratch un fichier qui contient MON travail** (notebooks d'exercice, `.sql`, livrables) : ça écrase mes réponses. Interdit.
- Toujours **lire** mon fichier d'abord, puis **retouches ciblées** uniquement.
- « Corrige l'exercice X » = **corriger MA copie** (la lire et la commenter), pas réécrire l'énoncé. Si ambigu → demander.
- *(Ne concerne pas les fichiers d'instructions comme ce `CLAUDE.md`, que je peux te demander de réorganiser.)*

---

# B. SPÉCIFIQUE — Parcours Data Engineer

## Objectif
Apprendre le métier de **data engineer** (ingénieur de la donnée : construire les pipelines qui collectent, transforment et stockent les données). Dépôt git : **commit chaque vendredi** + mise à jour du tracker Excel.

## Rythme
- Alternance **Python le matin / SQL l'après-midi**. Java : bases seulement, plus tard.

## Mini-projet de fin de semaine (systématique et CUMULATIF)
- Avant de clôturer une semaine : un **mini-projet de synthèse**, **cumulatif S1 → N** (rebrasse **toutes** les semaines depuis le début, pas seulement la courante). Il grossit et se densifie au fil des semaines.
- **Plus léger** qu'un vrai projet : un seul notebook/script guidé, **consigne métier**, **petite synthèse écrite** à la fin. La montée en charge vient de l'**étendue des notions combinées**, pas d'une complexité artificielle.
- Combine **Python ET SQL** dès que les deux ont été vus. À ranger dans `exercices/python/livrable/` (ou `exercices/sql/` si dominante SQL). **Valide la semaine** une fois **poussé sur GitHub**.

## Où ranger quoi (maintiens l'arborescence au fil de l'eau)
- Fiches de cours → `cours/semaine-XX/`, numérotées `01_...`, `02_...` (ex. `03_python_fonctions.md`).
- Exercices → `exercices/python|sql|java/` (+ `exercices/concepts/` pour les questionnaires écrits), **un fichier par notion**, nom `sX_N_theme` (X = semaine, N = ordre). *En Java, le fichier porte le nom de la classe (ex. `Produit.java`).*
- Livrables de fin de semaine → `exercices/python/livrable/` (avec son `data/`).
- Notes d'entretien / révisions → `fiches-revision/`.
- **Nouveau projet code** → dupliquer `_TEMPLATE_PROJET/`, renommer `projet-XX-nom`, remplir son README. **1 dossier = 1 projet** ; les exercices ne vont jamais dans un projet.
- Créer d'emblée les dossiers/fichiers nécessaires à chaque étape, sans attendre que je le demande.

## Structure type d'un projet code (`projet-XX-nom/`)
`README.md` (objectif, comment lancer, ce que j'ai appris) · `data/raw/` (brut, jamais modifié à la main) · `data/processed/` (généré) · `src/` · `sql/` · `notebooks/` · `requirements.txt` · `.gitignore`.

## Fichiers de référence
- Suivi hebdo : `Planning_Data_Engineer.xlsx` · Vision d'ensemble : `Programme_Data_Engineer.docx` · **Reprise inter-PC : `REPRISE.md`** · Base SQL réutilisable pour les exercices : `cours/semaine-01/setup_boutique.sql`.

## Suivi de ma progression
Si mon niveau monte (nouvel outil en pratique, notion acquise…), le **signaler** et proposer d'actualiser la section « Qui je suis » du `CLAUDE.md` principal **et** `REPRISE.md`.
