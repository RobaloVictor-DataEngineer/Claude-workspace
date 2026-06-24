# Semaine 1 · Python — La gestion d'erreurs (try / except)

> Session Python. Notion **nouvelle** pour toi, donc code commenté ligne par ligne. C'est ce qui
> rend un code « solide » : capable de continuer même quand quelque chose se passe mal.

---

## 1. Pourquoi c'est essentiel pour un data engineer

Ton code va lire des fichiers, appeler des API, convertir des types... et **plein de choses peuvent
échouer** : un fichier absent, une valeur impossible à convertir, une clé manquante. Sans gestion
d'erreurs, le programme **plante et s'arrête net**. Le `try/except` permet d'attraper l'erreur, de
réagir proprement, et de **continuer**. C'est la base d'un pipeline ETL robuste.

---

## 2. Le problème, sans gestion d'erreurs

```python
nombre = int("abc")     # ValueError : impossible de convertir "abc" -> le programme PLANTE ici
print("la suite")       # cette ligne n'est JAMAIS atteinte
```

Tout s'arrête à la première erreur. En production, un pipeline qui s'arrête sur une ligne de données
bizarre, c'est un pipeline cassé.

---

## 3. La structure try / except

```python
try:
    nombre = int("abc")                       # le code "à risque"
except ValueError:                            # SI une ValueError survient...
    print("Ce n'est pas un nombre valide")    # ...on fait ça à la place
print("la suite")                             # et le programme CONTINUE normalement
```

Lis-le comme une phrase : « **ESSAIE** ceci ; **EN CAS D'**erreur de ce type, fais cela. »
Le mot-clé `try` = « essaie », `except` = « sauf si (cette erreur) ».

---

## 4. Les erreurs courantes (à cibler)

- `ValueError` : conversion impossible (`int("abc")`).
- `ZeroDivisionError` : division par zéro.
- `FileNotFoundError` : fichier introuvable.
- `KeyError` : clé absente d'un dictionnaire.
- `TypeError` : opération entre types incompatibles.

On précise le type pour ne traiter que l'erreur attendue.

---

## 5. Récupérer le message de l'erreur

```python
try:
    resultat = 10 / 0
except ZeroDivisionError as e:     # "as e" = on récupère l'erreur dans la variable e
    print("Erreur :", e)           # affiche le message de l'erreur
```

---

## 6. else et finally (pour aller plus loin)

- `else` : s'exécute **seulement si aucune** erreur n'est survenue.
- `finally` : s'exécute **toujours** (erreur ou pas) — utile pour nettoyer (fermer un fichier).

```python
try:
    f = open("data.csv")               # tentative à risque
except FileNotFoundError:
    print("Fichier introuvable")       # si le fichier n'existe pas
else:
    print("Fichier ouvert")            # seulement si l'ouverture a réussi
finally:
    print("Fin de la tentative")       # dans tous les cas
```

---

## 7. Bonne pratique

**Cible toujours le type d'erreur précis** (`except ValueError:`), n'écris pas un `except:` tout nu :
celui-ci attrape *toutes* les erreurs, y compris les vrais bugs, et les masque — tu ne saurais plus
ce qui ne va pas.

---

## 8. À retenir

- `try:` = le code à risque ; `except TypeErreur:` = quoi faire si cette erreur survient.
- Sans gestion, la première erreur **arrête tout** ; avec, le programme **continue**.
- `as e` récupère le message de l'erreur.
- `finally` s'exécute toujours (nettoyage) ; `else` seulement si pas d'erreur.
- Cible le type précis, jamais d'`except:` nu.

---

## 9. Exercices

> **Ce qu'ils entraînent :** rendre un code robuste face à des entrées invalides — le réflexe d'un
> code de production. Mets ton code dans `exercices/python/s1_try_except.py` et envoie-le-moi.

1. Écris une fonction `division(a, b)` qui renvoie `a / b`, mais qui **attrape la division par zéro**
   et renvoie le texte `"Division par zéro impossible"` au lieu de planter. Teste avec `(10, 2)` puis `(10, 0)`.

2. Écris une fonction `convertir_entier(texte)` qui renvoie `int(texte)`, mais qui, en cas de
   `ValueError`, affiche `"Conversion impossible"` et renvoie `None`. Teste avec `"42"` puis `"bonjour"`.

3. Soit `produit = {"nom": "Clavier", "prix": 89.9}`. Écris un accès à la clé `"stock"` protégé par
   un `try/except KeyError` qui affiche `"stock non renseigné"` si la clé n'existe pas.

4. Écris un `try/except` qui tente d'ouvrir le fichier `"inexistant.csv"` (`FileNotFoundError`), et
   ajoute un bloc `finally` qui affiche `"Tentative terminée"` dans tous les cas.

5. **Réflexion (pas de code).** En une phrase : pourquoi vaut-il mieux écrire `except ValueError:`
   plutôt qu'un `except:` tout nu ?

---

*Quand c'est fait, envoie ton fichier. Après ça, il ne te restera que le **livrable de la Semaine 1**
(un script Python qui lit un CSV + ton repo à jour) pour boucler la semaine.*
