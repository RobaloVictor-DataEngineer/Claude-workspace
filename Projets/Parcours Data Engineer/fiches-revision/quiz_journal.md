# Journal du quiz de réactivation (anti-répétition + points faibles)

> Tenu par la tâche programmée `quiz-reactivation-data-eng`.
> - **Anti-répétition** : la tâche ajoute chaque jour la date + les thèmes/questions posés, pour ne pas les reposer les ~3 jours suivants.
> - **Points à retravailler** : notions récemment ratées, à re-tester en priorité. Mises à jour à la correction.

## Points à retravailler (prioritaires)
- **[Priorité haute]** Pandas `.loc[]` vs `.iloc[]` — répondu inversé (loc = étiquette/index, iloc = position entière) : base très utilisée, à refixer en premier.
- Try/except : exception levée sur clé absente d'un dict (`KeyError`) — oublié.
- Pandas `merge(how="inner")` (le défaut) : piège de perte silencieuse de lignes sans correspondance — oublié.
- SQL : raison exacte de l'alias obligatoire sur une table dérivée (`FROM (...)`) — confondu avec la raison de réutiliser une CTE.
- Pandas `.copy()` sur un DataFrame filtré avant modification (lien avec `SettingWithCopyWarning`) — oublié.
- CTE vs sous-requête imbriquée : le vrai avantage (lisibilité + possibilité de chaîner/réutiliser), pas une histoire de "petite vs grande opération" — à reformuler.
- Java : mot-clé `new` pour instancier un objet — oublié.
- Spark : lazy evaluation (transformation vs action) — oublié.
- **[Priorité haute]** SQL window functions — `RANK` vs `DENSE_RANK` **inversés** (RANK saute : 1,1,3 ; DENSE_RANK ne saute pas : 1,1,2), `LAG` vs `LEAD` **inversés** (LAG = précédente, LEAD = suivante), cumul mal formé (`SUM(montant) OVER (ORDER BY date)`), `PARTITION BY` compris à moitié (découpe en groupes, le calcul repart à zéro par groupe). Notion la plus fragile de S1-S3.
- SQL : **ordre d'exécution logique** (`FROM→WHERE→GROUP BY→HAVING→SELECT→ORDER BY`) ≠ ordre d'écriture — raté (lien : alias du SELECT inutilisable dans le WHERE).
- Python : **mutabilité** — liste `[]` modifiable vs tuple `()` immuable vs set `{}` (valeurs uniques). **[RÉCURRENT : inversé le 01/09 ET le 03/09]** → mnémo « crochets = on change, parenthèses = protégé ». À re-tester tous les jours jusqu'à ce que ça tienne.
- [Résolu 03/09] RANK avec 3+ ex-aequo : `90,90,90,50 → 1,1,1,4` réussi de mémoire. OK.

## Points solides malgré la coupure d'août
INNER JOIN, PARTITION BY vs GROUP BY, `self` vs variable locale (OOP), modélisation en étoile (placement d'un attribut de dimension), `if_exists="replace"` (remplacement complet, pas un upsert), `drop_duplicates()` nécessite réaffectation, opérateur `>>` Airflow.

## Historique des questions posées

### 01/09/2026
1. (priorité S6) Modélisation étoile : placement de l'attribut "ville" du client (dimension client, dimension produit, ou table de faits) ?
2. (priorité S6) `to_sql(..., if_exists="replace")` : upsert ligne à ligne ou remplacement complet de la table ?
3. (priorité S3) `solde = solde - montant` au lieu de `self.solde = ...` dans une méthode : pourquoi ça ne persiste pas sur l'objet ?
4. SQL : `RANK()` vs `DENSE_RANK()` en cas d'égalité entre deux lignes
5. SQL : CTE enchaînées — utilité de référencer la 1re CTE dans la 2e
6. Pandas : `groupby(...)["prix"].mean()` vs `agg(prix_moyen=("prix","mean"))` (named aggregation)
7. Spark : pourquoi dit-on que Spark est "distribué" contrairement à pandas ?
8. Python : sortie de `[x**2 for x in range(5) if x % 2 == 0]`
9. Concepts DE : exemple concret d'usage batch + exemple concret d'usage streaming
10. Java : rôle du mot-clé `new` à la création d'un objet

### 06/08/2026
1. (priorité S6) Grain table de faits : passer de "1 ligne/jour" à "1 ligne/vente", qu'est-ce que ça change dans la table ?
2. (priorité S3) Méthode avec `solde = solde - montant` au lieu de `self.solde = ...` : effet à l'exécution ?
3. (priorité S5) `clients_actifs = df[...]` puis `clients_actifs["remise"] = 10` : quel avertissement, comment l'éviter ?
4. SQL : JOIN à 3 tables, oubli d'un `ON` — conséquence
5. SQL : sous-requête `IN` vs sous-requête scalaire (`>`) — différence
6. Pandas : `.loc[]` vs `.iloc[]`
7. Pandas : `pivot_table` — rôle du paramètre `fill_value`
8. Python : exception sur clé absente d'un dictionnaire + capture
9. Java : pourquoi déclarer le type (`int quantite = 3;`) alors que Python ne l'exige pas
10. Spark : pourquoi pandas plutôt que Spark pour un fichier de quelques Mo

### 05/08/2026
1. (priorité S6) Modélisation étoile : que représente le « grain » d'une table de faits ?
2. (priorité S5) Pourquoi utiliser `.copy()` avant de modifier un DataFrame issu d'un filtrage ?
3. (priorité S3) À quoi sert la méthode `__init__` dans une classe Python ?
4. SQL : différence entre `WHERE` et `HAVING`
5. SQL : à quoi sert un alias de table dans une requête à plusieurs jointures ?
6. Pandas : que renvoie `df["colonne"].value_counts()` ?
7. Pandas : à quoi sert `nlargest(n, "colonne")` ?
8. Concepts DE : différence principale entre data warehouse et data lake
9. Airflow : à quoi sert le paramètre `schedule` d'un DAG ?
10. Spark : qu'est-ce que la lazy evaluation ? différence transformation vs action

### 03/08/2026
1. (priorité S4) Pandas `merge` : piège du `how="inner"` par défaut
2. (priorité S2) SQL : pourquoi une table dérivée (sous-requête dans le `FROM`) doit avoir un alias en PostgreSQL
3. (priorité S3) Python OOP : une méthode qui calcule doit `return` ou `print` ? pourquoi
4. SQL : `LAG`/`LEAD` — usage et exemple
5. SQL : CTE (`WITH`) — avantage vs sous-requête imbriquée
6. Pandas : différence `.isin()` vs `.between()`
7. Pandas : à quoi sert `pd.json_normalize` ?
8. Concepts DE : ETL vs ELT — différence principale
9. Concepts DE : idempotence — définition + pourquoi important avec Airflow
10. Java (S7, nouveau) : à quoi sert le mot-clé `this` dans une classe ?

### 31/07/2026
1. (priorité S6) `to_sql(if_exists="replace")` : upsert ligne à ligne ou autre chose ?
2. (priorité S6) Modélisation étoile : placement de l'attribut `ville` (faits vs dimension)
3. (priorité S5) `drop_duplicates()` : nécessité de l'affectation (`df = df.drop_duplicates()`)
4. SQL : lister les clients sans commande sans LEFT JOIN (sous-requête NOT IN/IN)
5. SQL : `RANK()` vs `ROW_NUMBER()` sur valeurs égales (rappel PARTITION BY)
6. Pandas : `groupby("categorie")["prix"].agg(["mean", "count"])`
7. Python OOP : pourquoi `self.solde` plutôt que `solde` dans une méthode
8. Concepts DE : batch vs streaming + exemple d'usage
9. Airflow : signification de l'opérateur `>>` entre deux tâches
10. Spark vs pandas : exécution distribuée (S7, nouveau)


### 01/09/2026 — Diagnostic de reprise (session interactive, post-vacances)
15 questions couvrant S1→S7 pour évaluer l'impact de la coupure d'août. 7/15 bonnes, 1 inversion (loc/iloc), 2 raisonnements à revoir (alias table dérivée, avantage CTE), 5 oubliées (KeyError, merge inner, .copy(), new Java, lazy evaluation Spark). Détail dans la section "Points à retravailler" ci-dessus.

### 01/09/2026 — Séance 1 de reprise (J1, blocs 1-2 + window)
Rounds : Python S1-S2, SQL S1-S2, SQL S3 window.
- Round 1 (Python) : 3/5 — mutabilité liste/tuple/set confondue, `.loc/.iloc` encore oublié, `range` avec `:` au lieu de virgules.
- Round 2 (SQL) : 4/5 — seule erreur : ordre d'exécution (a redonné l'ordre d'écriture). DDL, INNER/LEFT, WHERE/HAVING, sous-requête scalaire : OK.
- Round 3 (SQL window) : 1-2/5 — RANK/DENSE_RANK inversés, LAG/LEAD inversés, cumul faux, PARTITION BY partiel. **À re-tester en priorité demain.**
À faire J+1 : re-tester window functions + mutabilité + ordre d'exécution avant de continuer S4.

### 03/09/2026 — Séance 2 (J+1) : re-test window functions
- LAG/LEAD : OK (tenu une nuit). DENSE_RANK : OK. PARTITION BY vs GROUP BY : maintenant **solide** (bien expliqué).
- Reste un micro-point : **RANK avec 3+ ex-aequo** — a mis 1,1,3,4 au lieu de 1,1,1,4 (tous les ex-aequo au même rang, puis saut du nombre d'ex-aequo). À re-glisser une fois plus tard.
- Window functions globalement **validées** → sortent de la priorité haute.
- pandas **groupby** : blanchi au 1er passage (réflexe central, utilisé chez Sanofi) → ré-ancré aussitôt : structure OK (`groupby(...).agg(nom=("col","fonction"))` reproduit de mémoire). Points d'attention : **guillemets** sur les noms de colonnes + utiliser le **bon nom de colonne**. À re-glisser J+1.
- OOP (`__init__`, `self`, `return` vs `self.solde`), dropna/fillna : OK.

### 04/09/2026 — Séance 3 (pratique code, notebook bac à sable)
Lot écrit de zéro : pandas (pivot_table, apply/lambda, panier moyen par segment) + SQL (RANK, cumul, CTE).
- **Bons du 1er coup** : pivot_table, apply/lambda, merge+groupby (panier moyen), RANK (1re fonction fenêtre écrite seul 👍).
- **[Priorité]** SQL cumul avec GROUP BY : oubliait le **double SUM** `SUM(SUM(...)) OVER (ORDER BY ...)` → cumul faux sur dates en double. Concept ré-expliqué (2 étages : SUM interne = total du jour, SUM OVER externe = cumul). À re-tester le 11/09.
- **[Priorité]** CTE : oubliait le `GROUP BY` dans la CTE (sans lui, SUM agrège tout en 1 ligne → résultat vide). À re-tester le 11/09.
- Progrès net côté **écriture de code** (son point faible auto-identifié) : il produit les motifs seul, ne blanchit plus.
