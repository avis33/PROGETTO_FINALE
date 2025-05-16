import mariadb
import time

# Connessione al database con retry
def db(retries=10, delay=3):
    while retries > 0:
        try:
            conn = mariadb.connect(
                host="mariadb",
                port=3306,
                user="vincenzo",
                password="Paoletto2",
                database="cinema_db"
            )
            return conn
        except mariadb.Error as e:
            print(f"Connessione fallita: {e}")
            retries -= 1
            if retries == 0:
                return None
            print(f"Attendo {delay} secondi prima di riprovare ({retries} tentativi rimasti)")
            time.sleep(delay)

# Esecuzione di una query
def execute_query(connection:mariadb.Connection, query:str):
    cursor:mariadb.Cursor = connection.cursor()
    cursor.execute(query)
    results=cursor.fetchall()
    connection.commit()
    cursor.close()
    connection.close()
    return results