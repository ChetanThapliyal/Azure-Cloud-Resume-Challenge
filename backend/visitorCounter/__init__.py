import os
import azure.functions as func
import logging
from azure.data.tables import TableServiceClient
from azure.core.exceptions import ResourceNotFoundError

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        # Get connection to Cosmos DB Table
        connection_string = os.environ["COSMOS_DB_CONNECTION_STRING"]
        table_service = TableServiceClient.from_connection_string(conn_str=connection_string)
        table_name = "VisitorsLog"
        table_client = table_service.get_table_client(table_name=table_name)

        partition_key = "visitor"
        row_key = "visits"

        try:
            # Read current entry
            entity = table_client.get_entity(partition_key=partition_key, row_key=row_key)
            entity['count'] += 1
            table_client.update_entity(entity=entity)
            logging.info(f"Visitor count updated: {entity['count']}")
        except ResourceNotFoundError:
            # Create new entry
            entity = {
                'PartitionKey': partition_key,
                'RowKey': row_key,
                'count': 1
            }
            table_client.create_entity(entity=entity)
            logging.info("New visitor count entry created.")
        return func.HttpResponse(
            f"Visitor count updated successfully. Current count: {entity['count']}",
            status_code=200
        )
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        return func.HttpResponse(
            f"An error occurred: {str(e)}",
            status_code=500
        )