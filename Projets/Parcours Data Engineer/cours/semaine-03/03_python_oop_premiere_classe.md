# Semaine 3 · Python — Ta première classe (OOP)

> Session Python. Nouveau gros morceau : l'**OOP** (Object-Oriented Programming = programmation orientée
> objet). Jusqu'ici tu écrivais des fonctions qui manipulent des données passées en argument. Une
> **classe** te permet de **regrouper des données ET les fonctions qui vont avec** dans un même objet.
> Tu n'en écriras pas des tonnes en data engineering, mais tu en **liras partout** (SQLAlchemy, Spark,
> tes propres pipelines) : il faut savoir ce que c'est et en créer une simple.

---

## 1. Pourquoi ce thème

Imagine un compte bancaire : il a des **données** (le solde, le titulaire) et des **actions** (déposer,
retirer). Avec des fonctions séparées, tu trimballes le solde à la main partout. Une **classe** met les
deux ensemble : chaque objet « compte » connaît son propre solde et sait se modifier lui-même. C'est
plus propre, et c'est la brique de base de la plupart des bibliothèques que tu utiliseras.

---

## 2. Le vocabulaire (4 mots à fixer)

- **Classe** = le *moule*, le plan. On la définit une fois (ex. « un CompteBancaire, en général »).
- **Instance** (ou objet) = un exemplaire concret créé à partir du moule (ex. « le compte de Victor »).
- **Attribut** = une *donnée* stockée dans l'objet (ex. `solde`, `titulaire`).
- **Méthode** = une *fonction* attachée à l'objet, qui agit sur ses attributs (ex. `deposer`).

```
   Classe CompteBancaire  (le moule)
            │  on crée des instances
    ┌───────┴────────┐
 compte_victor    compte_sarah      ← 2 instances, chacune SON solde
 solde = 100      solde = 500
```

---

## 3. La structure d'une classe

```python
class CompteBancaire:                     # class + Nom en PascalMajuscule (convention)
    def __init__(self, titulaire, solde=0):   # le constructeur (voir §4)
        self.titulaire = titulaire        # on range les données DANS l'objet (self)
        self.solde = solde                # solde=0 par défaut si non précisé

    def deposer(self, montant):           # une méthode = une action de l'objet
        self.solde = self.solde + montant # elle modifie l'attribut de CET objet
```

Deux choses nouvelles à décortiquer : `__init__` et `self`.

---

## 4. `__init__` : le constructeur

`__init__` (deux underscores de chaque côté) est une méthode **spéciale, appelée automatiquement**
quand tu crées un objet. Son rôle : **initialiser les attributs** de départ. Tu ne l'appelles jamais
toi-même — Python la déclenche au moment de la création.

```python
compte_victor = CompteBancaire("Victor", 100)   # __init__ s'exécute ici, tout seul
# -> crée un objet avec titulaire="Victor" et solde=100
```

---

## 5. `self` : « moi, cet objet-ci »

`self` représente **l'objet en train d'être manipulé**. C'est toujours le premier paramètre des
méthodes, et c'est par lui qu'on lit/écrit les attributs (`self.solde`). Tu ne le passes jamais à la
main : Python met l'objet à sa place automatiquement.

```python
compte_victor.deposer(50)      # Python appelle deposer(self=compte_victor, montant=50)
# self.solde = self.solde + 50 -> le solde de compte_victor passe de 100 à 150
```

Retiens l'image : `self` = « le compte sur lequel on est en train d'agir ». Sans `self.`, tu créerais
une variable locale qui disparaît à la fin de la méthode, au lieu de modifier l'objet.

---

## 6. Chaque instance a son propre état

C'est tout l'intérêt : deux objets de la même classe sont **indépendants**.

```python
a = CompteBancaire("Victor", 100)
b = CompteBancaire("Sarah", 500)
a.deposer(50)
print(a.solde)   # 150
print(b.solde)   # 500  (b n'a pas bougé : c'est un autre objet)
```

---

## 7. Une méthode peut décider, pas seulement calculer

Une méthode contient du code normal : conditions, `return`, etc. Ici, refuser un retrait trop grand.

```python
    def retirer(self, montant):
        if montant > self.solde:              # on vérifie avant d'agir
            print("Retrait refusé : solde insuffisant")
            return
        self.solde = self.solde - montant
```

---

## 8. Piège 1 — `self.x` ou `x` tout court : lequel est appelé ?

C'est LA source de confusion au début. Règle simple, sans exception :

- **`self.x`** = l'**attribut de l'objet**. Il est **partagé par toutes les méthodes** de la classe et
  survit entre les appels (c'est l'état de l'objet).
- **`x` tout seul** (sans `self.`) = une **variable locale** à la méthode : elle naît quand la méthode
  s'exécute et **disparaît à la fin**. Les autres méthodes ne la voient pas.

```python
class CompteBancaire:
    def __init__(self, solde):
        self.solde = solde              # ATTRIBUT : visible partout via self.solde

    def deposer(self, montant):         # 'montant' = variable LOCALE (le paramètre)
        bonus = 5                        # 'bonus' = locale aussi : perdue à la fin
        self.solde = self.solde + montant + bonus   # on écrit dans l'attribut
```

**Ta question : et si un paramètre porte le même nom qu'un attribut ?** Aucun conflit, car `self.`
les distingue. Dans ton panier, `self.nom` (le client) et le paramètre `nom` de `ajouter_article` (le
produit) coexistent : à l'intérieur de la méthode, `nom` = le paramètre, `self.nom` = l'attribut.

```python
def ajouter_article(self, nom, prix):   # 'nom' ici = le produit (local)
    self.liste_articles.append(nom)      # on range le produit...
    print(self.nom, "a ajouté", nom)     # self.nom = le client ; nom = le produit
```

**Et si 3 méthodes ont chacune un paramètre `montant` ?** Ce sont **3 variables locales distinctes**,
sans rapport entre elles. La seule chose vraiment partagée entre les méthodes, c'est ce qui a un
`self.` devant. Retiens : *le trait d'union entre les méthodes, c'est `self.`*.

---

## 9. Piège 2 — où définir les attributs : dans `__init__`, pas au détour d'une méthode

Tout ce qui est **l'état** de l'objet (ses données de base) doit être créé dans `__init__`, pour que
**toutes** les méthodes puissent compter dessus. Si tu crées un attribut dans une méthode pour le
relire dans une autre, tu fabriques une **dépendance d'ordre** invisible :

```python
# ❌ fragile
def montant(self):
    self.total = sum(self.liste_prix)     # crée self.total ICI
def remise(self, pct):
    return self.total * (1 - pct/100)     # PLANTE si montant() n'a pas été appelé avant
```

Une valeur qui se **calcule** (total, nombre d'articles) ne se **stocke pas** : on la **recalcule et
on la renvoie** à chaque fois. Pas d'attribut caché, pas d'ordre d'appel imposé :

```python
# ✅ robuste
def total(self):
    return sum(self.liste_prix)
def remise(self, pct):
    return self.total() * (1 - pct/100)   # appelle total(), toujours à jour
```

Règle : **`__init__` = l'état** (les données) ; **les méthodes = des calculs qui renvoient**, pas des
cachettes à résultats.

---

## 10. Piège 3 — rendre deux instances vraiment indépendantes

Deux objets doivent avoir chacun **leur propre** liste/état. Deux façons classiques de tout casser :

```python
# ❌ Piège A : attribut de CLASSE (défini hors de __init__) -> PARTAGÉ par tous les objets
class Panier:
    articles = []                     # une seule liste pour TOUS les paniers
    def ajouter(self, x):
        self.articles.append(x)
p1 = Panier(); p2 = Panier()
p1.ajouter("Clavier")
print(p2.articles)                    # ['Clavier'] -> p2 voit l'article de p1 !
```

```python
# ❌ Piège B : liste par défaut en argument -> la MÊME liste réutilisée à chaque objet
class Panier:
    def __init__(self, articles=[]):  # le [] n'est créé qu'UNE fois
        self.articles = articles
```

```python
# ✅ Bon réflexe : créer la liste DANS __init__ -> une nouvelle liste par objet
class Panier:
    def __init__(self):
        self.articles = []            # chaque instance a la sienne -> indépendantes
```

C'est exactement ce que tu as fait dans ton exercice (`self.liste_articles = []` dans `__init__`),
donc tes deux paniers étaient bien indépendants. Le piège, c'est de sortir le `[]` de `__init__`.

---

## 11. Piège 4 — `return` vs `print` dans une méthode (crucial)

Deux verbes qu'on confond tout le temps, alors qu'ils font des choses **opposées** :

- **`print(x)`** = *afficher* `x` à l'écran, pour un humain qui lit. La méthode, elle, ne **rend rien** :
  elle renvoie `None`.
- **`return x`** = *renvoyer* `x` au code qui a appelé la méthode. La valeur devient **réutilisable** :
  on peut la stocker, la recalculer, la passer à une autre méthode.

Dans une classe, c'est encore plus important, parce que **tes méthodes se nourrissent entre elles**.

```python
# ❌ la méthode AFFICHE mais ne renvoie rien
def total(self):
    print(sum(self.liste_prix))     # affiche à l'écran... et renvoie None
t = panier.total()                  # t vaut None (rien n'est "sorti" de la méthode)
apres_remise = t * 0.9              # ERREUR : None * 0.9 -> plantage
```

```python
# ✅ la méthode RENVOIE une valeur réutilisable
def total(self):
    return sum(self.liste_prix)     # renvoie le nombre
t = panier.total()                  # t vaut 506.1
apres_remise = panier.total() * 0.9 # marche : on réutilise la valeur renvoyée
```

Règle : **une méthode qui calcule doit `return`.** Si tu veux *en plus* un affichage, sépare les deux :
la méthode **renvoie**, et tu fais `print(panier.total())` là où tu en as besoin. Un `print` *à
l'intérieur* d'une méthode de calcul, c'est un **cul-de-sac** : la valeur ne sort jamais de la méthode.

> Test mental : « est-ce que je voudrais **réutiliser** ce résultat ailleurs (l'additionner, le comparer,
> le passer à une autre méthode) ? » → si oui, c'est un `return`, pas un `print`. C'est exactement ce qui
> manquait à ton `Montant()` / `Remise()` : `Remise` ne pouvait pas se servir du total parce qu'il n'était
> qu'affiché.

---

## 12. À retenir

- **Classe** = le moule ; **instance** = un objet créé ; **attribut** = donnée ; **méthode** = action.
- `class NomEnPascalCase:` puis des méthodes indentées dedans.
- `__init__(self, ...)` = **constructeur**, appelé automatiquement à la création, initialise les attributs.
- `self` = l'objet courant ; on accède à ses données par `self.attribut`. Toujours 1er paramètre des méthodes.
- On crée un objet avec `NomClasse(arguments)` ; on appelle une méthode avec `objet.methode(args)`.
- Chaque instance a son **propre état**, indépendant des autres.
- **`self.x`** = attribut partagé par toutes les méthodes ; **`x` seul** = variable locale, perdue à la fin de la méthode. `self.` lève toute ambiguïté de nom.
- **`__init__` porte l'état** ; une valeur calculée (total, compte) se **renvoie** dans une méthode, elle ne se stocke pas dans un attribut lu ailleurs (sinon dépendance d'ordre + bugs).
- Pour des instances **indépendantes** : créer les listes/dicts **dans `__init__`** (`self.x = []`), jamais comme attribut de classe ni comme argument par défaut.
- **`return` renvoie une valeur réutilisable ; `print` ne fait qu'afficher (et renvoie `None`).** Une méthode qui calcule doit `return`.

---

## 13. Exercice

> **Ce que tu dois en retenir :** transformer un besoin concret en une classe qui **porte ses données
> et ses actions**. Ici tu ne modélises pas un solde unique (comme l'exemple), mais une **collection**
> qui grandit — ce qui t'oblige à stocker une **liste** dans l'objet et à la parcourir dans tes méthodes
> (donc à recombiner l'OOP avec ce que tu sais déjà des listes/boucles). Travaille dans
> `exercices/python/s3_3_oop_premiere_classe.ipynb` (l'exemple `CompteBancaire` est en haut, à exécuter ;
> l'énoncé est en dessous). **À toi de décider quels attributs et quelles méthodes créer.**

**Contexte : un panier d'achats en ligne.**

Tu dois écrire une classe qui représente le **panier** d'un client. À sa création, le panier est
**vide** et connaît le **nom du client**. Ensuite, il doit savoir faire les choses suivantes :

1. **Ajouter un article** au panier — on lui donne un nom de produit et un prix. (Indice : à la
   création, prépare un attribut qui est une **liste vide** ; ajouter = y ranger l'article.)

2. Dire **combien d'articles** le panier contient à cet instant.

3. Donner le **montant total** à payer (la somme des prix des articles).

4. **Appliquer une remise** en pourcentage sur le total (ex. 10 %) et renvoyer le montant à payer après
   remise — sans modifier les prix stockés.

Puis, pour tester : crée un panier pour un client, ajoute-lui **3 articles**, affiche le nombre
d'articles, le total, et le total après une remise de 10 %. Crée un **deuxième** panier pour un autre
client avec **1 seul article**, et vérifie que les deux paniers sont bien **indépendants**.

> Rappel liberté d'innover : si tu ajoutes une méthode utile en plus (ex. retirer un article, vider le
> panier), c'est bienvenu tant que les 4 comportements demandés y sont.

---

*Quand c'est fait, envoie-moi le notebook. Ce sera la fin des nouveaux thèmes de la S3 — ensuite, le
**mini-projet de synthèse cumulatif** (S1 → S3) pour boucler la semaine.*
