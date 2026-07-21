import os
import logging
from dotenv import load_dotenv
from sqlalchemy import create_engine, URL

load_dotenv()   # charge le .env dans les variables d'environnement

def load(df, table="ventes_catalogues_propres"):
    url = URL.create(
        "postgresql+psycopg2",
        username=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),   # plus jamais en dur
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        database=os.getenv("DB_NAME"),
    )
    engine = create_engine(url)
    df.to_sql(table, engine, if_exists="replace", index=False)
    logging.info("Chargement terminé : %d lignes dans %s", len(df), table)