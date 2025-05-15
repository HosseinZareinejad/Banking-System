import psycopg2
from psycopg2 import sql


class DatabaseOperations:
    def __init__(self, connection):
        self.connection = connection

    def insert(self, table: str, queries: dict):
        """
        Insert data into a table.
        :param table: Table name
        :param queries: Dictionary of column-value pairs to insert
        """
        try:
            cursor = self.connection.cursor()
            columns = ", ".join(queries.keys())
            values_placeholder = ", ".join(["%s"] * len(queries))
            query = f"INSERT INTO {table} ({columns}) VALUES ({values_placeholder})"
            cursor.execute(query, list(queries.values()))
            self.connection.commit()
            print(f"Inserted into {table}: {queries}")
        except Exception as e:
            print(f"Error during insert operation: {e}")
        finally:
            cursor.close()

    def update(self, table: str, updates: dict, conditions: dict):
        """
        Update data in a table.
        :param table: Table name
        :param updates: Dictionary of column-value pairs to update
        :param conditions: Dictionary of conditions (WHERE clause)
        """
        try:
            cursor = self.connection.cursor()
            set_clause = ", ".join([f"{key} = %s" for key in updates.keys()])
            where_clause = " AND ".join([f"{key} = %s" for key in conditions.keys()])
            query = f"UPDATE {table} SET {set_clause} WHERE {where_clause}"
            cursor.execute(query, list(updates.values()) + list(conditions.values()))
            self.connection.commit()
            print(f"Updated {table} with {updates} where {conditions}")
        except Exception as e:
            print(f"Error during update operation: {e}")
        finally:
            cursor.close()

    def delete(self, table: str, conditions: dict):
        """
        Delete data from a table.
        :param table: Table name
        :param conditions: Dictionary of conditions (WHERE clause)
        """
        try:
            cursor = self.connection.cursor()
            where_clause = " AND ".join([f"{key} = %s" for key in conditions.keys()])
            query = f"DELETE FROM {table} WHERE {where_clause}"
            cursor.execute(query, list(conditions.values()))
            self.connection.commit()
            print(f"Deleted from {table} where {conditions}")
        except Exception as e:
            print(f"Error during delete operation: {e}")
        finally:
            cursor.close()

    def select(self, table: str, columns: list, conditions: dict):
        """
        Select data from a table.
        :param table: Table name
        :param columns: List of columns to select
        :param conditions: Dictionary of conditions (WHERE clause)
        """
        try:
            cursor = self.connection.cursor()
            columns_str = ", ".join(columns)
            where_clause = " AND ".join([f"{key} = %s" for key in conditions.keys()])
            query = f"SELECT {columns_str} FROM {table} WHERE {where_clause}"
            cursor.execute(query, list(conditions.values()))
            results = cursor.fetchall()
            print(f"Selected {columns} from {table} where {conditions}: {results}")
            return results
        except Exception as e:
            print(f"Error during select operation: {e}")
        finally:
            cursor.close()
