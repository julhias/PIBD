# database/queries.py
import datetime
from mysql.connector import Error
from database.db_connector import get_db_connection

def get_all_linhas():
    """Busca todas as linhas ativas no banco de dados."""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT id_linha, nome_linha FROM Linha WHERE status = 'Ativa' ORDER BY nome_linha")
            linhas = cursor.fetchall()
            return linhas
        except Error as e:
            print(f"Erro ao buscar linhas: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    return []

def get_itinerario_por_linha(id_linha):
    """Busca todos os pontos de um itinerário a partir do ID da linha."""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            sql = """
                SELECT p.endereco, p.tipo 
                FROM Ponto p 
                JOIN Passa_por pp ON p.id = pp.pontoId 
                WHERE pp.id_linha = %s
            """
            cursor.execute(sql, (id_linha,))
            itinerario = cursor.fetchall()
            return itinerario
        except Error as e:
            print(f"Erro ao buscar itinerário: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    return []

def cadastrar_novo_motorista(cpf, nome, email, telefone, senha, cnh, data_valid, categoria):
    """Cadastra um novo usuário e um novo motorista de forma transacional."""
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        try:
            # Inicia a transação
            conn.start_transaction()

            # 1. Insere na tabela Usuarios
            sql_usuario = "INSERT INTO Usuarios (cpf, nome_completo, email, telefone, senha_hash) VALUES (%s, %s, %s, %s, %s)"
            cursor.execute(sql_usuario, (cpf, nome, email, telefone, senha))
            
            # Pega o ID do usuário recém-criado
            user_id = cursor.lastrowid

            # 2. Insere na tabela Motorista
            sql_motorista = "INSERT INTO Motorista (userId, status, cnh, data_valid, categoria) VALUES (%s, 'Ativo', %s, %s, %s)"
            cursor.execute(sql_motorista, (user_id, cnh, data_valid, categoria))

            # Confirma a transação
            conn.commit()
            return True, "Motorista cadastrado com sucesso!"
        
        except Error as e:
            # Desfaz a transação em caso de erro
            conn.rollback()
            return False, f"Erro ao cadastrar motorista: {e}"
        finally:
            cursor.close()
            conn.close()
    return False, "Não foi possível conectar ao banco de dados."


def get_all_veiculos_ativos():
    """Busca todos os veículos com status 'Ativo'."""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT veiculoId, placa, tipo_veiculo FROM Veiculo WHERE status = 'Ativo' ORDER BY placa")
            veiculos = cursor.fetchall()
            return veiculos
        except Error as e:
            print(f"Erro ao buscar veículos: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    return []

def registrar_manutencao_veiculo(veiculo_id):
    """Chama a stored procedure para registrar a manutenção de um veículo."""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            data_hoje = datetime.date.today()
            # Chama a procedure sp_RegistrarManutencao
            cursor.callproc('sp_RegistrarManutencao', [veiculo_id, data_hoje])
            conn.commit()
            return True, f"Manutenção registrada com sucesso para o veículo ID {veiculo_id}."
        except Error as e:
            conn.rollback()
            return False, f"Erro ao registrar manutenção: {e}"
        finally:
            cursor.close()
            conn.close()
    return False, "Não foi possível conectar ao banco de dados."