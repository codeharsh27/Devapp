from fastapi import HTTPException, Request, status
from fastapi.responses import JSONResponse

class BusinessRuleException(HTTPException):
    def __init__(self, code: str, detail: str, status_code: int = status.HTTP_400_BAD_REQUEST):
        super().__init__(status_code=status_code, detail=detail)
        self.code = code

async def business_rule_exception_handler(request: Request, exc: BusinessRuleException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": {"code": exc.code, "message": exc.detail}},
    )

class RBACException(HTTPException):
    def __init__(self, detail: str = "Insufficient permissions"):
        super().__init__(status_code=status.HTTP_403_FORBIDDEN, detail=detail)

async def rbac_exception_handler(request: Request, exc: RBACException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": {"code": "FORBIDDEN", "message": exc.detail}},
    )

def setup_exception_handlers(app):
    app.add_exception_handler(BusinessRuleException, business_rule_exception_handler)
    app.add_exception_handler(RBACException, rbac_exception_handler)
