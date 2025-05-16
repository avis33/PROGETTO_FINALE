import mariadb
import re
from typing import List, Union
from backend.models.models import SearchItem, Property
from backend.db.db import db, execute_query

# ENDPOINT /schema_summary
def get_schema_summary():
    conn = db()
    if not conn:
        return []
    # Ottieni TABLE_NAME e COLUMN_NAME
    query = """
        SELECT TABLE_NAME, COLUMN_NAME
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = 'cinema_db'
    """ 
    results = execute_query(conn, query)
    return results

# ENDPOINT /add
def inserisci_riga(titolo, regista, eta_autore, anno, genere, piattaforma_1, piattaforma_2):
    # Connessione al database
    try:
        conn = mariadb.connect(
            host="mariadb",
            port=3306,
            user="vincenzo",
            password="Paoletto2",
            database="cinema_db"
        )
        cursor = conn.cursor()
        # 1. Controlla se il regista esiste
        cursor.execute("SELECT id_director FROM directors WHERE nome = ?", (regista,)) # La , crea una tupla con un solo elemento 
        director = cursor.fetchone()
        if director: # se esiste
            id_director = director[0]
            # Aggiorna eta del regista se già presente
            cursor.execute("UPDATE directors SET eta = ? WHERE id_director = ?", (int(eta_autore), id_director))
        else:
            # Inserisci nuovo regista
            cursor.execute("INSERT INTO directors (nome, eta) VALUES (?, ?)", (regista, int(eta_autore)))
            id_director = cursor.lastrowid    # prendiamo l'id autogenerato, non posso fare cursor.fetchone()[0] su INSERT
        # 2. Controlla se il film esiste
        cursor.execute("SELECT id_movie FROM movies WHERE titolo = ?", (titolo,))
        film = cursor.fetchone()
        if film:
            id_movie = film[0]
            # Aggiorna i dati del film esistente
            cursor.execute(
                "UPDATE movies SET anno = ?, genere = ?, id_director = ? WHERE id_movie = ?",
                (int(anno), genere, id_director, id_movie)
            )
            # Cancella distribuzioni precedenti se il film gia esisteva cosi possiamo aggiungerle dopo
            cursor.execute("DELETE FROM distribuzioni WHERE id_movie = ?", (id_movie,))
        else:
            cursor.execute(
            "INSERT INTO movies (titolo, anno, genere, id_director) VALUES (?, ?, ?, ?)",
            (titolo, int(anno), genere, id_director)
            )
            id_movie = cursor.lastrowid

        # 3. Se piattaforma_1 è fornita e non vuota: controlla e inserisci piattaforma_1 
        if piattaforma_1:
            cursor.execute("SELECT id_piattaforma FROM piattaforme WHERE nome = ?", (piattaforma_1,))
            piattaforma1 = cursor.fetchone()
            if piattaforma1: # Se abbiamo gia la piattaforma nella tabella piattaforme
                id_piattaforma_1 = piattaforma1[0]
            else: # Se non l'abbiamo la inseriamo
                cursor.execute("INSERT INTO piattaforme (nome) VALUES (?)", (piattaforma_1,))
                id_piattaforma_1 = cursor.lastrowid
            # 4. Inserisci distribuzione: film - piattaforma_1
            cursor.execute("INSERT INTO distribuzioni (id_movie, id_piattaforma) VALUES (?, ?)", (id_movie, id_piattaforma_1))

        # 5. Se piattaforma_2 è fornita e non vuota, controlla/aggiungi
        if piattaforma_2:
            cursor.execute("SELECT id_piattaforma FROM piattaforme WHERE nome = ?", (piattaforma_2,))
            piattaforma2= cursor.fetchone()
            if piattaforma2:
                id_piattaforma_2 = piattaforma2[0]
            else:
                cursor.execute("INSERT INTO piattaforme (nome) VALUES (?)", (piattaforma_2,))
                id_piattaforma_2 = cursor.lastrowid

            cursor.execute("INSERT INTO distribuzioni (id_movie, id_piattaforma) VALUES (?, ?)", (id_movie, id_piattaforma_2))

        conn.commit()
        cursor.close()
        conn.close()
        return True # L'inserimento è andato a buon fine

    except mariadb.Error as e:
        print("Errore durante l'inserimento:", e)
        if conn:
            conn.rollback()
            conn.close()
        return False