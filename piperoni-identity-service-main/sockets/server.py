import socketio
from auth.auth_token import SECRET_KEY, ALGORITHM
from jose import jwt, JWTError
from database import SessionLocal
from handlers.db_handler import DBHandler
import logging

# Creating an object
logger = logging.getLogger()
 
# Setting the threshold of logger to INFO
logger.setLevel(logging.INFO)

sio_server = socketio.AsyncServer(
    async_mode = 'asgi',
    cors_allowed_origins = ["*"]
)


sio_app = socketio.ASGIApp(
    socketio_server=sio_server,
    socketio_path='sockets.io'
)

current_users = {} # hashmap that tracks of user id and their corresponding socket id

def validate_client_credential(token):
    try:
        with SessionLocal() as db_session:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            user_email = payload.get("sub")
            if not user_email:
                raise ConnectionRefusedError("Invalid Authentication provided from client.")
            
            db_handler = DBHandler(db_session)
            user = db_handler.get_user_by_email(user_email)
            if not user:
                raise ConnectionRefusedError("Invalid Authentication provided from client.")
    except JWTError:
        raise ConnectionRefusedError("Error occurred during token validation process.")
    finally:
        db_session.close()

    return user
    

@sio_server.event
async def connect(sid, environ, auth):
    # Extract token data on client connection event
    # Only allow socket connection if client provides valid authentication credentials
    auth_token = auth.get("Authorization", None)
    if not auth_token:
        raise ConnectionRefusedError("No Authentication Information provided from client.")
    
    # Sanity check
    client_identity = validate_client_credential(auth_token)
    # use the in memory hashmap to track connected clients' socket ids
    current_users[client_identity.id] = sid
    
    logger.info(f"SERVER: socket id: {sid} is assigned client: {client_identity} on initial connection.")
    logger.info(f"SERVER: all connected clients on server {current_users}")


@sio_server.event
async def private_dm(sid, data):
    content = data.get("content", None)
    receiver_id = data.get("receiver_id", None)
    auth_token = data.get("auth_token", None)

    if not content or not receiver_id or not auth_token:
        raise ConnectionAbortedError("Missing required information from client.")
    
    client_identity = validate_client_credential(auth_token)

    # persist the dm messages to database
    try:
        with SessionLocal() as db_session:
            db_handler = DBHandler(db_session)
            receiver = db_handler.get_user_by_id(receiver_id)
            if not receiver:
                raise ConnectionAbortedError("Invalid message recipient from client.")
            
            db_handler.create_personal_chat_message(client_identity.id, receiver_id, content)
    except Exception as e:
        raise ConnectionAbortedError(str(e))
    finally:
        db_session.close()
    

    logger.info(f"SERVER: Private dm from client with socket id: {sid}. Content: {content} ")
    receiver_sid = current_users.get(receiver_id, None)
    if receiver_sid:
        await sio_server.emit("private_dm", data, to=receiver_sid)


@sio_server.event
async def disconnect(sid):
    current_user_id = None
    for key, value in current_users.items():
        if value == sid:
            current_user_id = key
    
    # When client loses connections, remove user from in memory mapping
    # Not sure if this function will be called by socket io server by default when clients unexpectedly lose connection during session.
    if current_user_id:
        logger.info("SERVER: remove logged out client from server.")
        del current_users[current_user_id]
    
    logger.info(f"SERVER: client with socket id: {sid} disconnected.")
