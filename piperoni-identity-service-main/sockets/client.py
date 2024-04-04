import socketio
import asyncio

# Socket client made for testing purpose

sio_client = socketio.AsyncClient()
# Should always fetch a valid token using /token endpoint in swagger ui for testing purpose
accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiX2ZlbmdAdWNzYi5lZHUiLCJleHAiOjE3MDAyNTM4MzR9.VRM3RjqHw3-j3mpJXsH1qeYCRK_sA_nWFYQJUR73M9M"

@sio_client.event
async def connect():
    print("CLIENT: I'm connected.")


@sio_client.event
def connect_error(data):
    print("CLIENT: The connection failed!")


@sio_client.event
async def disconnect():
    print("CLIENT: I'm disconnected.")


@sio_client.on('server_login_confirm')
async def client_receive_server_login_confirm(data):
    print(f"CLIENT: Login confirmation from the server: {data}")


@sio_client.event
async def private_dm(message):
    print(f"CLIENT: Received message from the server: {message}")


async def main():
    try:
        print("CLIENT: Initiating socket connection to server...")
        # For local docker compose environment use 80 port
        # For local development use 8000 port
        # For interacting with prod server, change localhost to ec2 instance url with port 80
        await sio_client.connect(url='http://localhost:80', socketio_path='/ws/sockets.io', auth={'Authorization': accessToken}, transports=['websocket'])
        await sio_client.call("private_dm", {
            "content": "New stuff?",
            "auth_token": accessToken,
            "receiver_id": 3
        })
    except Exception as e:
        print(f"CLIENT: Connection failed with error: {e}")
    finally:
        # Ensure that the client session is properly closed
        await sio_client.disconnect()


if __name__ == "__main__":
    asyncio.run(main())
