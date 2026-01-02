from typing import Any
from sqlalchemy.ext.declarative import as_declarative, declared_attr

@as_declarative()
class Base:
    id:Any
    __name__:str    

    # This automatically generates the table name from the class name
    # Example: class UserProfile -> table "user_profile"
    @declared_attr
    def __tablename__(cls)->str:
        return cls.__name__.lower()