from passlib.context import CryptContext
try:
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    hash = pwd_context.hash("test")
    print(f"Success: {hash}")
except Exception as e:
    print(f"Error: {e}")
