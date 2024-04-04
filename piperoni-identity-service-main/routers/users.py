from fastapi import APIRouter, Depends, HTTPException, status
from handlers.handlers import get_db_handler
from exception import  AppError, NotFoundError, InvalidParameterError, AlreadyExistsError
from schemas import User, UserDetailUpdate, CollaborationPreference, UserDetailCreate
from routers.authentication import get_current_user


user_router = APIRouter(
    prefix="/api/users",
    tags=["users"],
)

collaboration_map = {
    "Online": CollaborationPreference.online,
    "In Person": CollaborationPreference.in_person,
    "No Preference": CollaborationPreference.no_preference
}


@user_router.get("/all", status_code=status.HTTP_200_OK)
async def get_all_users(db_handler=Depends(get_db_handler)):
    try:
        user_list = db_handler.get_users()
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": user_list,
        "messages": f"SUCCESS: {len(user_list)} users retrieved."
    }

@user_router.get("/all/genres", status_code=status.HTTP_200_OK)
async def get_all_users_genres(db_handler=Depends(get_db_handler)):
    try:
        users_genre_list = db_handler.get_all_users_genres()
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": users_genre_list,
        "messages": f"SUCCESS all users genres retrieved."
    }

@user_router.get("/all/instruments", status_code=status.HTTP_200_OK)
async def get_all_users_instruments(db_handler=Depends(get_db_handler)):
    try:
        users_instruments_list = db_handler.get_all_users_instruments()
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": users_instruments_list,
        "messages": f"SUCCESS all users instruments retrieved."
    }

    
@user_router.get("/me")
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user


@user_router.get("/details/all", status_code=status.HTTP_200_OK)
async def get_all_user_personal_details(db_handler=Depends(get_db_handler)):
    try:
        db_user_details_list = db_handler.get_all_user_personal_details()
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": db_user_details_list,
        "message": f"SUCCESS: {len(db_user_details_list)} user details retrieved"
    }


@user_router.get("/details/me", status_code=status.HTTP_200_OK)
async def get_current_user_personal_details(db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_current_user_details = db_handler.get_current_user_personal_details(current_user_id)
        if not db_current_user_details:
            raise NotFoundError("No personal details found by current user id.")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": db_current_user_details},
        "messages": f"SUCCESS: retrieved current user details."
    }


@user_router.post("/details/me", status_code=status.HTTP_201_CREATED)
async def create_current_user_personal_details(user_details: UserDetailCreate, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        first_name = user_details.first_name
        last_name = user_details.last_name
        title = user_details.title
        description = user_details.description
        preference = collaboration_map.get(user_details.preference, None)
        address = user_details.address
        if not preference:
            raise InvalidParameterError("Invalid user preference data.")
        
        db_user_details = db_handler.create_current_user_personal_details(first_name, last_name, title, description, preference, address, current_user_id)
    except AlreadyExistsError as e:
         raise HTTPException(detail=str(e), status_code=status.HTTP_400_BAD_REQUEST)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": db_user_details},
        "messages": f"SUCCESS: created personal details for current users."
    }

@user_router.put("/follow", status_code=status.HTTP_200_OK)
async def follow(other_user_id: int, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_current_user_details = db_handler.follow_user(current_user_id, other_user_id)
        if not db_current_user_details:
            raise NotFoundError("No personal details found by current user id.")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": db_current_user_details},
        "messages": f"SUCCESS: {current_user.email} is now following user with id {other_user_id}."
    }


@user_router.put("/unfollow", status_code=status.HTTP_200_OK)
async def unfollow(other_user_id: int, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_current_user_details = db_handler.unfollow_user(current_user_id, other_user_id)
        if not db_current_user_details:
            raise NotFoundError("No personal details found by current user id.")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": db_current_user_details},
        "messages": f"SUCCESS: {current_user.email} unfollowed user with id {other_user_id}."
    }


@user_router.put("/details/me", status_code=status.HTTP_200_OK)
async def update_current_user_personal_details_address(payload: UserDetailUpdate, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_column, db_column_value = payload.field, payload.data
        if db_column == "id" or db_column == "user_id":
            raise InvalidParameterError("Updating action is prohibited for the given attribute.")
        
        if db_column == "preference":
            db_column_value = collaboration_map.get(db_column_value, None)
            if not db_column_value:
                raise InvalidParameterError("Invalid request data.")
        
        response = db_handler.update_current_user_personal_details_fields(db_column, db_column_value, current_user_id)
    except InvalidParameterError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_400_BAD_REQUEST)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": response},
        "messages": f"SUCCESS: update current user details."
    }
    

@user_router.get("/{user_email}", status_code=status.HTTP_200_OK)
async def get_user_by_email(user_email: str, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        user = db_handler.get_user_by_email(user_email)
        if not user:
            raise NotFoundError("User email does not exist.")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    
    return {
        "data": user,
        "message": "SUCCESS: user retrieved by email."
    }


@user_router.delete("/{user_email}", status_code=status.HTTP_200_OK)
async def delete_user_by_email(user_email: str, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        db_handler.delete_user_by_email(user_email)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    
    return {
        "data": "",
        "message": f"SUCCESS: user deleted by email."
    }