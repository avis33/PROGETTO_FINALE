from pydantic import BaseModel
from typing import List

#MODELLI PYDANTIC

# Per lo schema del database
class SchemaSummaryItem(BaseModel):
    table_name: str
    table_column: str

# Per l'item da ritornare dopo la search endpoint
class Property(BaseModel):
    property_name: str
    property_value: str

class SearchItem(BaseModel):
    item_type: str
    properties: List[Property]

# Per l'add endpoint
class AddRequest(BaseModel):
    data_line: str

class AddResponse(BaseModel):
    status: str
