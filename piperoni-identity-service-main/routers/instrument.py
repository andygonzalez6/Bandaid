from fastapi import APIRouter, Depends, HTTPException, status
from handlers.handlers import get_db_handler, get_current_user_service
from routers.authentication import get_current_user
from exception import  AppError, NotFoundError, AlreadyExistsError
from schemas import Instrument, User, PersonalInstrumentsUpload
from typing import List

instrument_router = APIRouter(
    prefix="/api/instruments",
    tags=["instruments"]
)

@instrument_router.get("/all", status_code=status.HTTP_200_OK)
async def get_all_instruments(db_handler=Depends(get_db_handler)):
    try:
        instrument_list = db_handler.get_all_instruments()
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": instrument_list,
        "messages": f"SUCCESS: {len(instrument_list)} instruments retrieved."
    }

@instrument_router.get("/me", status_code=status.HTTP_201_CREATED)
async def get_current_user_instruments(current_user_service=Depends(get_current_user_service), current_user: User=Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        result = current_user_service.fetch_current_user_personal_instruments(current_user_id)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": result},
        "messages": f"SUCCESS: retrieved current user instruments."
    }


@instrument_router.get("/{instrument_name}", status_code=status.HTTP_200_OK)
async def get_instrument_by_name(instrument_name: str, db_handler=Depends(get_db_handler), current_user: User=Depends(get_current_user)):
    try:
        db_instrument = db_handler.get_instrument_by_name(instrument_name)
        if not db_instrument:
            raise NotFoundError("instrument not found")
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": db_instrument,
        "messages": f"SUCCESS: instrument retrieved by name."
    }
    

@instrument_router.post("", status_code=status.HTTP_201_CREATED)
async def create_instrument(instrument: Instrument, db_handler=Depends(get_db_handler), current_user: User=Depends(get_current_user)):
    try:
        db_instrument = db_handler.create_instrument(instrument)
    except AlreadyExistsError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_400_BAD_REQUEST)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": db_instrument,
        "messages": f"SUCCESS: instrument created."
    }


@instrument_router.delete("/{instrument_name}", status_code=status.HTTP_200_OK)
async def delete_instrument_by_name(instrument_name: str, db_handler=Depends(get_db_handler), current_user: User=Depends(get_current_user)):
    try:
        db_handler.delete_instrument_by_name(instrument_name)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": "",
        "messages": f"SUCCESS: instrument deleted."
    }

@instrument_router.delete("/me/{instrument_id}", status_code=status.HTTP_200_OK)
async def delete_current_user_personal_instrument_by_id(instrument_id: int, db_handler=Depends(get_db_handler), current_user: User=Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        db_handler.delete_current_user_instrument_by_id(current_user_id, instrument_id)
    except NotFoundError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_404_NOT_FOUND)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": "",
        "messages": f"SUCCESS: personal instrument with id: {instrument_id} deleted."
    }

@instrument_router.post("/me", status_code=status.HTTP_201_CREATED)
async def create_current_user_instruments(personal_instrument_list: PersonalInstrumentsUpload, db_handler=Depends(get_db_handler), current_user: User=Depends(get_current_user)):
    try:
        current_user_id = current_user.id
        personal_instrument_id_list = personal_instrument_list.id
        result = db_handler.create_personal_instruments(current_user_id, personal_instrument_id_list)
    except AppError as e:
        raise HTTPException(detail=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return {
        "data": {"user": current_user.email, "payload": result},
        "messages": f"SUCCESS: created instruments for current user."
    }