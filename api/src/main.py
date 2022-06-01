from fastapi import (
    FastAPI,
)
from pydantic import (
    BaseModel,
)
from typing import (
    Union,
)

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root() -> dict[str, str]:
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(
    item_id: int, query: Union[str, None] = None
) -> dict[str, Union[str, int, None]]:
    return {"item_id": item_id, "query": query}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item) -> dict[str, Union[str, int]]:
    return {"item_name": item.name, "item_id": item_id}
