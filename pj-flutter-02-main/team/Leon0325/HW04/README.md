# Homework 4: Design -- Leon Feng
## Flutter real time chat room interaction flow
### Goal
Design a high level UI interaction flow for a real time message feature to our app
### Procedure
- Research, design, and implement a SocketIO server integration to our FastAPI backend to handle real time private dm.
- Design the database schemas and APIs to define what data is being sent to our backend.
- Create a Python socket client to test functionalities when UI is still under development.
- Instruct teammates on how SocketIO server works and how UI can leverage this backend feature to transmit real time messages.

### Structure
- In piperoni-identity-service/routers/personal_chat.py
    - define all RESTful APIs to query and persist chat room message between two users
- In piperoni-identity-service/models.py
    - I designed all the database table schemas to power our application including the chat room feature.
- piperoni-identity-service/handlers/db_handler.py
    - All sql queries I wrote for our application, and chat room queries at the end of this file.
- In piperoni-identity-service/sockets/server.py
    - SocketIo server code to handle persistent websocket connection with any socket client(script, web, or mobile), and also transmit messages to receivers, and store messages in our database using SQL queries I wrote.
- In pj-flutter-02/dev/bandaid/lib/page/dm.dart:
    - Instruct Andy to install Flutter socket client package, and what data should be send to the server, and how socket clients should connect with our server.
    - Designed the workflow that on page load, socket client should try to initiate two way handshake with server and switch network protocol to websocket.
    - A GET query should be sent to the database to fetch all old chat messages between the two users.

### Result
- Real time message feature works without having to use API polling with certain duration, which could slow down client devices.
- Backend can persist all data properly and transit the correct message to the target socket client.

### Relevant Branch

piperoni-identity-service repo: this is our python backend repo. Check out main branch, as the feature has been merged.

pj-flutter-02 repo: this is our Flutter project, and UI features have been merged as well to main.