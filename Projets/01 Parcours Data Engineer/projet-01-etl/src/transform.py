"""Phase TRANSFORM — nettoyer et croiser les données.

À toi d'écrire la logique. Les TODO décrivent ce que chaque étape doit faire.
"""
import pandas as pd


def transform(ventes, catalogue):
    """Nettoie les ventes, les joint au catalogue, renvoie un DataFrame propre.

    Étapes attendues :
      1. supprimer les lignes strictement en double
      2. retirer les lignes sans quantité, puis convertir `quantite` en entier
      3. nettoyer `ville` : enlever les espaces autour + uniformiser la casse (-> Title)
      4. joindre au catalogue sur `produit_id` en GARDANT toutes les ventes
      5. créer la colonne `montant` = quantite * prix
    """
    # TODO 1 : dédoublonner
    # TODO 2 : quantite -> retirer les NaN, puis convertir en entier
    # TODO 3 : nettoyer ville (str.strip / str.title)
    # TODO 4 : joindre au catalogue (merge how="left") sur produit_id
    # TODO 5 : colonne montant
    # TODO 6 : return le DataFrame propre
    raise NotImplementedError("Écris la phase Transform")
