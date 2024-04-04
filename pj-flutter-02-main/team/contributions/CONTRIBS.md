Andy Gonzalez contributions:
- I designed the registration flow: the user information page and the logic associated with receiving the forms.
- I designed the messages page and the direct messaging pages, I implemented the socket.io logic associated with them.
- I added followers and following to our backend, and created a follower and following page in our frontend.
- I added and desgined the search page, and implemented the logic in searching and finding other users.
- I added and designed the home page that displays all the users, with sorting tags that allow the current user to sort through all the users.
- I created user_cards that display the user with the user's information.
- I added the logic to upload profile pics, working off of my teamates Aviv solution.
- I added a media player in the profile page, along with the logic to upload a sound track and clipping to to fifteen seconds.
- I also debugged some backend API points associated with returning chat logs, and creating other API endpoints to fetch all user's instruments and genres.
- Lastly, I implemented the email sign in and signup logic in the frontend.

Kirill Aristarkhov contributions:
- Designed and pitched the initial project idea and design to the group.
- Organized team meetings and did in-person scrumkeeping and offline scribing.
- Researched and implemented the Google OAuth on frontend (and with Leon's help on backend)
- Conducted cross-platform device testing
- Provided debugging feedback regarding newly implemented features (such as audio player, chatting, profile, and settings)
- Modified the settings page by adding the option to edit the "about me section"
- Created the tech stack diagram with help from Leon and Aviv
- Started and wrote a substantial part of design and manual documents

Leon Feng contributions:
- Here is the backend [repo](https://github.com/LeonFeng0325/piperoni-identity-service) for references.
- I designed, implemented the foundation of our backend infrastructure such as Nginx as proxy server, python web server using FastAPI, and PostgreSQL as our database from scratch.
- I built all REST APIs for genres, instruments, user authentication, user details, private dm logs, personal genres, personal instruments, and other backend feature.
- I utilized Docker and Docker Compose to orchestrate our server application and worked with Aviv to deploy the software to AWS EC2.
- I developed SocketIO server for our real time chat room feature and instruct Andy on how to build socket client in our Flutter application.
- I built the authentication schema and token management system for our application so users can have access to our backend services when having a valid JWT token.
- I wrote vast majority of the database queries using SQLAlchemy to fetch data for our application.
- I built landing page, sign in page, and sign up page in our Flutter application.
- I also helped my teammates debug and troubleshoot Google Oauth and other various frontend issues in our Flutter project.
- I provide feedbacks, suggestions, and directions on how to build various frontend features for my teammates.

Rishabh Poikayil contributions:
- Orchestrated task assignments and maintained consistent communication with team members, ensuring project timelines were adhered to throughout the quarter.
  - Initiated and managed user stories on the Kanban board, containing detailed sub-issues with acceptance criteria, facilitating a clear roadmap for project development.
  - Led sprint planning and scrum meetings, fostering a collaborative environment and ensuring alignment with project goals.
- Established the foundational structure of the Flutter app, featuring a home and profile page equipped with a navigation bar.
  - Designed the profile page, incorporating the templates for features such as image uploading and follower count display.
  - Expanded app functionality by adding a settings page to the navigation bar.
- Implemented the genres and instruments pages, allowing users to customize preferences.
  - Facilitated dynamic data retrieval from backend API endpoints, presenting options on these pages as selectable buttons.
- Conducted unit tests for backend functionality, ensuring the accuracy and reliability of API calls.
- Executed component tests for the frontend, validating the proper rendering and interaction of button components.
- Led a user evaluation to gather insights for design decisions, particularly focusing on the home page UI (scrolling vs. swiping).
  - Documented evaluation results to inform future design iterations.

Aviv Samet contributions:
- Created an automatic redeployment gh-action for our backend
- Created and maintained the ec2 deployment on AWS
- Created backend functionality allowing for storing images and audio on the server
- Provided server dependent debugging assistance to the team
