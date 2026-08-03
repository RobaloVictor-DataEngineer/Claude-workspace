# Fiche de révision — Semaine 7 (Java survol + intro Spark)

> Antisèche entretien. Deux thèmes indépendants : **Java** (savoir lire, pas maîtriser) et **Spark** (calcul distribué, pandas à grande échelle). Semaine où les premières candidatures démarrent.

---

### Java — typé et compilé (vs Python dynamique/interprété)
**Idée :** Java **déclare** le type de chaque variable et **compile** le code avant de l'exécuter ; Python déduit le type et l'exécute directement. Résultat : Java plus verbeux, plus strict.
**Syntaxe :**
```java
int quantite = 3;              // type déclaré, fixé
double prix = 12.5;             // double = nombre à virgule
System.out.println("Total : " + (quantite * prix));
```
**Piège :** une fois le type déclaré (`int`), il ne change plus — pas d'équivalent du `x = 5` puis `x = "texte"` de Python.

### Anatomie d'un programme Java
**Idée :** tout vit dans une **classe** ; le point d'entrée est toujours `public static void main(String[] args)`.
**Syntaxe :**
```java
public class Demo {                              // fichier = Demo.java (même nom que la classe)
    public static void main(String[] args) {     // point d'entrée, à apprendre par cœur
        System.out.println("Bonjour");           // System.out.println = print
    }
}
```
**Piège :** `;` en fin d'instruction et `{ }` pour délimiter les blocs — Java ignore l'indentation (contrairement à Python où elle est structurante).

### Boucle `for` Java — les 3 temps
**Idée :** même logique qu'en Python (répéter un bloc), mais la syntaxe explicite départ/condition/incrément.
**Syntaxe :**
```java
for (int i = 0; i < 3; i++) {   // départ ; tant que ; incrément
    System.out.println(i);      // affiche 0, 1, 2
}
```
**Piège :** c'est la construction qui déroute le plus au début — toujours la lire en 3 morceaux séparés par `;` (pas de virgule).

### Classe Java — `this` = `self`, constructeur = `__init__`
**Idée :** même concept qu'en Python (attributs + méthodes) mais typé, avec un vocabulaire différent.
**Syntaxe :**
```java
public class Compte {
    String titulaire;                                 // attribut typé
    double solde;
    public Compte(String titulaire, double solde) {   // constructeur = __init__
        this.titulaire = titulaire;                    // this = self
        this.solde = solde;
    }
    public void deposer(double montant) {              // void = ne renvoie rien
        this.solde = this.solde + montant;
    }
}
```
**Piège :** créer un objet exige `new` (`new Compte("Victor", 100)`) — sans lui, pas d'instanciation ; c'est `new` qui déclenche le constructeur.

### Collections Java — List et Map (à reconnaître, pas maîtriser)
**Idée :** les équivalents typés des listes et dictionnaires Python.
**Syntaxe :**
```java
List<Integer> liste = new ArrayList<>();   // équivalent de liste = [1, 2, 3]
liste.add(1);
Map<String, Integer> dico = new HashMap<>();   // équivalent de dico = {"a": 1}
dico.put("a", 1);
```
**Piège :** le `<Integer>` ou `<String, Integer>` précise **le type des éléments** — Java ne l'omet jamais, contrairement à une liste Python qui peut mélanger les types.

---

### Spark — le problème résolu (calcul distribué)
**Idée :** pandas charge toutes les données dans la RAM d'**une** machine ; si ça dépasse, ça plante. **Spark** découpe les données et les répartit sur plusieurs machines (un **cluster**) qui calculent **en parallèle** = calcul distribué.
**Syntaxe :** pas de code — repère mental : pandas jusqu'à quelques Go, Spark au-delà.
**Piège :** ne pas sortir Spark pour un petit fichier (10 Mo) — c'est un marteau-pilon inutile, la complexité d'un cluster n'est justifiée que par le volume.

### DataFrame Spark (PySpark) — l'API proche de pandas
**Idée :** un DataFrame Spark est un tableau lignes/colonnes comme pandas, mais réparti sur le cluster. **PySpark** = l'interface Python de Spark.
**Syntaxe :**
```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()          # point d'entrée Spark
df = spark.read.csv("ventes.csv", header=True, inferSchema=True)
df.filter(df["montant"] > 100)                       # filtrer (vs df[...] en pandas)
df.groupBy("ville").sum("montant")                   # agréger (B majuscule, vs groupby)
```
**Piège :** `spark.read.csv(...)` (avec `.read.`), pas `spark.read_csv(...)` — attention à ne pas transposer le nom de la méthode pandas telle quelle.

### Lazy evaluation — l'idée clé de Spark
**Idée :** Spark **n'exécute rien** tant qu'on ne demande pas explicitement un résultat — il empile les opérations dans un **plan** et n'exécute qu'au dernier moment, contrairement à pandas où chaque ligne calcule immédiatement.
**Syntaxe :**
```python
df2 = df.filter(df["montant"] > 100)   # transformation : rien ne se calcule
df3 = df2.groupBy("ville").sum()       # transformation : toujours rien
df3.show()                              # action : exécute TOUT le plan maintenant
```
**Piège :** confondre transformation et action revient à croire qu'un `filter` ou un `groupBy` a déjà « fait le travail » — en réalité rien ne s'exécute avant une action.

### Transformations vs actions — le réflexe pour trancher
**Idée :** une **transformation** (`filter`, `select`, `groupBy`, `withColumn`) décrit un calcul sans l'exécuter (lazy) ; une **action** (`show`, `count`, `collect`, `write`) déclenche l'exécution et renvoie un résultat concret.
**Syntaxe :** réflexe — « ça me rend un résultat concret (lignes, nombre, fichier) ? » Oui → action. Non → transformation.
**Piège :** l'avantage du lazy n'est pas la paresse en soi mais l'**optimisation** : Spark voit toute la chaîne avant d'exécuter et peut réordonner/simplifier (ex. ne lire que les colonnes utiles).

---

*Statut : Semaine 7 en cours (Java + intro Spark faits ; exercice Java à corriger si soumis, exercice Spark écrit corrigé). Prochaine étape : 2e projet portfolio (S8) + suivi des premières candidatures.*
