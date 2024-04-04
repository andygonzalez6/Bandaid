from fastapi import APIRouter, Depends, HTTPException, status
from handlers.handlers import get_db_handler
from exception import  AppError, NotFoundError, InvalidParameterError, AlreadyExistsError
from schemas import PersonalChatMessageCreate, User
from routers.authentication import get_current_user

personal_chat_router = APIRouter(
    prefix="/api/chats",
    tags=['chats']
)

@personal_chat_router.get("/{user_id}", status_code=status.HTTP_200_OK)
async def get_all_personal_chat_messages(user_id: int, db_handler=Depends(get_db_handler)):
    try:
        chat_message_list = db_handler.get_all_personal_chat_message(user_id)
        if not chat_message_list or len(chat_message_list) == 0:
            raise NotFoundError("No chat records exist for the given user.")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": chat_message_list,
        "message": "SUCCESS: user chat record retrieved by id."
    }

@personal_chat_router.get("/me/{correspondent_id}", status_code=status.HTTP_200_OK)
async def get_current_user_personal_dms(correspondent_id: int, db_handler=Depends(get_db_handler), current_user: User =Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        personal_dms = db_handler.get_current_user_dms(current_user_id, correspondent_id)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": personal_dms,
        "message": "SUCCESS: current user dms retrieved."
    }
    

@personal_chat_router.post("", status_code=status.HTTP_201_CREATED)
async def create_personal_chat_message(payload: PersonalChatMessageCreate, db_handler=Depends(get_db_handler)):
    try:
        sender_id, receiver_id, content = payload.sender_id, payload.receiver_id, payload.content
        chat_message = db_handler.create_personal_chat_message(sender_id=sender_id, receiver_id=receiver_id, content=content)
    except InvalidParameterError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_400_BAD_REQUEST)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": chat_message,
        "message": "SUCCESS: create a personal chat message."
    }
