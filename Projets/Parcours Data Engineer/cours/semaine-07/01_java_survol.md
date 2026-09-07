# Semaine 7 · Java — Survol (savoir lire, écrire un petit programme)

> Objectif **volontairement limité** : pas de devenir développeur Java, mais savoir **lire** du code Java
> et en écrire un petit. Pourquoi ? Une grande partie de l'écosystème data (Spark, Hadoop, Kafka) tourne
> sur la **JVM** (Java Virtual Machine), et tu croiseras du Java/Scala en poste. En entretien, on ne te
> fera pas coder du Java complexe — mais savoir le lire et connaître ses différences avec Python est un plus.

---

## 1. La différence fondamentale avec Python

Python est **dynamique** (tu ne déclares pas les types) et **interprété** (il s'exécute directement).
Java est **typé statiquement** (tu déclares le type de chaque variable) et **compilé** (transformé en
code intermédiaire avant de tourner). Concrètement, Java est plus **verbeux** mais plus **strict**.

Le même mini-programme, dans les deux langages :

PYTHON :

```python
quantite = 3
prix = 12.5
total = quantite * prix
print("Total :", total)
```

JAVA :

```java
public class Demo {
    public static void main(String[] args) {
        int quantite = 3;              // on DÉCLARE le type : int (entier)
        double prix = 12.5;            // double = nombre à virgule
        double total = quantite * prix;
        System.out.println("Total : " + total);
    }
}
```

Ce qui saute aux yeux côté Java : les **types** devant chaque variable, les **`;`** en fin de ligne, les
**`{ }`** qui délimitent les blocs (pas l'indentation), et tout est **dans une classe**.

---

## 2. L'anatomie d'un programme Java

```java
public class Demo {                              // 1) tout vit dans une CLASSE (même nom que le fichier Demo.java)
    public static void main(String[] args) {     // 2) le point d'entrée : la méthode main
        System.out.println("Bonjour");           // 3) afficher (l'équivalent de print)
    }
}
```

- **`public class Demo`** : le fichier doit s'appeler `Demo.java` (le nom de la classe = le nom du fichier).
- **`public static void main(String[] args)`** : LA méthode que Java exécute au lancement. À apprendre par
  cœur comme une formule — c'est toujours cette ligne.
- **`System.out.println(...)`** : afficher une ligne (le `print` de Java).
- Chaque instruction finit par **`;`** ; chaque bloc est entre **`{ }`**.

---

## 3. Les types de base

En Java tu déclares le type, et il ne change plus.

| Type Java | Contenu | Exemple |
|---|---|---|
| `int` | entier | `int n = 5;` |
| `double` | nombre à virgule | `double prix = 12.5;` |
| `boolean` | vrai/faux | `boolean actif = true;` |
| `String` | texte (avec un grand S) | `String nom = "Victor";` |

En Python, `n = 5` suffit et le type est déduit ; en Java, `int n = 5;` — le type est **écrit et fixé**.

---

## 4. Conditions et boucles

Même logique qu'en Python, autre syntaxe (parenthèses + accolades au lieu des `:` et de l'indentation).

**Condition** —

PYTHON :

```python
if solde > 100:
    print("ok")
else:
    print("insuffisant")
```

JAVA :

```java
if (solde > 100) {
    System.out.println("ok");
} else {
    System.out.println("insuffisant");
}
```

**Boucle `for`** (la forme classique de Java, à bien reconnaître) —

PYTHON :

```python
for i in range(3):        # 0, 1, 2
    print(i)
```

JAVA :

```java
for (int i = 0; i < 3; i++) {   // départ ; condition ; incrément
    System.out.println(i);
}
```

Le `for` Java se lit en 3 temps : **`int i = 0`** (départ), **`i < 3`** (tant que), **`i++`** (i augmente de 1
à chaque tour). C'est la construction Java qui déroute le plus au début — lis-la toujours comme ces 3 morceaux.

---

## 5. Une classe (tu connais déjà le concept)

Tu as écrit une classe en Python (S3). En Java, c'est la même idée — attributs + méthodes — mais **typé**.

PYTHON :

```python
class Compte:
    def __init__(self, titulaire, solde):
        self.titulaire = titulaire
        self.solde = solde
    def deposer(self, montant):
        self.solde = self.solde + montant
```

JAVA :

```java
public class Compte {
    String titulaire;                       // attributs DÉCLARÉS avec leur type
    double solde;

    public Compte(String titulaire, double solde) {   // le constructeur = le __init__ de Java
        this.titulaire = titulaire;                   // this = le self de Java
        this.solde = solde;
    }

    public void deposer(double montant) {   // void = la méthode ne renvoie rien
        this.solde = this.solde + montant;
    }
}
```

Correspondances à retenir : **`__init__` → le constructeur** (une méthode qui porte le nom de la classe) ;
**`self` → `this`** ; et il faut **déclarer le type** des attributs, des paramètres, et de ce que renvoie
chaque méthode (`void` = ne renvoie rien ; `double` = renvoie un nombre…).

**Créer un objet et l'utiliser.** Définir la classe ne suffit pas : il faut l'**instancier** (créer un
objet à partir du moule), puis appeler ses méthodes — et, si elles renvoient une valeur, la récupérer.

PYTHON :

```python
compte = Compte("Victor", 100)      # créer l'objet
compte.deposer(50)                  # appeler une méthode
print(compte.solde)                 # 150
```

JAVA :

```java
Compte compte = new Compte("Victor", 100);   // 'new' pour CRÉER l'objet -> déclenche le constructeur
compte.deposer(50);                           // appeler une méthode (avec ; )
System.out.println(compte.solde);             // 150
```

Deux points propres à Java :
- **`new`** est indispensable pour créer un objet (`new Compte(...)`) — c'est lui qui déclenche le constructeur.
- Si une méthode **renvoie** une valeur, tu peux la **stocker dans une variable typée** avant de t'en servir :

```java
double ttc = produit.prixTTC();     // on récupère le double renvoyé dans une variable
System.out.println(ttc);
```

---

## 6. Les collections (à reconnaître, pas à maîtriser)

Les équivalents des listes et dictionnaires Python :

| Python | Java |
|---|---|
| `liste = [1, 2, 3]` | `List<Integer> liste = new ArrayList<>();` puis `liste.add(1);` |
| `dico = {"a": 1}` | `Map<String, Integer> dico = new HashMap<>();` puis `dico.put("a", 1);` |

Le `<Integer>`, `<String, Integer>` indique **le type des éléments** (Java veut toujours savoir). Tu n'as
pas à les manier couramment — juste à comprendre ce que tu lis.

---

## 7. À retenir

- Java = **typé** (on déclare `int`, `double`, `String`…) et **compilé** ; plus verbeux et strict que Python.
- Tout vit dans une **classe** ; le point d'entrée est **`public static void main(String[] args)`** ; on affiche avec **`System.out.println`**.
- `;` en fin d'instruction, `{ }` pour les blocs (pas l'indentation).
- `for (int i = 0; i < n; i++)` = départ ; condition ; incrément.
- Une classe = attributs typés + **constructeur** (nom de la classe) + méthodes ; **`this`** = le `self` de Java ; **`void`** = ne renvoie rien.
- **Créer un objet** : `new NomClasse(...)` ; appeler une méthode : `objet.methode(...)` ; récupérer un retour dans une variable **typée** (`double ttc = produit.prixTTC();`).
- Objectif de la semaine : **lire** du Java et écrire un petit programme — pas plus.

---

## 8. Exercice

> **Ce que tu dois en retenir :** retrouver, en Java, les réflexes que tu as en Python (une classe, des
> attributs, un constructeur, une méthode, un `main` qui teste) — en ajoutant la contrainte des **types**.
> C'est un exercice de transposition, pas de nouvelle logique. Le squelette t'attend dans
> `exercices/java/Produit.java` (classe + `main` avec des `TODO`). **Écris le code toi-même.**
> (Note : en Java le fichier porte **le nom de la classe** — d'où `Produit.java`, et non la convention
> `sX_N` habituelle de tes autres exercices.)
>
> **Comment lancer** (il te faut un **JDK** installé — ex. Temurin/OpenJDK 17) : dans un terminal, depuis
> le dossier du fichier, `java Produit.java`. Java 11+ compile et exécute en une commande. Si tu n'as
> pas encore de JDK, écris quand même le code et envoie-le moi, je le relirai.

Consignes (dans le fichier) :
1. Complète la classe `Produit` : deux attributs typés (`String nom`, `double prix`), un **constructeur** qui les initialise, et une méthode `double prixTTC()` qui renvoie `prix * 1.2`.
2. Dans le `main`, crée **deux** produits, affiche pour chacun son nom et son prix TTC.
3. Ajoute une boucle `for` qui affiche les nombres de 1 à 5.

---

*Ensuite, dernier thème de la S7 : une **intro à Spark** (DataFrame distribué, lazy evaluation, différence
avec pandas). Et côté planning, c'est la semaine où tu lances tes **premières candidatures**.*
