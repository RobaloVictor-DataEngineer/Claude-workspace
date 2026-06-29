# Semaine 1 · Livrable Python — Lire un CSV proprement

> Dernier morceau du livrable S1 (repo ✅ + 10 requêtes SQL ✅ + **ce script CSV**).
> Tu ne pars pas de zéro : le squelette est dans `exercices/python/livrable/lire_csv.py`,
> le dataset dans `exercices/python/livrable/data/produits.csv`. **À toi de coder les `TODO`.**

---

## 1. Ce que tu dois en retenir (avant de commencer)

Un data engineer passe sa vie à **lire des fichiers de données et à survivre aux lignes pourries**.
Ce livrable entraîne exactement ce réflexe : lire un CSV, et **ne pas planter** quand une valeur est
absente ou invalide. C'est la fusion concrète de tes 3 notions de la semaine :

- **fonctions** : découper le travail (`lire_produits`, `afficher_resume`) ;
- **try/except** : `FileNotFoundError` (fichier absent) + `ValueError` (prix non convertible) ;
- **comprehensions** (bonus) : pour calculer le prix moyen en une ligne.

---

## 2. La seule notion vraiment nouvelle : le module `csv`

`CSV` = *Comma-Separated Values* : un fichier texte où chaque ligne est un enregistrement et les
colonnes sont séparées par une virgule. La 1re ligne est l'en-tête (les noms de colonnes).

```python
import csv

with open("data/produits.csv", encoding="utf-8") as f:   # with = ferme le fichier tout seul à la fin
    lecteur = csv.DictReader(f)        # DictReader : lit chaque ligne comme un DICTIONNAIRE
    for ligne in lecteur:              # ligne = {"id_produit": "1", "nom": "Clavier", "prix": "89.90", ...}
        print(ligne["nom"], ligne["prix"])
```

Point clé : **tout ce que `csv` te renvoie est du texte** (`"89.90"`, pas `89.90`). Le prix doit
donc être converti avec `float(...)` — et c'est là qu'un `try/except ValueError` devient utile,
parce que le dataset contient exprès des prix invalides.

---

## 3. Le piège volontaire dans `produits.csv`

Deux lignes sont « sales », comme dans la vraie vie :

- ligne `Webcam HD` → prix = `abc` (texte impossible à convertir → `ValueError`) ;
- ligne `Disque SSD 1To` → prix **vide** (`float("")` → `ValueError` aussi).

Un script naïf planterait sur la 5e ligne. Le tien doit **avertir et continuer** (`continue`),
puis ne garder que les 8 produits valides.

---

## 4. Le cahier des charges (ce que ton script doit faire)

1. `lire_produits(chemin)` : ouvre le fichier (try/except `FileNotFoundError` → renvoie `[]`),
   lit les lignes, convertit chaque prix en `float` dans un try/except `ValueError`
   (ligne invalide → message + on l'ignore), renvoie la liste des produits valides.
2. `afficher_resume(produits)` : si liste vide → le signaler ; sinon afficher le **nombre** de
   produits chargés et le **prix moyen**.

Résultat attendu (à peu près) :

```
[!] Prix invalide ignoré : Webcam HD (abc)
[!] Prix invalide ignoré : Disque SSD 1To ()
8 produits chargés.
Prix moyen : 68.60 €
```

---

## 5. Comment lancer / vérifier

Depuis le dossier `exercices/python/livrable/` :

```bash
python lire_csv.py
```

(Le chemin `data/produits.csv` est relatif : lance le script **depuis ce dossier**, sinon il ne
trouvera pas le fichier — et tu testeras ton try/except `FileNotFoundError` sans le vouloir !)

---

## 6. Quand c'est fait

Envoie-moi ton `lire_csv.py`, je le corrige. Ensuite : `git add` + commit
(« S1 : livrable script CSV ») + push, on coche S1 dans le Planning, et la **Semaine 1 est bouclée**.
On enchaîne sur la Semaine 2 (pandas + SQL intermédiaire).
