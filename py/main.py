import psycopg2
from db_operations import DatabaseOperations

# Database connection details
host = "127.0.0.1"
port = "5432"
database = "postgres"
user = "postgres"
password = "Hosseinzr83"

try:
    # Establish connection
    connection = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password
    )
    print("Connected to the database successfully!")

    # Initialize DatabaseOperations
    db_ops = DatabaseOperations(connection)

    while True:
        print("\nChoose an operation:")
        print("1. Insert")
        print("2. Update")
        print("3. Delete")
        print("4. Select")
        print("5. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":  # Insert
            table = input("Enter table name: ")
            columns = input("Enter columns (comma-separated): ").split(",")
            values = input("Enter values (comma-separated): ").split(",")
            queries = dict(zip(columns, values))
            db_ops.insert(table, queries)

        elif choice == "2":  # Update
            table = input("Enter table name: ")
            update_columns = input("Enter columns to update (comma-separated): ").split(",")
            update_values = input("Enter values for update (comma-separated): ").split(",")
            updates = dict(zip(update_columns, update_values))

            condition_columns = input("Enter condition columns (comma-separated): ").split(",")
            condition_values = input("Enter condition values (comma-separated): ").split(",")
            conditions = dict(zip(condition_columns, condition_values))

            db_ops.update(table, updates, conditions)

        elif choice == "3":  # Delete
            table = input("Enter table name: ")
            condition_columns = input("Enter condition columns (comma-separated): ").split(",")
            condition_values = input("Enter condition values (comma-separated): ").split(",")
            conditions = dict(zip(condition_columns, condition_values))

            db_ops.delete(table, conditions)

        elif choice == "4":  # Select
            table = input("Enter table name: ")
            columns = input("Enter columns to select (comma-separated, or * for all): ").split(",")
            condition_columns = input("Enter condition columns (comma-separated, or leave empty): ")
            conditions = {}

            if condition_columns:
                condition_columns = condition_columns.split(",")
                condition_values = input("Enter condition values (comma-separated): ").split(",")
                conditions = dict(zip(condition_columns, condition_values))

            results = db_ops.select(table, columns, conditions)
            print(f"Results: {results}")

        elif choice == "5":  # Exit
            print("Exiting program.")
            break

        else:
            print("Invalid choice. Please try again.")

except Exception as error:
    print(f"Error: {error}")

finally:
    if 'connection' in locals() and connection:
        connection.close()
        print("Database connection closed.")
