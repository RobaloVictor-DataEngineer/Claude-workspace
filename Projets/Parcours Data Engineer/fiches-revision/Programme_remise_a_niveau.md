# Programme de remise à niveau express + routine quotidienne

Objectif : passer de **« je connais »** (je reconnais quand je vois) à **« je maîtrise »** (je réécris de
zéro, sans bégayer). Deux outils : un **programme express de 5 jours** pour rattraper S1-S7, puis une
**routine quotidienne** courte à faire **avant toute nouvelle matière**, pour que ça ne reparte jamais.

Ressources utilisées : `Carnet_de_recettes.md` (ton aide-mémoire), `exercices/python/bac_a_sable_entretien.ipynb`
(ton bac à sable), `quiz_journal.md` (tes points faibles), et tes cours/exos existants.

---

## Le principe (pourquoi ça va marcher cette fois)

1. **Écrire de zéro, pas remplir des trous.** Cellule vide → tu produis le code. Carnet autorisé au début.
2. **Espacé + cumulatif.** Chaque jour revoit un peu de l'ancien EN PLUS du nouveau. C'est le retour
   régulier sur le vieux qui bat la courbe de l'oubli (le vrai problème S2-oubliée-en-S8).
3. **Court et quotidien.** 20-40 min/jour battent 4h une fois. La régularité > l'intensité.
4. **Sevrage du carnet.** Motif réécrit avec carnet → puis sans → puis à J+7 sans. Là seulement : maîtrisé.

---

## La routine quotidienne — « l'échauffement » (15-25 min, AVANT de commencer quoi que ce soit)

C'est **le rituel** que tu voulais : à faire chaque jour avant de te lancer dans la formation ou autre chose.

**Étape 1 — Rappel éclair (3-5 min).** Cours ET carnet fermés. 4 questions de mémoire :
- 3 tirées de tes **points faibles** du moment (`quiz_journal.md` → section « Points à retravailler »),
- 1 sur une notion **ancienne au hasard** (pour ne pas la laisser filer).
Tu réponds à voix haute ou par écrit. Ce qui coince → noté.

**Étape 2 — Écriture de code de zéro (10-15 min).** Dans le bac à sable : **2 exos**, en mélangeant
volontairement **1 notion récente + 1 ancienne**. Carnet autorisé si besoin, mais tu essaies d'abord sans.

**Étape 3 — Journal (2 min).** Dans `quiz_journal.md`, une ligne sur ce qui a bloqué. C'est ça qui
alimente le rappel éclair de demain.

➡️ **Puis seulement**, tu passes à ta nouvelle matière / ton travail du jour, la tête déjà « réveillée ».

> Règle d'or : si un jour tu n'as que 15 min, tu fais **juste l'échauffement**. Ne jamais le sauter.
> C'est lui qui fait « rentrer » les choses à la longue.

---

## Le programme express — 5 jours pour re-maîtriser S1→S7

~35-45 min/jour. Chaque jour = l'échauffement appliqué à un thème, en réécrivant **de zéro**.
« NB » = `bac_a_sable_entretien.ipynb`.

### Jour 1 — Python de base + pandas fondamentaux (S1-S2)
- Rappel éclair : liste vs tuple vs set · `.loc`/`.iloc` · `return` vs `print`.
- Code de zéro : NB **A1** ; puis 3 mini gestes au clavier : filtrer, trier, `value_counts()` sur `commandes`.
- Cible : produire un `groupby().sum()` sans hésiter.

### Jour 2 — groupby + OOP + window functions (S3)
- Rappel de J1 (2 questions) + RANK vs DENSE_RANK · LAG vs LEAD.
- Code de zéro : NB **A4** (agg nommé) et NB **B3** (RANK en SQL).
- Cible : `groupby().agg(nom=("col","fonc"))` et une fenêtre `RANK() OVER` de tête.

### Jour 3 — pandas avancé (S4)
- Rappel de J1-J2 (2 questions) + « quand faut-il un merge ? ».
- Code de zéro : NB **A2**, **A3** (merge), puis **A7** (pivot_table).
- Cible : le motif **merge → assign(CA) → groupby** sans regarder.

### Jour 4 — ETL + concepts + modélisation (S5-S6)
- Rappel de J1-J3 (2 questions) + idempotence.
- Oral : **raconte ton pipeline** `extract → transform → load` à voix haute (comme en entretien).
- Code de zéro : NB **B4** (cumul) et **B5** (CTE). Relire vite `projet-01-etl/src/`.
- Cible : réexpliquer ETL vs ELT et le schéma en étoile sans bégayer.

### Jour 5 — Java/Spark + TEST DE MAÎTRISE cumulatif (S7 + tout)
- Rappel de J1-J4 (3 questions) + transformation vs action (Spark).
- Code de zéro **mélangé** : 4 exos tirés au hasard dans le NB, **toutes semaines confondues, sans carnet**.
- C'est le vrai juge de paix : ce que tu réécris seul ici = ce que tu maîtrises vraiment.

Après ces 5 jours, tu **gardes juste l'échauffement quotidien** — c'est l'entretien à vie.

---

## Checklist de maîtrise — « je maîtrise » = 4 cases cochées

Pour chaque motif : coche quand tu l'as (1) revu, (2) réécrit **de zéro avec** carnet, (3) réécrit **sans**
carnet, (4) réécrit **à J+7 sans** carnet. Les **4 cases** = tu peux dire « je maîtrise » sans mentir.

| Motif | Vu | De zéro (carnet) | Sans carnet | À J+7 |
|---|:--:|:--:|:--:|:--:|
| pandas — filtrer + trier | ☐ | ☐ | ☐ | ☐ |
| pandas — colonne calculée (`assign`) | ☐ | ☐ | ☐ | ☐ |
| pandas — `groupby().agg()` | ☐ | ☐ | ☐ | ☐ |
| pandas — `merge` (2 tables) | ☐ | ☐ | ☐ | ☐ |
| pandas — `pivot_table` | ☐ | ☐ | ☐ | ☐ |
| pandas — `nlargest` / top N | ☐ | ☐ | ☐ | ☐ |
| pandas — NaN (`dropna`/`fillna`) + doublons | ☐ | ☐ | ☐ | ☐ |
| SQL — `GROUP BY` + `HAVING` | ☐ | ☐ | ☐ | ☐ |
| SQL — jointures `JOIN ... ON` | ☐ | ☐ | ☐ | ☐ |
| SQL — sous-requête (scalaire/IN/dérivée) | ☐ | ☐ | ☐ | ☐ |
| SQL — window `RANK/ROW_NUMBER/DENSE_RANK` | ☐ | ☐ | ☐ | ☐ |
| SQL — `LAG`/`LEAD` + cumul `OVER` | ☐ | ☐ | ☐ | ☐ |
| SQL — CTE (`WITH`) | ☐ | ☐ | ☐ | ☐ |
| Concepts — ETL/ELT, batch/stream, DWH/lake | ☐ | ☐ | ☐ | ☐ |
| Concepts — étoile (faits/dim/grain) + idempotence | ☐ | ☐ | ☐ | ☐ |
| Concepts — DAG/Airflow + Spark (lazy) | ☐ | ☐ | ☐ | ☐ |

---

*Comment on l'utilise ensemble : tu fais ton échauffement, je te corrige façon jury quand tu me colles ton
code, et on coche la checklist au fur et à mesure. Le jour où une ligne est à 4/4, cette notion est à toi.*
