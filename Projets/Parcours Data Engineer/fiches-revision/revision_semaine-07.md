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

## Consolidation post-coupure d'août (01-04/09) — à re-tester le 11/09

> Pas de nouveau cours cette semaine : programme express de remise à niveau (S1-S7) après un mois sans pratique. Les 2 points ci-dessous sont les seuls encore fragiles ; le reste (window functions, `groupby` nommé, `pivot_table`, `apply`/`lambda`, merge) est validé.

### SQL — cumul sur un total déjà groupé (double `SUM`)
**Idée :** pour cumuler un total par groupe (ex. CA du jour) au fil du temps, il faut d'abord **agréger**, puis **cumuler** — deux étages de `SUM`.
**Syntaxe :**
```sql
SELECT date, SUM(SUM(montant)) OVER (ORDER BY date) AS cumul
FROM ventes
GROUP BY date;
```
**Piège :** un seul `SUM(montant) OVER (...)` sans le `GROUP BY` cumule les lignes individuelles, pas les totaux du jour — faux dès qu'une date a plusieurs lignes.

### SQL — CTE sans `GROUP BY`
**Idée :** une CTE censée produire un total par groupe a besoin de **son propre** `GROUP BY` — sans lui, `SUM()` agrège tout en une seule ligne.
**Syntaxe :**
```sql
WITH ca_client AS (
    SELECT client, SUM(montant) AS ca
    FROM ventes
    GROUP BY client        -- indispensable ici
)
SELECT * FROM ca_client WHERE ca > 500;
```
**Piège :** l'oubli ne renvoie pas d'erreur — juste un résultat silencieusement faux (une seule ligne agrégée au lieu d'une par client).

### Python — mutabilité liste/tuple/set (toujours fragile)
**Idée :** liste `[]` = modifiable, tuple `()` = immuable (protégé), set `{}` = valeurs uniques, non ordonné.
**Syntaxe :**
```python
l = [1, 2]; l.append(3)   # OK, la liste change
t = (1, 2); t[0] = 9       # TypeError, le tuple est protégé
s = {1, 2, 2}               # {1, 2} — doublons supprimés
```
**Piège :** inversé le 01/09 **et** le 03/09 — mnémo « crochets = on change, parenthèses = protégé ».

---

*Statut : Semaine 7 en pause (Java + intro Spark faits avant la coupure). Semaine du 01-07/09 = remise à niveau S1-S7 post-vacances (voir `quiz_journal.md` et `Programme_remise_a_niveau.md`) ; 2 points encore fragiles ci-dessus, à re-tester le 11/09. Prochaine étape : boucler ces 2 points, puis relancer S7 (mini-projet + candidatures).*
