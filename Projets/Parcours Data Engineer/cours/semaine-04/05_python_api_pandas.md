# Semaine 4 · Python — Récupérer des données d'une API vers pandas

> Session Python, dernier thème de la S4. Beaucoup de données ne sont pas dans un CSV : elles vivent
> derrière une **API** (un service web qu'on interroge pour recevoir des données). La réponse arrive
> presque toujours en **JSON**. Ton job de data engineer : **appeler l'API**, récupérer le JSON, et le
> **transformer en DataFrame** propre. C'est le début de la partie **E** (Extract) d'un pipeline.

---

## 1. Le vocabulaire (3 mots)

- **API** (Application Programming Interface) = une « prise » web : tu envoies une requête à une URL, le
  service te renvoie des données. Ex. : « donne-moi les commandes du jour ».
- **JSON** (JavaScript Object Notation) = un format texte de données, fait de **dictionnaires** `{ }` et
  de **listes** `[ ]` imbriqués. C'est exactement la structure des dicts/listes Python que tu connais.
- **`requests`** = la bibliothèque Python pour appeler une API (`pip install requests`).

```json
[
  { "id": 1, "montant": 120.5, "client": { "nom": "Durand", "ville": "Rouen" } },
  { "id": 2, "montant": 80.0,  "client": { "nom": "Martin", "ville": "Paris" } }
]
```

Lis ça comme : une **liste** de commandes, chaque commande étant un **dictionnaire** ; et `client` est
lui-même un dictionnaire **imbriqué** (un dict dans un dict).

---

## 2. Appeler l'API avec `requests`

```python
import requests

url = "https://jsonplaceholder.typicode.com/users"   # une API de test, sans authentification
reponse = requests.get(url)          # on interroge l'API (méthode GET = "donne-moi")
print(reponse.status_code)           # 200 = OK ; 404 = pas trouvé ; 500 = erreur serveur
donnees = reponse.json()             # convertit le JSON reçu en objet Python (liste de dicts)
```

Premier réflexe : **vérifier `status_code`** (200 = tout va bien) avant d'utiliser les données. `.json()`
te rend une **liste de dictionnaires** (ou un dict), directement manipulable en Python.

---

## 3. JSON plat → DataFrame : `pd.DataFrame`

Si chaque élément est un dictionnaire **simple** (pas d'imbrication), `pd.DataFrame` suffit :

```python
import pandas as pd

donnees = [
    {"id": 1, "montant": 120.5, "ville": "Rouen"},
    {"id": 2, "montant": 80.0,  "ville": "Paris"},
]
pd.DataFrame(donnees)     # chaque clé devient une colonne
```

---

## 4. JSON imbriqué → DataFrame : `pd.json_normalize`

Le piège : dès qu'un champ est **imbriqué** (un dict dans le dict, comme `client`), `pd.DataFrame` te met
tout le sous-dictionnaire dans **une seule colonne** — inexploitable. `pd.json_normalize` **aplatit**
l'imbrication en colonnes séparées.

**En une phrase :** `json_normalize` déplie les dictionnaires imbriqués en colonnes `parent.enfant`.

AVANT — le JSON reçu (`client` est imbriqué) :

```
[
  { "id": 1, "montant": 120.5, "client": { "nom": "Durand", "ville": "Rouen" } },
  { "id": 2, "montant": 80.0,  "client": { "nom": "Martin", "ville": "Paris" } }
]
```

APRÈS — `pd.json_normalize(donnees)` :

```
   id  montant  client.nom  client.ville
0   1    120.5      Durand         Rouen
1   2     80.0      Martin         Paris
```

La colonne imbriquée `client` a été **dépliée** en `client.nom` et `client.ville`, chacune utilisable
comme une colonne normale (filtrable, groupable…). Avec un `pd.DataFrame` simple, tu aurais eu une
colonne `client` contenant des dictionnaires — impossible à exploiter directement.

---

## 5. À retenir

- **API** = service web qu'on interroge ; **JSON** = format de la réponse (dicts `{}` + listes `[]`) ; **`requests`** = l'outil Python pour appeler.
- `requests.get(url)` → vérifier `.status_code` (200 = OK) → `.json()` pour obtenir un objet Python.
- JSON **plat** → `pd.DataFrame(donnees)`.
- JSON **imbriqué** → `pd.json_normalize(donnees)` : déplie les dicts en colonnes `parent.enfant`.
- Toujours **regarder la structure** du JSON avant de choisir (`DataFrame` simple ou `json_normalize`).

---

## 6. Exercice

> **Ce que tu dois en retenir :** transformer une **réponse d'API** (du JSON imbriqué) en tableau propre,
> puis l'**analyser** avec ce que tu sais déjà (filtre, `groupby`). Extraire *puis* exploiter, c'est le
> geste de base d'un pipeline. Travaille dans `exercices/python/s4_5_api_pandas.ipynb` (exemples à
> exécuter en haut, énoncés en dessous). Donnée : `exercices/python/data/commandes_api.json` — une
> réponse d'API simulée (une liste de commandes, avec un bloc `client` **imbriqué**). **À toi de choisir
> tes outils.**

> Note : on part d'un fichier JSON local (une réponse d'API enregistrée) pour que l'exercice soit
> reproductible. Le code pour le charger depuis le fichier t'est donné dans le notebook ; en vrai, ce
> JSON viendrait de `requests.get(url).json()`.

1. Charge le JSON et transforme-le en DataFrame **exploitable** (les infos du client doivent devenir de vraies colonnes, pas un dictionnaire dans une case). Combien de commandes, et quelles colonnes obtiens-tu ?

2. On ne veut analyser que les commandes réellement encaissées (`statut == "payée"`). Sur ce sous-ensemble, donne le **chiffre d'affaires par ville** du client, de la ville la plus rentable à la moins rentable. *(tu combines : aplatir le JSON → filtrer → agréger → trier)*

3. Quel **segment** de client (`client.segment`) génère le plus gros chiffre d'affaires **payé** ?

4. **Réflexion (pas de code).** En une phrase : pourquoi `pd.json_normalize` plutôt qu'un simple `pd.DataFrame` sur ce JSON ?

---

*Quand c'est fait, envoie-moi le notebook. Ça boucle les nouveaux thèmes de la S4 (merge/concat, CTE,
pivot_table, apply/lambda, API→pandas) — il restera le **mini-projet cumulatif S1 → S4** pour clôturer.*
