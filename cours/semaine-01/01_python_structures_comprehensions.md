# Semaine 1 · Python — Structures de données & comprehensions

> Session du matin. Objectif : être à l'aise avec listes et dictionnaires (la colonne
> vertébrale de toute manipulation de données), puis savoir écrire des **comprehensions**
> pour transformer des données en une ligne, lisiblement. C'est la marche juste avant pandas.

---

## 1. Pourquoi ce thème pour un data engineer

En data, tu passes ton temps à manipuler des **listes** (des séries de valeurs, ex : une colonne)
et des **dictionnaires** (des enregistrements clé→valeur, ex : une ligne d'une table).
Les *comprehensions* te permettent d'écrire des transformations courantes (filtrer, calculer
une nouvelle colonne) en une seule ligne claire. Tu retrouveras exactement cette logique dans
pandas la semaine prochaine — c'est donc une base à solidifier maintenant.

---

## 2. Rappel express (tu connais déjà, on va vite)

### La liste — collection ordonnée et modifiable
```python
salaires = [38000, 42000, 45000]   # une liste de 3 nombres
salaires.append(50000)             # ajoute un élément à la fin
print(salaires[0])                 # accès par index (commence à 0) -> 38000
print(salaires[-1])                # dernier élément -> 50000
print(len(salaires))               # nombre d'éléments -> 4
```

### Le dictionnaire — des paires clé → valeur
```python
employe = {"prenom": "Victor", "salaire": 42000, "ville": "Rouen"}  # un "enregistrement"
print(employe["prenom"])     # accès par la clé -> "Victor"
employe["salaire"] = 45000   # on modifie une valeur
print(employe.keys())        # les clés -> dict_keys(['prenom', 'salaire', 'ville'])
print(employe.items())       # les paires (clé, valeur), utile pour boucler
```

### Quand utiliser quoi
Liste = quand l'ordre compte et que les éléments sont de même nature (une colonne de salaires).
Dictionnaire = quand chaque valeur a une étiquette (une ligne avec ses champs nommés).
Très souvent en data : **une liste de dictionnaires** = une table (chaque dict = une ligne).

---

## 3. Le cœur du jour : les comprehensions

### 3.0 L'astuce : lire le code comme une phrase

Avant la syntaxe, garde cette image en tête :

- la liste `employes` = une **boîte** ;
- chaque élément dedans (ici un dictionnaire) = une **feuille** ;
- la variable de boucle (`e`, `n`... peu importe le nom) = **la feuille qu'on regarde en ce moment**.

Puis traduis chaque mot-clé par un bout de phrase :

| Mot-clé | Se lit comme... |
|---------|-----------------|
| `for ... in ...` | « **pour chaque** feuille **dans** la boîte » |
| `if` | « **seulement si** (condition) » |
| `in` (en test) | « **est dans / appartient à** » |
| `while` | « **tant que** (condition vraie), répète » |

Une comprehension se lit alors comme une vraie phrase :

> « je veux `e["prenom"]`, **POUR chaque** feuille `e` **DANS** la boîte `employes` »

C'est exactement ton intuition — garde-la, elle est parfaite pour ne plus te tromper.

> Note : `while` ne s'utilise pas dans une comprehension (il sert à répéter tant qu'une condition
> reste vraie). Mais la traduction « tant que » reste la bonne quand tu le croiseras ailleurs.

### 3.1 List comprehension
Idée : construire une nouvelle liste **à partir** d'une autre, en une ligne.

La même chose, écrite des deux façons :
```python
# Version classique (boucle for)
doubles = []                 # liste vide au départ
for n in [1, 2, 3]:          # pour chaque élément
    doubles.append(n * 2)    # on calcule et on ajoute
# doubles -> [2, 4, 6]

# Version comprehension (1 ligne, équivalente)
doubles = [n * 2 for n in [1, 2, 3]]
# doubles -> [2, 4, 6]
```

La structure à retenir :
```
[  expression   for   element   in   iterable  ]
   (quoi mettre)      (variable)     (la source)
```

Lis-le à voix haute : « je veux `n * 2`, **POUR chaque** `n` **DANS** la liste `[1, 2, 3]` ».

### 3.2 Avec une condition (filtrer)
```python
# Garder seulement les nombres pairs
nombres = [1, 2, 3, 4, 5, 6]
pairs = [n for n in nombres if n % 2 == 0]   # le "if" filtre
# pairs -> [2, 4, 6]
```
Schéma :
```
[  n        for n in nombres   if n % 2 == 0  ]
  (garde n)  (chaque élément)   (seulement si pair)
```

Lis-le : « je veux `n`, **POUR chaque** `n` **DANS** `nombres`, **SEULEMENT SI** `n` est pair ».

### 3.3 Dict comprehension
Même principe, mais on construit un dictionnaire avec `{clé: valeur for ...}` :
```python
prenoms = ["Victor", "Data"]
# associer chaque prénom à sa longueur
longueurs = {p: len(p) for p in prenoms}
# longueurs -> {"Victor": 6, "Data": 4}
```

Lis-le : « je veux la paire `p: len(p)`, **POUR chaque** `p` **DANS** `prenoms` ».

### 3.4 La règle d'or
La comprehension est faite pour une transformation **simple** (calcul, filtre). Si la logique
devient compliquée (plusieurs conditions imbriquées, plusieurs étapes), reviens à une **boucle
for classique** : c'est plus lisible. Lisibilité > frime en une ligne.

---

## 4. À retenir (résumé)

- **Lis ta comprehension comme une phrase** : « je veux …, POUR chaque feuille DANS la boîte (, SEULEMENT SI …) ».
- Une **liste** = série ordonnée modifiable ; un **dict** = paires clé→valeur (un enregistrement).
- Une **liste de dicts** ≈ une table de données (1 dict = 1 ligne).
- **List comprehension** : `[expression for x in source]`, avec `if` optionnel pour filtrer.
- **Dict comprehension** : `{cle: valeur for x in source}`.
- Comprehension pour le simple, boucle `for` pour le compliqué.

---

## 5. Exercices

> **Ce que ces exercices entraînent :** transformer et filtrer une liste de données — exactement
> le geste que tu feras en boucle en data. Fais-les dans un fichier `exercices/python/s1_comprehensions.py`,
> teste avec `print(...)`, puis envoie-moi tes réponses : je corrige et je t'explique ce qui peut être amélioré.
> **Ne regarde pas de solution toute faite — c'est en cherchant que ça rentre.**

Jeu de données de départ (copie-le en haut de ton fichier) :
```python
employes = [
    {"prenom": "Victor", "salaire": 42000, "ville": "Rouen"},
    {"prenom": "Sarah",  "salaire": 38000, "ville": "Paris"},
    {"prenom": "Karim",  "salaire": 47000, "ville": "Rouen"},
    {"prenom": "Lina",   "salaire": 51000, "ville": "Lyon"},
]
```

1. Avec une **list comprehension**, construis la liste des **prénoms** seulement.
   Résultat attendu : `['Victor', 'Sarah', 'Karim', 'Lina']`.

2. Construis la liste des **salaires augmentés de 5 %**.
   *(Indice : `salaire * 1.05`.)*

3. **Filtre** : la liste des prénoms des personnes qui habitent à **Rouen**.
   Résultat attendu : `['Victor', 'Karim']`.

4. Avec une **dict comprehension**, construis un dictionnaire `{prénom: salaire}`.
   Résultat attendu : `{'Victor': 42000, 'Sarah': 38000, 'Karim': 47000, 'Lina': 51000}`.

5. (bonus) Liste des prénoms dont le **salaire dépasse 40000**.
   Résultat attendu : `['Victor', 'Karim', 'Lina']`.

---

*Quand tu as fait les 5, envoie-moi ton code. Ensuite on enchaîne sur la session SQL de l'après-midi.*
