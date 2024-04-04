from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from db_config import settings


# Piperoni Identity service uses PostgreSQL to persistent storage to hold all user authentication data
# SQLALCHEMY_DATABASE_URL = "postgresql://postgres:secret@localhost:5432/identity_database"
SQLALCHEMY_DATABASE_URL = settings.DATABASE_URL

# Create SQLAlchemy db engine
engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()