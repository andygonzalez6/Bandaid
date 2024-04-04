from datetime import datetime, timedelta
from typing import Union
from jose import jwt
from fastapi.security import OAuth2PasswordBearer

# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = "ac23aa94a8995bfe87e76e084364bce7a2f299115ca0ac1fdd063f6971e10da2" # only for local dev purpose
ALGORITHM = "HS256"
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


def create_access_token(data: dict, expires_delta: Union[timedelta, None] = None): # Helper function that creates JWT tokens with expiration time
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=45)

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

    return encoded_jwt