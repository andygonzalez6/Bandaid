import os

from fastapi import APIRouter, UploadFile, Depends, HTTPException, status, Response
from routers.authentication import get_current_user
from handlers.handlers import get_db_handler
import requests

router = APIRouter(prefix="/api/files", tags=["files"])
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@router.post("/upload_audio")
async def upload_audio_file(file: UploadFile, current_user=Depends(get_current_user), db_handler=Depends(get_db_handler)):
    if file.content_type != "audio/mpeg":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File must be an mp3 audio file.")
    contents = await file.read()
    filepath = f"/audio/{current_user.id}.mp3"

    # Have to try to create the directory first
    # https://stackoverflow.com/questions/23793987/write-a-file-to-a-directory-that-doesnt-exist
    try:
        os.makedirs(os.path.dirname(filepath))
    except FileExistsError:
        pass
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e)) from e

    with open(filepath, "wb") as f:
        f.write(contents)

    db_handler.update_current_user_personal_details_fields("audio_sample", filepath, current_user.id)

    return {"filepath": filepath}

@router.get("/audio/{user_id}")
def get_audio_file(user_id: int, db_handler=Depends(get_db_handler)):
    user_details = db_handler.get_current_user_personal_details(user_id)
    if not user_details:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User details not found.")
    if not user_details.audio_sample:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User audio sample not found.")
    
    audio_file = open(user_details.audio_sample, "rb")

    audio_bytes = audio_file.read()

    return Response(content=audio_bytes, media_type="audio/mpeg")

@router.post("/upload")
async def upload_file(file: UploadFile, current_user=Depends(get_current_user), db_handler=Depends(get_db_handler)):
    # Check if the file has an allowed extension
    if not allowed_file(file.filename):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST) 
    contents = await file.read()
    filepath = f"/pics/{current_user.id}.png"

    # Have to try to create the directory first
    # https://stackoverflow.com/questions/23793987/write-a-file-to-a-directory-that-doesnt-exist
    try:
        os.makedirs(os.path.dirname(filepath))
    except FileExistsError:
        pass
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e)) from e

    with open(filepath, "wb") as f:
        f.write(contents)

    db_handler.update_current_user_personal_details_fields("profile_picture", filepath, current_user.id)

    return {"filepath": filepath}

@router.get("/profile")
def get_profile_pic(current_user=Depends(get_current_user), db_handler=Depends(get_db_handler)):
    user_details = db_handler.get_current_user_personal_details(current_user.id)
    if not user_details:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User details not found.")
    if not user_details.profile_picture:
        default_pfp_req = requests.get('https://zultimate.com/wp-content/uploads/2019/12/default-profile.png')
        return Response(content=default_pfp_req.content, media_type="image/png")
    
    picture_file = open(user_details.profile_picture, "rb")

    picture_bytes = picture_file.read()

    return Response(content=picture_bytes, media_type="image/png")
    
@router.get("/profile/{user_id}")
def get_profile_pic_by_id(user_id: int, db_handler=Depends(get_db_handler)):
    user_details = db_handler.get_current_user_personal_details(user_id)
    if not user_details:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User details not found.")
    if not user_details.profile_picture:
        default_pfp_req = requests.get('https://zultimate.com/wp-content/uploads/2019/12/default-profile.png')
        return Response(content=default_pfp_req.content, media_type="image/png")
    
    picture_file = open(user_details.profile_picture, "rb")

    picture_bytes = picture_file.read()

    return Response(content=picture_bytes, media_type="image/png")


@router.get("/profile/all")
def get_all_profile_pics(db_handler=Depends(get_db_handler)):
    user_details = db_handler.get_all_user_personal_details()
    if not user_details:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User details not found.")
    
    pictures = []
    for user in user_details:
        if not user.profile_picture:
            continue
        picture_file = open(user.profile_picture, "rb")
        picture_bytes = picture_file.read()
        pictures.append(picture_bytes)

    return Response(content=pictures, media_type="image/png")
