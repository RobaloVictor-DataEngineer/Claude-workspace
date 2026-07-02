# Semaine 3 · Python — Pandas : l'agrégation avec `groupby`

> Session Python. Hier, dans ton livrable, tu voulais des chiffres « par région » ou « par classe »
> et tu t'en sortais avec des filtres un par un. `groupby` fait ça d'un coup : il découpe le tableau
> par catégorie et calcule un indicateur pour chaque groupe. C'est **l'outil d'analyse le plus
> important de pandas**, et une question quasi systématique en entretien data engineer. On en profite
> aussi pour régler proprement le piège des NaN vu hier.

---

## 1. Pourquoi ce thème

Jusqu'ici tu répondais « combien au total ». La vraie question métier est presque toujours **« par
quelque chose »** : chiffre d'affaires *par région*, budget moyen *par phase*, nombre d'essais *par
site*. `groupby` (= regrouper) répond exactement à ça. Sans lui, tu ferais une boucle et un filtre
par catégorie ; avec lui, une ligne.

---

## 2. Le principe : *split → apply → combine*

`groupby` fonctionne toujours en trois temps. On **découpe** (split) le tableau en groupes selon une
colonne, on **applique** (apply) un calcul à chaque groupe, puis on **recombine** (combine) les
résultats en un tableau indexé par les groupes.

```
          service │ salaire                  groupby("service")
          ────────┼────────        split          apply (mean)       combine
   Alice   Data   │ 38000     ┌── Data:  38000, 41000 ──► 39500 ──┐   service
   Bob     Data   │ 41000     │                                   ├─► Data  39500
   Chloé   RH     │ 45000     └── RH:    45000        ──► 45000 ──┘   RH    45000
```

---

## 3. `groupby` + une agrégation simple

On groupe par une colonne, on choisit la colonne à calculer, on applique une fonction d'agrégation
(**agrégation** = résumer plusieurs lignes en une seule valeur : `mean`, `sum`, `count`, `min`, `max`…).

```python
df.groupby("service")["salaire"].mean()   # salaire moyen par service
df.groupby("service")["salaire"].sum()    # masse salariale par service
df.groupby("service").size()              # nombre de lignes par service (taille du groupe)
```

Le résultat est une Series **indexée par les groupes** (`Data`, `RH`…). À lire comme « pour chaque
service, la valeur calculée ».

> Nuance `count()` vs `size()` : `size()` compte toutes les lignes du groupe ; `count()` compte les
> valeurs **non-nulles** d'une colonne (il ignore les NaN). Utile à connaître.

---

## 4. Plusieurs calculs d'un coup : `.agg()`

Pour appliquer **plusieurs** agrégations, on passe une liste à `.agg()` :

```python
df.groupby("service")["salaire"].agg(["mean", "min", "max", "count"])
# renvoie un DataFrame : une colonne par calcul, une ligne par service
```

Et pour des calculs sur **des colonnes différentes**, avec des noms clairs (named aggregation) :

```python
df.groupby("service").agg(
    salaire_moyen = ("salaire", "mean"),    # nom_resultat = (colonne, fonction)
    effectif      = ("salaire", "count"),
)
```

C'est la forme la plus lisible, et celle qu'on aime voir en entretien.

---

## 5. Grouper par plusieurs colonnes

On passe une **liste** de colonnes : les groupes deviennent chaque combinaison.

```python
df.groupby(["service", "site"])["salaire"].mean()   # salaire moyen par (service, site)
```

Le résultat a un index à deux niveaux. Pour retrouver un tableau plat classique, ajoute
`.reset_index()` :

```python
df.groupby(["service", "site"])["salaire"].mean().reset_index()
```

---

## 6. Le piège des NaN (retour sur ton livrable)

Deux choses à retenir, dans l'ordre où elles t'ont piégé hier :

**a) `groupby` ignore les lignes dont la clé de groupe est NaN.** Si tu groupes par `region` et que
12 régions manquent, ces 12 lignes **disparaissent** du résultat groupé — silencieusement. C'est
souvent voulu (on ne peut pas les ranger dans un groupe), mais il faut le savoir.

**b) Ne supprime pas une ligne entière pour une colonne sans rapport.** Hier, `df.dropna()` retirait
les 12 lignes à région manquante *avant* de calculer le CA, alors que le CA n'a pas besoin de la
région → tu perdais ~1 210 € pour rien. La règle : on nettoie **au plus près du besoin**.

```python
df["ca"].sum()                     # CA total : toutes les lignes, la région ne gêne pas -> 20588
df.dropna(subset=["region"])       # on ne retire les NaN QUE quand on travaille PAR région
df.groupby("region")["ca"].sum()   # ici les NaN de region sont déjà ignorés automatiquement
```

`dropna(subset=["region"])` = « supprime seulement les lignes où *region* est manquante », au lieu de
`dropna()` qui regarde toutes les colonnes. Et `fillna(valeur)` sert à **remplacer** un NaN plutôt
que le supprimer (ex. `df["region"].fillna("Inconnue")`).

---

## 7. À retenir

- `groupby` = *split → apply → combine* : découper par catégorie, calculer, recombiner.
- Forme simple : `df.groupby("col")["valeur"].mean()` (ou `sum`, `count`, `size`…).
- `size()` compte toutes les lignes ; `count()` ignore les NaN.
- `.agg([...])` pour plusieurs calculs ; **named aggregation** `nom=("col","fonc")` pour du lisible.
- Grouper par plusieurs colonnes = liste ; `.reset_index()` pour reposer un tableau plat.
- `groupby` **ignore les clés NaN** ; nettoie au plus près du besoin avec `dropna(subset=[...])` ou `fillna(...)`, pas un `dropna()` global.

---

## 8. Exercices

> **Ce qu'ils entraînent :** répondre à de vraies questions « par catégorie » sur un jeu de données
> métier, choisir la bonne agrégation, et rester lucide sur les valeurs manquantes. C'est le geste
> d'analyse qu'on te demandera de dérouler en entretien. Travaille dans
> `exercices/python/s3_1_pandas_groupby.ipynb` (exemples à exécuter en haut ; énoncés en dessous).
> Dataset : `exercices/python/data/essais_cliniques.csv` (essais cliniques d'un labo : phase, aire
> thérapeutique, site, nombre de patients recrutés, budget, statut). **À toi de choisir tes outils —
> rien n'est imposé, et méfie-toi de ce qui manque dans les données.**

1. Combien de patients ont été recrutés **au total par aire thérapeutique** ? Laquelle recrute le plus ?

2. Quel est le **budget moyen par phase** d'essai ? Commente l'ordre de grandeur entre phases.

3. Quels **sites** portent le plus d'essais ? (donne-moi un classement)

4. Pour **chaque aire thérapeutique**, donne d'un seul coup : le nombre d'essais, le total de patients recrutés, et le budget moyen. Présente un tableau lisible.

5. Regarde le **budget moyen par (aire thérapeutique, statut)**. Y a-t-il des combinaisons qui ressortent ?

6. Une colonne contient des valeurs manquantes. **Repère-la**, puis explique en une phrase (en commentaire) si elle fausse l'un de tes calculs précédents — et corrige si besoin.

7. **Réflexion (pas de code).** En une phrase : que fait `groupby` avec une ligne dont la colonne de regroupement est manquante (NaN) ?

---

*Quand c'est fait, envoie-moi le notebook. Ensuite, session SQL : les **window functions**
(ROW_NUMBER, RANK, LAG/LEAD, SUM OVER) — l'équivalent SQL de ce `groupby`, et un gros sujet d'entretien.*
