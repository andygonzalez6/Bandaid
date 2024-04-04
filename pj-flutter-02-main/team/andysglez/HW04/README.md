# Homework 4: Implementation Contribution -- Andy Gonzalez
## Flutter Socket.IO integration
### Goal
Implement a real-time messaging feature to our app
### Procedure
- Design and implement a messaging page and a direct messaging page and add it to the bottom navigation bar
- Connect frontend to backend endpoints that fetch user chat logs
- Create a socket io client in Flutter to connect to our python server in the backend
- Use websockets to receive incoming messages and display for user accordingly.

### Structure
In dev/bandaid/lib
- In /model:
  - added message model to handle message data
- In /page:
  - added messaging_page.dart and dm.dart, which are messaging page and direct messaging page respectively. dm.dart contains socket.io
  - modified home.dart to include messaging_page in navigation bar.
- In /utils:
  - added chat_functions.dart which accesschat endpoints in the backend

### Results
- Messaging Page: displays users sorted by latest message, displays day of last message, and default values for recipients with no message history.
- Direct Messaging Page: displays recipient user on app bar, sends and receives messages instantly.

### Relevant Branch (Already merged to main):

https://github.com/ucsb-cs184-f23/pj-flutter-02/tree/Andy-MessagingPage
