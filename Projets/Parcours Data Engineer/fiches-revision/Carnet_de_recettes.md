# Carnet de recettes — pandas + SQL (ton noyau à maîtriser)

> **~20 motifs qui couvrent 90 % des questions.** Pas 1000 fonctions : ça.
> Règle d'usage : tu as le **droit de le consulter** pendant tes exos. Objectif = t'en servir de moins
> en moins, jusqu'à réécrire chaque motif **de zéro sans regarder**. Le jour où tu y arrives à J+7 → maîtrisé.

---

## A. pandas

**1. Lire un fichier**
```python
df = pd.read_csv("fichier.csv")
```

**2. Inspecter (les 4 réflexes)**
```python
df.head()      # premières lignes
df.shape       # (nb_lignes, nb_colonnes)
df.info()      # types + valeurs manquantes
df.describe()  # stats des colonnes numériques
```

**3. Sélectionner**
```python
df["prix"]              # une colonne (Series)
df[["nom", "prix"]]     # plusieurs colonnes (DataFrame)
df.loc[0, "prix"]       # par LABEL (nom de ligne/colonne)
df.iloc[0, 2]           # par POSITION (entiers) — i = index entier
```

**4. Filtrer** (parenthèses obligatoires avec `&` et `|`)
```python
df[df["prix"] > 100]
df[(df["prix"] > 100) & (df["ville"] == "Paris")]
```

**5. Trier**
```python
df.sort_values("prix", ascending=False)
```

**6. Colonne calculée** (`assign` = sans modifier df)
```python
df["CA"] = df["quantite"] * df["prix"]
df.assign(CA=lambda d: d.quantite * d.prix)
```

**7. Top / bas N** (fait tri + tête d'un coup)
```python
df.nlargest(3, "prix")     # 3 plus grands
df.nsmallest(3, "prix")
```

**8. Compter les occurrences**
```python
df["ville"].value_counts()
```

**9. Grouper + agréger** ← LE motif central
```python
df.groupby("ville")["prix"].mean()                    # un agrégat
df.groupby("ville").agg(                               # plusieurs, noms propres
    nb=("prix", "count"),
    total=("prix", "sum"),
)
```

**10. Rapprocher 2 tables (merge)** — quand l'info est dans une autre table
```python
df.merge(autre, on="cle", how="left")   # how = inner (défaut) / left / right / outer
```

**11. Empiler (concat)**
```python
pd.concat([df1, df2])              # ajoute des lignes (axis=0)
pd.concat([df1, df2], axis=1)      # ajoute des colonnes
```

**12. Tableau croisé (pivot_table)**
```python
df.pivot_table(index="ville", columns="categorie",
               values="CA", aggfunc="sum", fill_value=0)
```

**13. Fonction ligne par ligne (apply + lambda)**
```python
df["etiquette"] = df.apply(lambda d: "cher" if d.prix > 100 else "ok", axis=1)
```

**14. Valeurs manquantes (NaN)**
```python
df.dropna()             # supprimer les lignes avec NaN
df["prix"].fillna(0)    # remplacer les NaN
```

**15. Doublons**
```python
df.drop_duplicates()    # pense à réaffecter : df = df.drop_duplicates()
```

**16. Texte**
```python
df["nom"].str.lower()
df[df["nom"].str.contains("data")]
```

**17. Dates**
```python
df["date"] = pd.to_datetime(df["date"])
df["annee"] = df["date"].dt.year
```

**18. API → pandas**
```python
import requests
data = requests.get(url).json()
df = pd.json_normalize(data)     # aplatit le JSON en tableau
```

---

## B. SQL

**1. Sélection + filtre**
```sql
SELECT nom, prix FROM produit WHERE prix > 100;
```

**2. Ordre d'EXÉCUTION (à réciter par cœur)**
`FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`
*(→ pourquoi un alias du SELECT ne marche pas dans le WHERE.)*

**3. Agréger** (`WHERE` filtre les lignes AVANT, `HAVING` filtre les groupes APRÈS)
```sql
SELECT ville, SUM(prix) AS ca
FROM ventes
GROUP BY ville
HAVING SUM(prix) > 1000;
```

**4. Jointures**
```sql
SELECT c.nom, p.categorie
FROM commandes c
JOIN produits p ON c.produit = p.produit;   -- LEFT JOIN = garde tout à gauche
```

**5. Sous-requête**
```sql
-- scalaire
WHERE prix > (SELECT AVG(prix) FROM produit)
-- liste
WHERE ville IN (SELECT ville FROM cibles)
-- table dérivée (alias obligatoire)
FROM (SELECT ... ) AS t
```

**6. Top N**
```sql
SELECT nom, prix FROM produit ORDER BY prix DESC LIMIT 3;
```

**7. Fonctions fenêtre : classer** (garde le détail des lignes)
```sql
RANK()       OVER (PARTITION BY ville ORDER BY ca DESC)  -- égalité: 1,1,3 (saut)
DENSE_RANK() OVER (ORDER BY ca DESC)                      -- égalité: 1,1,2 (sans saut)
ROW_NUMBER() OVER (ORDER BY ca DESC)                      -- unique: 1,2,3
```

**8. Fenêtre : décalage & cumul**
```sql
LAG(ca)  OVER (ORDER BY date)          -- valeur précédente
LEAD(ca) OVER (ORDER BY date)          -- valeur suivante
SUM(ca)  OVER (ORDER BY date)          -- cumul (running total)
```

**9. CTE (WITH)** — nommer une sous-requête pour la lisibilité
```sql
WITH ca_client AS (
    SELECT client, SUM(prix) AS ca FROM ventes GROUP BY client
)
SELECT * FROM ca_client WHERE ca > (SELECT AVG(ca) FROM ca_client);
```

---

## C. Concepts data engineering (en une phrase, pour l'oral)

- **ETL vs ELT** : transfo **avant** le chargement (ETL, dans Python) ou **après**, dans la base (ELT, en SQL).
- **Batch vs streaming** : par lots périodiques (rapport hebdo) vs en continu temps réel (fraude carte).
- **Data warehouse vs data lake** : données **propres et structurées** (analyse) vs **brutes en vrac** (schéma à la demande).
- **Idempotence** : relancer le pipeline ne crée pas de doublons (`if_exists="replace"`).
- **Schéma en étoile** : table de **faits** (mesures : montant, quantité) + tables de **dimensions** (attributs : ville, produit) ; **grain** = ce que représente une ligne de faits.
- **Airflow / DAG** : *Directed Acyclic Graph*, le plan orienté (E→T→L) et sans retour ; `>>` = ordre des tâches ; `retries` + idempotence vont ensemble.
- **Spark** : calcul **distribué** (cluster) pour gros volumes ; *lazy* → **transformations** (empilées : filter, groupBy) vs **actions** (déclenchent : show, count, collect).
