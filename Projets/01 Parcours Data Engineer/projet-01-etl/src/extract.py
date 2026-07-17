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
    # TODO 2 : lire data/raw/catalogue.json et l'aplatir en DataFrame `catalogue`
    #          (indice : json.load(...) puis pd.json_normalize(..., sep="_")).
    # TODO 3 : return ventes, catalogue
    raise NotImplementedError("Écris la phase Extract")
