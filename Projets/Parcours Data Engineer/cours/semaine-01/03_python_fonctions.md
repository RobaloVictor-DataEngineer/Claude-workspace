# Semaine 1 · Python — Les fonctions (bien les écrire)

> Session Python. Tu connais déjà `def` et `return` ; ici on solidifie les points qui font la
> différence : paramètres vs arguments, valeurs par défaut, renvoyer plusieurs valeurs, et le
> piège `return` vs `print`. C'est la base pour organiser proprement ton futur code ETL.

---

## 1. Pourquoi ce thème pour un data engineer

Tout ton code de pipeline sera découpé en fonctions : `extract()`, `transform()`, `load()`.
Une fonction = un bloc **réutilisable** qui fait **une seule chose** clairement. Bien écrire ses
fonctions, c'est du code lisible, testable et facile à corriger — exactement ce qu'on évalue
quand on regarde ton code en entretien.

---

## 2. Rappel express

```python
def bonjour():            # def = je définis une fonction nommée "bonjour"
    return "Salut"        # return = ce que la fonction renvoie
print(bonjour())          # on l'appelle -> "Salut"
```

---

## 3. Paramètre vs argument (la nuance à connaître)

- **Paramètre** = la variable écrite dans la **définition**.
- **Argument** = la valeur réelle passée au **moment de l'appel**.

```python
def saluer(prenom):              # prenom = PARAMÈTRE
    return f"Salut {prenom}"
print(saluer("Victor"))          # "Victor" = ARGUMENT
```

---

## 4. Valeurs par défaut

Un paramètre peut avoir une valeur par défaut, utilisée si on ne donne rien à l'appel :

```python
def augmenter(salaire, taux=0.05):   # taux vaut 0.05 par défaut
    return salaire * (1 + taux)

augmenter(40000)         # 5 %  -> 42000.0
augmenter(40000, 0.10)   # 10 % -> 44000.0
```

> Règle : les paramètres **avec** valeur par défaut doivent venir **après** ceux sans défaut.

---

## 5. Arguments positionnels vs nommés

```python
augmenter(40000, 0.10)               # positionnel : Python se fie à l'ORDRE
augmenter(salaire=40000, taux=0.10)  # nommé : explicite, plus lisible
```

Les arguments nommés rendent l'appel clair quand il y a plusieurs paramètres — bonne habitude.

---

## 6. Renvoyer plusieurs valeurs

```python
def extremes(nombres):
    return min(nombres), max(nombres)   # renvoie deux valeurs (un tuple)

mini, maxi = extremes([3, 7, 2])        # on "déballe" les deux d'un coup
# mini = 2 , maxi = 7
```

---

## 7. Le piège classique : `return` vs `print`

- `print(...)` **affiche** quelque chose à l'écran (pour l'humain).
- `return ...` **renvoie** une valeur que le reste du code peut **réutiliser**.

```python
def carre_print(n):
    print(n * n)         # affiche, mais ne renvoie rien d'utilisable

def carre_return(n):
    return n * n         # renvoie : on peut s'en servir

total = carre_return(4) + 10   # marche -> 26
total = carre_print(4) + 10    # ERREUR : print ne renvoie rien (None)
```

Règle : une fonction qui **calcule** doit `return`. On garde `print` pour afficher.

---

## 8. Bonne pratique : la docstring

Une courte description entre triples guillemets, juste sous le `def` :

```python
def augmenter(salaire, taux=0.05):
    """Augmente un salaire d'un taux donné (5 % par défaut)."""
    return salaire * (1 + taux)
```

C'est ce qui s'affiche quand quelqu'un (ou toi dans 3 mois) cherche à quoi sert la fonction.

---

## 9. À retenir

- Une fonction fait **une seule chose**, et porte un nom qui le dit.
- **Paramètre** (dans la définition) ≠ **argument** (à l'appel).
- Valeur par défaut = `taux=0.05` ; les paramètres avec défaut viennent en dernier.
- Une fonction qui calcule **`return`**, elle ne `print` pas.
- Une docstring `"""..."""` décrit la fonction en une ligne.

---

## 10. Exercices

> **Ce qu'ils entraînent :** découper des calculs en petites fonctions réutilisables, avec des
> valeurs par défaut et plusieurs valeurs en sortie. Mets ton code dans
> `exercices/python/s1_fonctions.py`, teste avec `print(...)`, et envoie-moi le fichier.

1. Écris `salaire_annuel(salaire_mensuel)` qui renvoie le salaire mensuel × 12. Teste avec `3500`.

2. Écris `augmenter(salaire, taux=0.05)` avec une valeur par défaut. Appelle-la **deux fois** : une fois sans préciser le taux, une fois avec `0.10`.

3. Écris `prix_ttc(prix_ht, tva=0.20)` qui renvoie le prix TTC (TTC = HT × (1 + TVA)). Teste avec un prix HT de `100`.

4. Écris `extremes(nombres)` qui renvoie le minimum **et** le maximum d'une liste, puis récupère les deux dans `mini, maxi` et affiche-les. Teste avec `[12, 5, 28, 9]`.

5. **Réflexion (pas de code).** En une phrase : pourquoi utilise-t-on `return` plutôt que `print` quand on veut réutiliser le résultat d'une fonction ?

---

*Quand c'est fait, envoie ton fichier. Ensuite, session SQL : on interroge enfin ta base boutique (SELECT, WHERE, GROUP BY, JOIN).*
