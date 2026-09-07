# Antisèche — tout tient sur une page (pandas + SQL)

> Le domaine des entretiens data, ce n'est pas 1000 fonctions. C'est **~10 opérations**, exprimables
> en pandas **et** en SQL. Garde cette page ouverte. En entretien, ce qu'on juge c'est **le découpage
> du problème** ; la syntaxe se retrouve.

## Les 10 opérations (pandas ↔ SQL, côte à côte)

| Ce que je veux faire | pandas | SQL |
|---|---|---|
| **Filtrer** des lignes | `df[df["montant"] > 100]` | `WHERE montant > 100` |
| **Choisir** des colonnes | `df[["client", "montant"]]` | `SELECT client, montant` |
| **Créer** une colonne | `df.assign(CA=df.q * df.pu)` | `SELECT q * pu AS CA` |
| **Trier** | `df.sort_values("CA", ascending=False)` | `ORDER BY CA DESC` |
| **Regrouper + agréger** | `df.groupby("ville")["CA"].sum()` | `GROUP BY ville … SUM(CA)` |
| Plusieurs agrégats | `.agg(n=("CA","count"), t=("CA","sum"))` | `COUNT(CA), SUM(CA)` |
| **Filtrer des groupes** | (filtrer après le groupby) | `HAVING SUM(CA) > 1000` |
| **Top N** | `df.nlargest(3, "CA")` | `ORDER BY CA DESC LIMIT 3` |
| **Rapprocher 2 tables** | `df1.merge(df2, on="cle")` | `JOIN df2 ON df1.cle = df2.cle` |
| **Empiler** (mettre bout à bout) | `pd.concat([df1, df2])` | `UNION ALL` |
| **Tableau croisé** | `df.pivot_table(index=, columns=, values=, aggfunc=)` | (GROUP BY sur 2 colonnes) |
| **Doublons / manquants** | `drop_duplicates()`, `fillna()`, `dropna()` | `DISTINCT`, `COALESCE()` |
| **Compter les valeurs** | `df["col"].value_counts()` | `GROUP BY col … COUNT(*)` |

## Les 4 fonctions "avancées" qui impressionnent (SQL surtout)

| | à quoi ça sert | forme |
|---|---|---|
| **RANK / ROW_NUMBER** | classer sans écraser les lignes | `RANK() OVER (PARTITION BY g ORDER BY x DESC)` |
| **LAG / LEAD** | valeur de la ligne précédente / suivante | `LAG(x) OVER (ORDER BY date)` |
| **cumul** (running total) | additionner au fil des lignes | `SUM(x) OVER (ORDER BY date)` |
| **CTE** (`WITH`) | nommer une sous-requête pour la réutiliser | `WITH t AS (SELECT …) SELECT … FROM t` |

## La recette universelle (à réciter dans ta tête à chaque problème)

1. **De quelles colonnes j'ai besoin, et sont-elles dans une seule table ?**
   → si non : **`merge` / `JOIN`** d'abord.
2. **Ai-je besoin d'une colonne calculée ?** (ex. CA = quantité × prix)
   → **`assign` / `SELECT … AS`**.
3. **Est-ce un résultat "par groupe" ?** (par client, par ville, par mois…)
   → **`groupby` / `GROUP BY`** + la bonne fonction (`sum`, `count`, `mean`, `max`).
4. **Trier ? Garder le top N ?**
   → **`sort_values` / `ORDER BY`**, puis **`nlargest` / `LIMIT`**.

> 90 % des exercices = une combinaison de ces 4 étapes. Si tu sais dire ces étapes **en français**,
> tu sais résoudre le problème — le code n'est plus que de la traduction.

## Les 6 verbes pandas à connaître par cœur (le strict minimum)
`merge` · `assign` · `groupby` · `agg` · `sort_values` · `nlargest`

## Les 6 mots-clés SQL à connaître par cœur
`JOIN … ON` · `WHERE` · `GROUP BY` · `HAVING` · `ORDER BY … LIMIT` · `OVER (…)`
