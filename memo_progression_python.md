# Mémo de progression — Python (parcours data engineer de Victor)

> **À lire en début de conversation.** Ce mémo résume où en est Victor en Python pour qu'on reprenne
> sans répéter ce qui est acquis. Profil complet et préférences dans le CLAUDE.md. Suivi des semaines
> dans `Planning_Data_Engineer.xlsx`.

## Contexte
- Parcours data engineer, **Semaine 1** démarrée le 19/06/2026 (~15-20h/sem), objectif : poste avant sept. 2026.
- Format des cours : **fiche puis exercices**, en **alternant Python (matin) / SQL (après-midi)**, un seul thème à la fois.
- Les fiches sont dans `cours/semaine-01/`, les exercices de Victor dans `exercices/python/`.

## Ce qui marche pour lui (pédagogie)
- Expliquer le concept, un **exemple concret**, et un **schéma** si ça aide.
- Il retient mieux avec des **métaphores en langage courant** et en **lisant le code comme une phrase**
  (sa méthode perso : la liste = une « boîte », chaque élément = une « feuille » ; `for e in boite` = « pour chaque feuille dans la boîte »).
- **Les exercices doivent porter sur un contexte DIFFÉRENT des exemples** (sinon il recopie au lieu de transférer — il l'a explicitement demandé).
- Commentaires de code **en français** ; commenter **ligne par ligne** quand la notion est nouvelle.
- Il veut **comprendre, pas qu'on fasse à sa place** : on explique la logique, on ne donne pas la solution toute faite. On le laisse chercher, puis on corrige.

## Notions Python couvertes en Semaine 1

### 1. Structures de données & comprehensions — MAÎTRISÉ
- Fiche : `cours/semaine-01/01_python_structures_comprehensions.md` · Exos : `exercices/python/s1_comprehensions.ipynb`
- Couvert : listes, dicts, list/dict comprehensions, filtrage avec `if`.
- Erreur corrigée (acquise depuis) : au début il réutilisait la **liste entière** dans l'expression au lieu de la **variable de boucle** (`[employes["prenom"] for n in employes]` → `[e["prenom"] for e in employes]`).
- Les 5 exercices : tous corrects.

### 2. Les fonctions — MAÎTRISÉ
- Fiche : `cours/semaine-01/03_python_fonctions.md` · Exos : `exercices/python/s1_fonctions.ipynb`
- Couvert : paramètre vs argument, valeurs par défaut, arguments nommés, renvoyer plusieurs valeurs (tuple + déballage), **`return` vs `print`**, docstring.
- Les 5 exercices : tous corrects. Rappels de style donnés : nom de variable de boucle **cohérent** (`e` partout), **pas d'espaces** autour du `=` pour un paramètre par défaut (`tva=0.20`).

### 3. Gestion d'erreurs `try/except` — FICHE FAITE, CORRECTION EN ATTENTE
- Fiche : `cours/semaine-01/06_python_try_except.md` · Exos : `exercices/python/` (fichier try/except)
- Couvert dans la fiche : pourquoi (robustesse des pipelines), structure `try/except`, types d'erreurs courants (`ValueError`, `ZeroDivisionError`, `FileNotFoundError`, `KeyError`, `TypeError`), `as e`, `else`/`finally`, et la bonne pratique de **cibler le type précis** (jamais d'`except:` nu).
- **Statut : Victor a fait les exercices, mais ils n'ont pas encore été corrigés** (souci de synchro OneDrive au moment de la session). → À corriger en priorité quand on reprend.

## Rappel du niveau Python de départ (pour situer)
Intermédiaire-débutant : maîtrise les bases (fonctions, boucles, dicts, f-strings, while, input).
Au démarrage : pas encore pandas en pratique, pas d'OOP (programmation orientée objet), pas de try/except.
→ Depuis : comprehensions et fonctions consolidées, try/except introduit.

## Ce qui reste en Python (Semaine 1 et après)
- **Immédiat** : corriger ses exercices `try/except`.
- **Fin Semaine 1** : les modules (`import`), puis le **livrable** = un script Python qui lit un CSV.
- **Semaine 2+** : pandas (Series/DataFrame, filtrage, groupby, merge), puis OOP.
