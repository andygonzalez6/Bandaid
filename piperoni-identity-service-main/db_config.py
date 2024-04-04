import os
from dotenv import load_dotenv
from pathlib import Path

# Setting class to Postgres database configuration
env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)

class Settings:
    PROJECT_NAME:str = "Piperoni Identity Service"
    PROJECT_VERSION: str = "1.0.0"

    POSTGRES_USER : str = os.getenv("POSTGRES_USER", "postgres")
    POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "secret")
    POSTGRES_SERVER : str = os.getenv("POSTGRES_SERVER", "local") # change default to local if you doing local development
    POSTGRES_PORT : str = os.getenv("POSTGRES_PORT", 5432) # default postgres port is 5432
    POSTGRES_DB : str = os.getenv("POSTGRES_DB", "identity_database")
    DATABASE_URL = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_SERVER}:{POSTGRES_PORT}/{POSTGRES_DB}"

settings = Settings()

# local dev: docker run --name local-dev-container -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=identity_database -p 5432:5432 -d postgres:latest