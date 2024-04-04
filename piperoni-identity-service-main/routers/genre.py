from fastapi import APIRouter, Depends, HTTPException, status
from handlers.handlers import get_db_handler, get_current_user_service
from routers.authentication import get_current_user
from exception import  AppError, NotFoundError
from schemas import Genre, User, PersonalGenresUpload

genre_router = APIRouter(
    prefix="/api/genres",
    tags=["genres"]
)


@genre_router.get("/all", status_code=status.HTTP_200_OK)
async def get_all_genres(db_handler=Depends(get_db_handler)):
    try:
        genre_list = db_handler.get_all_music_genres()
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": genre_list,
        "messages": f"SUCCESS: {len(genre_list)} genres retrieved."
    }


@genre_router.get("/me", status_code=status.HTTP_200_OK)
async def get_personal_genres(current_user_service = Depends(get_current_user_service), current_user = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_personal_list = current_user_service.fetch_current_user_personal_genres(current_user_id)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": db_personal_list},
        "messages": f"SUCCESS: genres retrieved for current user."
    }


@genre_router.get("/{genre_name}", status_code=status.HTTP_200_OK)
async def get_genre_by_name(genre_name: str, db_handler=Depends(get_db_handler), current_user = Depends(get_current_user)):
    try:
        db_genre = db_handler.get_genre_by_name(genre_name)
        if not db_genre:
            raise NotFoundError("Genre does not exist")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    
    return {
        "data": db_genre,
        "message": "SUCCESS: genre retrieved by name."
    }


@genre_router.post("/", status_code=status.HTTP_201_CREATED)
async def create_genre(genre: Genre, db_handler=Depends(get_db_handler), current_user = Depends(get_current_user)):
    try:
        db_genre = db_handler.create_genre(genre)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": db_genre,
        "messages": f"SUCCESS: genre created."
    }


@genre_router.delete("/{genre_name}", status_code=status.HTTP_200_OK)
async def delete_genre(genre_name: str, db_handler=Depends(get_db_handler), current_user = Depends(get_current_user)):
    try:
        db_handler.delete_genre_by_name(genre_name)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    
    return {
        "data": "",
        "message": f"SUCCESS: genre deleted by name."
    }


@genre_router.delete("/me/{genre_id}", status_code=status.HTTP_200_OK)
async def delete_personal_genre(genre_id: int, db_handler=Depends(get_db_handler), current_user = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_handler.delete_current_user_genre(current_user_id, genre_id)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    
    return {
        "data": {"user": current_user.email},
        "message": f"SUCCESS: current user personal genre deleted with id: {genre_id}."
    }


@genre_router.post("/me", status_code=status.HTTP_201_CREATED)
async def create_personal_genres(personal_genres: PersonalGenresUpload, db_handler=Depends(get_db_handler), current_user: User = Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        genre_id_list = personal_genres.id
        db_genre = db_handler.create_current_user_genres(genre_id_list, current_user_id)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": db_genre},
        "messages": f"SUCCESS: genre created for current user."
    }