// Exercice S7 — Java (survol) : une classe Produit + un main qui la teste.
// Lancer (Java 11+, JDK installé) :  java Produit.java
// À toi d'écrire le code : les TODO décrivent quoi faire, la logique est à toi.

public class Produit {

    // TODO 1 : deux attributs typés
    //   - un String  nom
    //   - un double  prix
        String nom;
        double prix;


    // TODO 2 : le constructeur
        public Produit(String nom, double prix) 
        { 
            this.nom = nom;
            this.prix = prix;
        }

    // TODO 3 : une méthode
    //   public double prixTTC() { ... }
    //   qui renvoie prix * 1.2
    public double prixTTC() 
    {
        return prix * 1.2;
    }


    public static void main(String[] args) 
    {
        // TODO 4 : crée deux produits (ex. new Produit("Clavier", 50)),
        //          puis affiche pour chacun son nom et son prix TTC
        //          (System.out.println(...)).
        Produit clavier = new Produit("Clavier", 50);
        Produit pc_portable = new Produit("PC portable", 1050);

        double prix_pc = pc_portable.prixTTC();
        double prix_clavier = clavier.prixTTC();

        System.out.println("prix du clavier :  " + prix_clavier);
        System.out.println("prix du pc :  " + prix_pc + "\n\n");

        // TODO 5 : une boucle for qui affiche les nombres de 1 à 5.
        for(int i = 1; i<=5; i++){
            System.out.println(i);
        }
    }
}
