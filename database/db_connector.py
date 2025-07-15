# database/db_connector.py
import mysql.connector
from mysql.connector import Error
from config import DB_CONFIG

def get_db_connection():
    """Estabelece e retorna uma conexão com o banco de dados."""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Erro ao conectar ao MySQL: {e}")
        return None