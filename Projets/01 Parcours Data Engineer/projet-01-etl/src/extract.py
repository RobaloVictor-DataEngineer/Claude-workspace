"""Phase EXTRACT — lire les sources brutes.

À toi d'écrire la logique. Les TODO décrivent ce que chaque étape doit faire.
"""
import json
import logging

import pandas as pd


def extract():
    """Lit les données brutes et renvoie deux DataFrames : (ventes, catalogue).

    - ventes    : depuis data/raw/ventes_brutes.csv
    - catalogue : depuis data/raw/catalogue.json, APLATI (fournisseur en vraies colonnes)
    """
    # TODO 1 : lire data/raw/ventes_brutes.csv dans un DataFrame `ventes`,
    #          protégé par un try/except FileNotFoundError (logging.error puis `raise`).
    try:
        ventes = pd.read_csv("data/raw/ventes_brutes.csv")
        
    except FileNotFoundError as e:
        logging.error("Aucun fichier ventes_brutes.csv trouvé !")
        raise e
    else:
        logging.info(f"Ventes extraites avec succès : {len(ventes)} lignes lues.")
    
    # TODO 2 : lire data/raw/catalogue.json et l'aplatir en DataFrame `catalogue`
    #          (indice : json.load(...) puis pd.json_normalize(..., sep="_")).
    with open("data/raw/catalogue.json", encoding="utf-8") as f:
        catalogue = json.load(f)
    catalogue = pd.json_normalize(catalogue, sep="_")
    logging.info(f"Catalogue extrait avec succès : {len(catalogue)} lignes lues.")


    
    # TODO 3 : return ventes, catalogue
    return ventes, catalogue
