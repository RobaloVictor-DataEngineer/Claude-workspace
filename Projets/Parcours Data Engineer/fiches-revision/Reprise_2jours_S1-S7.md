# Reprise en 2 jours — S1 à S7 (+ méthode pour retenir vite et longtemps)

Tu reviens après 1 mois. Bonne nouvelle : ce n'est pas perdu, c'est **endormi**. On ne va pas
tout relire (inefficace) — on va **réveiller** les réflexes avec la bonne méthode. Rythme : **4h/jour**,
deux jours. Chaque bloc se fait de mémoire d'abord, cours fermé.

---

## PARTIE 1 — La méthode pour retenir (à lire en premier, 10 min)

### Le principe qui change tout : se tester, pas relire
Relire un cours ou surligner donne l'**illusion** de savoir : ça reconnaît, ça ne restitue pas.
Ce qui grave une notion, c'est l'**effort de la retrouver de mémoire**. On appelle ça le **rappel actif**
(*active recall*). Règle simple : **cours fermé, tu réponds ; ensuite seulement tu vérifies.**

### Les 4 leviers, par ordre d'impact

1. **Rappel actif** — te poser une question et y répondre sans regarder. Chaque question de la Partie 3
   sert à ça. Si tu sèches 10s, tu ouvres le cours, tu notes le trou, tu refermes, tu re-réponds.

2. **Répétition espacée** (*spaced repetition*) — revoir à intervalles **croissants**, pas tout d'un coup.
   Une notion vue aujourd'hui se revoit à **J+1, J+3, J+7, J+16…**. À chaque fois qu'elle « résiste »,
   l'oubli recule. C'est exactement ce que fait **Anki** (cartes qui reviennent au bon moment) — ou ton
   `quiz_journal.md` + moi.

3. **Entrelacement** (*interleaving*) — **alterner** Python / SQL / concepts au lieu de faire un gros bloc
   par sujet. C'est plus dur sur le moment (donc plus efficace), et surtout ça t'entraîne à **choisir la
   bonne méthode** sans qu'on te dise laquelle — comme en entretien et en poste.

4. **Élaboration + Feynman** — **explique à voix haute, avec tes mots, comme à un débutant.** Là où tu
   bafouilles = le trou. Relie chaque notion à **ton projet ETL** ou à **Sanofi** (« le `groupby`, je m'en
   suis servi pour regrouper mes KPI par bâtiment »). Une notion reliée à du concret tient bien mieux.

### Ce qui aide autour (à ne pas négliger)
- **Sommeil** : la consolidation se fait la nuit. 2 sessions distribuées + une nuit > 1 gros bachotage.
- **Distribué > massé** : mieux vaut 4×30 min sur 4 jours que 2h d'un coup.
- **Schéma** (*dual coding*) : dessine le flux `extract → transform → load`, le schéma en étoile, le DAG.
  Une image + des mots se retiennent mieux que des mots seuls.

### La boucle quotidienne (à appliquer les 2 jours, puis en entretien)
```
1. (10 min)  Rappel de la veille — questions fermées, de mémoire.
2. (bloc)    Notion → REFAIRE l'exo sans regarder → corriger → comprendre l'erreur.
3. (5 min)   Noter dans quiz_journal.md UNIQUEMENT ce qui a coincé.
4. (soir/J+1) Re-tester seulement les points ratés.
```

### Après ces 2 jours — l'entretien pour la vie
15-20 min/jour de **rappel actif espacé** sur tes points faibles (via Anki ou notre quiz du lundi),
et **un entretien blanc** de temps en temps. C'est ça qui transforme « je l'ai vu » en « je le maîtrise ».

> Règle d'or des cartes/questions : **une question = une seule idée** (atomique). « C'est quoi une CTE ? »
> oui ; « Explique les window functions, CTE et pivot » non.

---

## PARTIE 2 — Le planning des 2 jours (4h/j, cours fermé d'abord)

Format d'un bloc ≈ **50 min de travail + 10 min de pause**. On **entrelace** Python / SQL.
Pour chaque bloc : (a) je réponds aux questions de rappel de mémoire, (b) je **refais l'exo** indiqué sans
regarder ma correction, (c) je vérifie et je note ce qui a coincé.

### JOUR 1 — Fondations : Python de base + SQL + pandas (S1→S3)

**Bloc 1 — Python S1-S2** (`cours/semaine-01/` + `semaine-02/`)
Rappel : questions S1-Python et S2-pandas (Partie 3). Refaire : `exercices/python/s1_1_comprehensions.ipynb`,
`s2_1_pandas_fondamentaux.ipynb`, `s2_2_pandas_intermediaire.ipynb`.

**Bloc 2 — SQL S1-S2** (`cours/semaine-01/02,04,05` + `semaine-02/03`)
Rappel : questions S1-SQL et S2-SQL. Refaire : `exercices/sql/s1_3_JOINS.sql`, `s2_3_sousrequetes_jointures.sql`.

**Bloc 3 — Python S3** (`cours/semaine-03/01` groupby + `03` OOP)
Rappel : questions S3-pandas et S3-OOP. Refaire : `exercices/python/s3_1_pandas_groupby.ipynb`,
`s3_3_oop_premiere_classe.ipynb`.

**Bloc 4 — SQL S3 : window functions** (`cours/semaine-03/02`)
Rappel : questions S3-SQL. Refaire : `exercices/sql/s3_2_window_functions.sql`.
Feynman : explique à voix haute **RANK vs ROW_NUMBER**, et **LAG/LEAD**.

### JOUR 2 — pandas avancé + ETL + concepts + Java/Spark (S4→S7)

**Bloc 1 — Python S4 : le gros morceau** (`cours/semaine-04/01,03,04,05`)
Rappel : questions S4-pandas. Refaire (priorité merge + pivot) : `exercices/python/s4_1_pandas_merge_concat.ipynb`,
`s4_3_pandas_pivot_table.ipynb`, `s4_4_pandas_apply_lambda.ipynb`, `s4_5_api_pandas.ipynb`.

**Bloc 2 — SQL S4 : CTE + mini-projet** (`cours/semaine-04/02`)
Rappel : questions S4-SQL. Refaire : `exercices/sql/s4_2_cte_with.sql`, puis relire
`exercices/python/livrable/mini_projet_s1_s4.ipynb` (vue d'ensemble).

**Bloc 3 — ETL (S5) + concepts (S6)** (`cours/semaine-05/01`, `semaine-06/01,02` ; fiches `revision_semaine-05.md`, `revision_semaine-06.md`)
Rappel : questions S5-ETL et S6-concepts/étoile. Relire ton code `projet-01-etl/src/` (extract, transform, load,
main) et **raconte le flux à voix haute**. Refaire : `exercices/concepts/s6_1_concepts_de.md`, `s6_2_modelisation_etoile.md`.

**Bloc 4 — Airflow (S6) + Java/Spark (S7)** (`cours/semaine-06/03`, `semaine-07/01,02` ; fiche `revision_semaine-07.md`)
Rappel : questions S6-Airflow, S7-Java, S7-Spark. Refaire : `exercices/concepts/s6_3_airflow.md`,
`s7_2_spark.md`, relire `exercices/java/Produit.java`.
**Fin de J2 : entretien blanc** (questions mélangées) — on le fait ensemble en séance.

---

## PARTIE 3 — Banque de questions de rappel (réponds de mémoire, cours fermé)

> Mode d'emploi : tu réponds à voix haute ou par écrit **sans regarder**. Ensuite tu vérifies avec le
> **corrigé express** (Partie 4) ou le cours. Ce qui coince → dans `quiz_journal.md`.

### S1 — Python
1. Différence liste / dictionnaire / ensemble (set) ?
2. Écris de tête une compréhension qui donne les carrés des pairs de 0 à 9.
3. Dans une fonction, différence entre `return` et `print` ?
4. À quoi sert `try / except` et quelle est sa structure minimale ?

### S1 — SQL
5. Que veut dire DDL ? Écris un `CREATE TABLE` minimal (2-3 colonnes typées).
6. Ordre **logique** d'exécution d'une requête : `SELECT / FROM / WHERE / GROUP BY / HAVING / ORDER BY` ?
7. Différence `INNER JOIN` vs `LEFT JOIN` ?

### S2 — pandas
8. Series vs DataFrame ?
9. `.loc` vs `.iloc` ?
10. Comment filtrer les lignes où `montant > 100`, puis trier par `montant` décroissant ?
11. À quoi servent `value_counts()`, `isin()`, `between()`, `nlargest()`, l'accesseur `.str` ?

### S2 — SQL
12. Sous-requête **scalaire** vs `IN (...)` vs **table dérivée** : donne un exemple de chaque en une ligne.

### S3 — pandas
13. `groupby(...).agg(...)` : à quoi ça sert ? Donne un exemple (moyenne du montant par ville).
14. Deux façons de gérer les `NaN` (valeurs manquantes) et quand utiliser chacune ?

### S3 — OOP (programmation orientée objet)
15. Rôle de `__init__`, de `self` ? Différence entre une **méthode** et une **fonction** ?
16. Différence entre une méthode qui `return` et une qui `print` (rappel du piège) ?

### S3 — SQL (window functions)
17. Structure d'une fonction fenêtre : `... OVER (PARTITION BY ... ORDER BY ...)` — que fait `PARTITION BY` ?
18. `RANK` vs `ROW_NUMBER` vs `DENSE_RANK` ?
19. `LAG` / `LEAD` : à quoi ça sert ? Un cumul (`SUM(...) OVER (...)`) ?
20. Vocabulaire : **trier** = quelle clause ? **classer** = quelle fonction ?

### S4 — pandas
21. `merge` vs `concat` (axis) ? Cite les 4 types de jointure de `merge`.
22. `pivot_table` : rôle de `index`, `columns`, `values`, `aggfunc` ?
23. `apply(..., axis=1)` avec un `lambda` : à quoi ça sert ?
24. API → pandas : quelles 2 briques (une lib + une fonction pandas) pour passer d'un JSON d'API à un DataFrame ?

### S4 — SQL
25. Que veut dire CTE ? À quoi sert un `WITH` et en quoi c'est plus lisible qu'une sous-requête imbriquée ?

### S5 — ETL (ton projet)
26. ETL = ? Décris **ton** pipeline en une phrase (sources → transfo → destination + outil de chargement).
27. Où sont tes secrets (mot de passe BDD) et pourquoi pas dans le code ?
28. Quelle ligne rend ton pipeline **idempotent**, et ça veut dire quoi concrètement ?

### S6 — concepts + modélisation
29. ETL **vs** ELT : quelle est la seule vraie différence (où a lieu la transformation) ?
30. Batch **vs** streaming : un exemple de chaque.
31. Data warehouse **vs** data lake ?
32. Schéma en **étoile** : table de **faits** vs tables de **dimensions** ? C'est quoi le **grain** ?

### S6 — Airflow
33. DAG = ? Que veulent dire « orienté » et « acyclique » ?
34. Un **opérateur**, une **tâche**, l'opérateur `>>` : c'est quoi chacun ?
35. `schedule="0 6 * * *"` = quand ? Pourquoi `retries` + idempotence vont ensemble ?

### S7 — Java
36. Différence de **typage** Java vs Python ? Structure minimale d'une classe (attributs, constructeur, méthode, `main`) ?

### S7 — Spark
37. Spark est **distribué** : ça veut dire quoi (cluster) ?
38. *Lazy evaluation* : différence **transformation** vs **action** ? Classe : `filter`, `count`, `groupBy`, `show`, `withColumn`, `collect`.
39. Quand choisir **pandas** et quand **Spark** ?

---

## PARTIE 4 — Corrigé express (à ne regarder qu'APRÈS avoir répondu)

1. Liste = ordonnée modifiable ; dict = paires clé→valeur ; set = valeurs **uniques** non ordonnées.
2. `[x**2 for x in range(10) if x % 2 == 0]`.
3. `return` **renvoie** une valeur réutilisable ; `print` **affiche** seulement (renvoie `None`).
4. Gérer une erreur sans planter : `try: ... except TypeErreur: ...`.
5. DDL = *Data Definition Language*. Ex. `CREATE TABLE client (id INT, nom VARCHAR(50), age INT);`
6. `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`.
7. INNER = seulement les lignes qui matchent des 2 côtés ; LEFT = **toutes** celles de gauche + matches (NULL sinon).
8. Series = 1 colonne (1D) ; DataFrame = tableau 2D (plusieurs Series).
9. `.loc` = par **label** (nom) ; `.iloc` = par **position** (entier).
10. `df[df["montant"] > 100].sort_values("montant", ascending=False)`.
11. compter les occurrences / tester l'appartenance à une liste / intervalle / n plus grandes / méthodes texte.
12. scalaire : `WHERE prix > (SELECT AVG(prix) FROM p)` · IN : `WHERE ville IN (SELECT ...)` · dérivée : `FROM (SELECT ...) t`.
13. Regrouper puis agréger : `df.groupby("ville")["montant"].mean()`.
14. `dropna()` (supprimer) quand peu de lignes / non fiables ; `fillna(v)` (remplacer) quand on veut garder la ligne.
15. `__init__` = constructeur (init les attributs) ; `self` = l'instance courante ; méthode = fonction **définie dans une classe**.
16. `return` renvoie la valeur (réutilisable) ; `print` affiche seulement — piège classique en OOP.
17. `PARTITION BY` = découpe en groupes ; la fonction s'applique **dans** chaque groupe sans agréger les lignes.
18. RANK : rangs avec **trous** en cas d'égalité (1,1,3) ; ROW_NUMBER : numéro **unique** (1,2,3) ; DENSE_RANK : sans trous (1,1,2).
19. LAG = valeur de la ligne **précédente**, LEAD = **suivante** ; `SUM(...) OVER (ORDER BY ...)` = cumul progressif.
20. trier = `ORDER BY` ; classer = `RANK` (ta correction — ne pas confondre).
21. `merge` = jointure par clé (comme SQL) ; `concat` = empiler (`axis=0` lignes, `axis=1` colonnes). Jointures : inner, left, right, outer.
22. `index` = lignes ; `columns` = colonnes ; `values` = valeurs à agréger ; `aggfunc` = fonction (sum, mean…).
23. Appliquer un calcul **ligne par ligne** en combinant plusieurs colonnes.
24. `requests` (appeler l'API) + `pd.json_normalize(...)` (aplatir le JSON en DataFrame).
25. CTE = *Common Table Expression*. `WITH t AS (SELECT ...) SELECT ... FROM t` : nomme une sous-requête → plus lisible, réutilisable.
26. Extract-Transform-Load. Ex. : « j'extrais CSV + JSON, je transforme avec pandas, je charge dans PostgreSQL via SQLAlchemy ».
27. Dans un fichier `.env` (hors du code, ignoré par git) → on ne publie jamais un mot de passe.
28. `df.to_sql(table, engine, if_exists="replace", ...)` : relancer 3× ne crée pas de doublons (on remplace, pas on ajoute).
29. ETL : transfo **avant** le chargement (dans Python) ; ELT : on charge brut puis on transforme **dans** la base (SQL).
30. batch : rapport CA du lundi (périodique) ; streaming : blocage carte bancaire en temps réel (continu).
31. warehouse : données **structurées, propres**, prêtes pour l'analyse ; lake : données **brutes**, pêle-mêle, schéma à la demande.
32. faits = **mesures** (montant, quantité) ; dimensions = **attributs** (ville, produit) ; grain = **ce que représente une ligne** de faits.
33. DAG = *Directed Acyclic Graph* ; orienté = ordre imposé (E→T→L) ; acyclique = on ne revient jamais en arrière.
34. tâche = une étape ; opérateur = **le type** de tâche (ce qu'elle exécute) ; `>>` = définit **l'ordre** entre tâches.
35. tous les jours à 6h00 ; `retries` relance en cas d'échec, et comme le pipeline est idempotent, relancer ne crée pas de doublons.
36. Java = typage **statique** (types déclarés, vérifiés à la compilation) vs Python dynamique. `class C { int x; C(int x){this.x=x;} int m(){return x;} public static void main(...){} }`.
37. Le travail est réparti sur **plusieurs machines** (un cluster) qui calculent en parallèle → gros volumes.
38. transformation (paresseuse, empilée dans un plan) : `filter, groupBy, withColumn` ; action (déclenche le calcul) : `count, show, collect`.
39. pandas : petit/moyen volume sur une machine ; Spark : très gros volume distribué sur cluster.

---

*Astuce : garde ce fichier ouvert à côté de tes exos, et à chaque question ratée, une ligne dans
`quiz_journal.md`. Ce sont ces lignes-là qu'on retravaillera en priorité.*
