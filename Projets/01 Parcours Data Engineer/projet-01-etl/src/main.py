"""Orchestration du pipeline ETL : Extract -> Transform -> Load.

Lancer depuis la racine du projet :  python src/main.py
"""
import logging

from extract import extract
from transform import transform
from load import load

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s")


def main():
    """Enchaîne les trois phases, avec un message de log à chaque étape."""
    # TODO 1 : ventes, catalogue = extract()   + logging.info du nombre de lignes lues
    # TODO 2 : df = transform(ventes, catalogue) + logging.info du nombre de lignes après nettoyage
    # TODO 3 : load(df)                          + logging.info "chargement terminé"
    raise NotImplementedError("Orchestre le pipeline : extract -> transform -> load")


if __name__ == "__main__":       # ne s'exécute que si on lance CE fichier directement
    main()
