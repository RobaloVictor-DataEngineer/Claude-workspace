"""Phase LOAD — écrire le résultat propre dans PostgreSQL.

À toi d'écrire la logique. Les TODO décrivent ce que chaque étape doit faire.
"""
from sqlalchemy import create_engine


def load(df, table="ventes_propres"):
    """Écrit le DataFrame propre dans PostgreSQL (table `ventes_propres`).

    Rappel de la chaîne de connexion :
        postgresql+psycopg2://UTILISATEUR:MOT_DE_PASSE@HÔTE:PORT/BASE
    (les mêmes identifiants que dans DBeaver : postgres / ton mdp / localhost / 5432 / postgres)
    """
    # TODO 1 : engine = create_engine("postgresql+psycopg2://postgres:TON_MDP@localhost:5432/postgres")
    # TODO 2 : df.to_sql(table, engine, if_exists="replace", index=False)
    raise NotImplementedError("Écris la phase Load")
