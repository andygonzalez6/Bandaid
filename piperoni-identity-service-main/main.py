import uvicorn
from fastapi import FastAPI, Depends, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from database import engine, get_db
from models import Base
from routers import users, authentication, genre, instrument, personal_chat, files
from sockets.server import sio_app
from preflight import genre_list, user_list, personal_genre_list, instrument_list, personal_instrument_list, personal_detail_list

Base.metadata.create_all(bind=engine) # Create database tables on server start.

app = FastAPI()

# Enable all origins for simplicity. Adjust as needed.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# mount socketio server as sub application to the FastAPI web server
app.mount('/ws', app=sio_app)

# Register HTTP API endpoints to the main FastAPI web server
app.include_router(authentication.authentication_router)
app.include_router(users.user_router)
app.include_router(genre.genre_router)
app.include_router(instrument.instrument_router)
app.include_router(personal_chat.personal_chat_router)
app.include_router(files.router)

@app.middleware("http")
async def reject_env_paths(request: Request, call_next):
    if ".env" in request.url.path:
        raise HTTPException(status_code=418)
    response = await call_next(request)
    return response

@app.get("/")
async def index():
    return {"message": "Welcome to our backend server for our Flutter Project!"}


@app.get("/reset", description="This endpoint rebuilds database based on latest db schemas")
async def reset(db_session=Depends(get_db)): # This endpoint will drop all db tables and recreate them in database from scratch and add default data. This is a hack so we don't need to do database migrations.
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    # Auto insert some default data to the new database
    data_queue = [user_list, genre_list, personal_genre_list, instrument_list, personal_instrument_list, personal_detail_list]
    for data in data_queue:
        db_session.bulk_save_objects(data)
    db_session.commit()

    return {"message": "Database has been rebuilt from scratch and initialized with default data."}


if __name__ == "__main__": # The entry point of the application. To start local sever, run ```python main.py```
    uvicorn.run("main:app", reload=True)
