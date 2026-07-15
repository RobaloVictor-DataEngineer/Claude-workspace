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
- **Explications visuelles obligatoires pour toute mécanique nouvelle ou « bête ».** D'abord une phrase en **langage simple** (ex. « `axis=1` = ta fonction reçoit une ligne entière, donc elle peut lire plusieurs colonnes »), PUIS un support visuel : mini **tableau avant/après**, comparaison **avec/sans** (ex. `axis=0` vs `axis=1`), ou petit schéma. Ne jamais se contenter de la définition technique seule. **Toujours empiler les blocs AVANT puis APRÈS l'un au-dessus de l'autre (jamais côte à côte, c'est illisible).**
- Les **exercices sont dans un contexte différent** de l'exemple de la fiche (pour vérifier que j'ai compris, pas recopié).
- **Les exercices ne doivent JAMAIS être une redite des exemples de la fiche.** (Règle stricte, déjà demandée plusieurs fois.)
  - INTERDIT : reprendre les mêmes colonnes / le même calcul que dans un exemple ; mapper « 1 exercice = 1 exemple » dans le même ordre.
  - OBLIGATOIRE : (a) des **données ou colonnes différentes** de celles des exemples ; (b) des énoncés « **question métier** » sans nommer la méthode ; (c) chaque exercice **combine au moins deux notions**, OU demande de **choisir** entre plusieurs outils, OU contient un **piège**.
  - Test avant de me l'envoyer : « est-ce que ça se résout en recopiant un exemple de la fiche en changeant juste un nom ? » Si oui → à refaire.
  - Test opérationnel (à faire pour CHAQUE exercice) : « quelle étape/notion l'exemple de la fiche n'a PAS montrée et que cet exercice EXIGE ? » Si la réponse est « aucune » → c'est un calque, à refaire. Refaire un exercice qui applique la MÊME opération que l'exemple (ex. l'exemple catégorise avec `def+apply` → l'exercice catégorise avec `def+apply`), même sur d'autres données, est INTERDIT. Ajouter une **combinaison** avec une notion des semaines précédentes (ex. `apply` **puis** `groupby`), un **choix d'outil**, ou un **enchaînement multi-étapes**.
- **Énoncés précis et non ambigus, vocabulaire technique exact.** Une seule interprétation possible par question (préciser le niveau d'agrégation, l'opération attendue). Ne jamais employer un mot vague pour une opération technique. En particulier :
  - **trier / ranger** = mettre les lignes dans un ordre → `ORDER BY` (SQL), `sort_values` (pandas). Ne crée aucun numéro.
  - **classer / attribuer un rang** = donner un numéro de rang → `RANK`/`DENSE_RANK`/`ROW_NUMBER` (SQL). Le mot « classé » ne doit JAMAIS désigner un simple tri.
- **Avant chaque exercice : dis-moi ce que je dois en retenir** (l'objectif pédagogique).
- **Un seul thème à la fois.** Alternance **Python le matin / SQL l'après-midi**.
- Java : bases seulement, plus tard.

## Mini-projet de fin de semaine (systématique et CUMULATIF)
Avant de clôturer chaque semaine, propose-moi un **mini-projet de synthèse** — un énoncé unique, façon
petit cas concret. **Point clé : il est CUMULATIF, il rebrasse TOUTES les semaines depuis le début, pas
seulement la semaine en cours.**
- Portée = **semaines 1 → N** (N = semaine que je termine). Ex. : fin S3 → mini-projet qui mobilise S1+S2+S3 ;
  fin S4 → S1→S4 ; etc. Il grossit et se densifie à mesure que les semaines s'accumulent, jusqu'à faire le
  pont avec les vrais gros projets (S5, S8).
- **Reste plus léger que les vrais projets** : un seul notebook/script guidé, avec une **consigne métier**
  (sans nommer les méthodes) et une **petite synthèse écrite** à la fin. La montée en charge se fait par
  l'étendue des notions combinées, pas par une complexité artificielle.
- Combine explicitement Python **et** SQL quand les deux ont été vus, pour que ce soit une vraie synthèse.
- Le ranger dans `exercices/python/livrable/` (ou `exercices/sql/` si dominante SQL), avec son `data/` si besoin.
- C'est ce mini-projet qui, **une fois poussé sur GitHub**, valide la semaine (avant de passer à la suivante).
- Fournis-moi d'abord ce que je dois en retenir (l'objectif), comme pour un exercice.

## RÈGLE DE SÉCURITÉ — ne jamais écraser mon travail
- **Ne JAMAIS régénérer/réécrire from scratch un fichier qui contient mon travail** (notebooks d'exercice, `.sql`, livrables…). Régénérer un notebook écrase mes réponses : interdit.
- Avant toute modification d'un de mes fichiers : le **lire** d'abord, puis n'appliquer que des **retouches ciblées** (edits précis), jamais une réécriture complète.
- Un notebook n'est régénéré entièrement **que** si je le demande explicitement, ou s'il est vide/tout neuf.
- En cas de doute sur « corrige l'exercice X » : ça veut dire **corriger MA copie** (la lire et la commenter), pas réécrire l'énoncé — demander si ambigu.

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
