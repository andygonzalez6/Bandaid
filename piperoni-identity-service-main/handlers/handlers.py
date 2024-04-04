from fastapi import Depends
from handlers.db_handler import DBHandler
from services.current_user_service import CurrentUserService
from database import get_db

def get_db_handler(db=Depends(get_db)):
    return DBHandler(db)


def get_current_user_service(db_handler=Depends(get_db_handler)):
    return CurrentUserService(db_handler)