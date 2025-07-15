-- =====================================================================
-- SCRIPT COMPLETO PARA CRIAÇÃO E POPULAÇÃO DO BANCO DE DADOS
-- Projeto: SGCI - Portal do Transporte e Mobilidade
-- =====================================================================

-- PASSO 1: CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS sgci_transporte CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sgci_transporte;

-- =====================================================================
-- PASSO 2: CRIAÇÃO DAS TABELAS
-- =====================================================================

-- Criação da tabela de usuários
CREATE TABLE Usuarios (
    userId INT PRIMARY KEY AUTO_INCREMENT,
    cpf CHAR(11) NOT NULL UNIQUE,
    nome_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    senha_hash VARCHAR(255) NOT NULL
);

-- Passageiros são um subconjunto de usuários
CREATE TABLE Passageiro (
    userId INT PRIMARY KEY,
    cartao_tipo VARCHAR(30),
    cartao_saldo DECIMAL(10,2),
    FOREIGN KEY (userId) REFERENCES Usuarios(userId) ON DELETE CASCADE
);

-- Motoristas também são usuários
CREATE TABLE Motorista (
    userId INT PRIMARY KEY,
    status VARCHAR(20),
    cnh VARCHAR(15) NOT NULL UNIQUE,
    data_valid DATE NOT NULL,
    categoria CHAR(2),
    FOREIGN KEY (userId) REFERENCES Usuarios(userId) ON DELETE CASCADE
);

-- Veículos
CREATE TABLE Veiculo (
    veiculoId INT PRIMARY KEY AUTO_INCREMENT,
    placa VARCHAR(10) NOT NULL UNIQUE,
    tipo_veiculo VARCHAR(30),
    status VARCHAR(20),
    data_aquisicao DATE,
    ulti_manutenc DATE
);

-- Relacionamento N:N entre Motorista e Veiculo - 'É responsável'
CREATE TABLE Responsavel (
    userId INT,
    veiculoId INT,
    PRIMARY KEY (userId, veiculoId),
    FOREIGN KEY (userId) REFERENCES Motorista(userId),
    FOREIGN KEY (veiculoId) REFERENCES Veiculo(veiculoId)
);

-- Relacionamento N:N entre Motorista e Veiculo - 'Realiza' (pode dirigir)
CREATE TABLE Realiza (
    userId INT,
    veiculoId INT,
    PRIMARY KEY (userId, veiculoId),
    FOREIGN KEY (userId) REFERENCES Motorista(userId),
    FOREIGN KEY (veiculoId) REFERENCES Veiculo(veiculoId)
);

-- Linha
CREATE TABLE Linha (
    id_linha INT PRIMARY KEY,
    nome_linha VARCHAR(50) NOT NULL,
    tempo_medio INT,
    tipo VARCHAR(20),
    status VARCHAR(20)
);

-- Ponto
CREATE TABLE Ponto (
    id INT PRIMARY KEY,
    endereco VARCHAR(100),
    tipo VARCHAR(20)
);

-- Relacionamento N:N entre Linha e Ponto - 'Passa_por'
CREATE TABLE Passa_por (
    id_linha INT,
    pontoId INT,
    PRIMARY KEY (id_linha, pontoId),
    FOREIGN KEY (id_linha) REFERENCES Linha(id_linha),
    FOREIGN KEY (pontoId) REFERENCES Ponto(id)
);

-- Viagem
CREATE TABLE Viagem (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_hora_partida DATETIME NOT NULL,
    id_linha INT NOT NULL,
    FOREIGN KEY (id_linha) REFERENCES Linha(id_linha)
);

-- Relacionamento N:M entre Passageiro e Viagem - 'Faz'
CREATE TABLE Faz (
    userId INT,
    viagemId INT,
    PRIMARY KEY (userId, viagemId),
    FOREIGN KEY (userId) REFERENCES Passageiro(userId),
    FOREIGN KEY (viagemId) REFERENCES Viagem(id)
);

-- Relacionamento entre Veiculo e Viagem - 'Participa'
CREATE TABLE Participa (
    viagemId INT,
    veiculoId INT,
    PRIMARY KEY (viagemId, veiculoId),
    FOREIGN KEY (viagemId) REFERENCES Viagem(id),
    FOREIGN KEY (veiculoId) REFERENCES Veiculo(veiculoId)
);

-- Tabela de Log para o Trigger (ADIÇÃO NECESSÁRIA)
CREATE TABLE LogAuditoria (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    tabela_afetada VARCHAR(50),
    descricao TEXT,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================================
-- PASSO 3: CRIAÇÃO DOS ÍNDICES
-- =====================================================================
CREATE INDEX idx_viagem_data_hora_partida ON Viagem(data_hora_partida);
CREATE INDEX idx_viagem_id_linha ON Viagem(id_linha);
CREATE INDEX idx_usuarios_nome_completo ON Usuarios(nome_completo);
CREATE INDEX idx_passa_por_ponto_linha ON Passa_por(pontoId, id_linha);
CREATE INDEX idx_motorista_status ON Motorista(status);


-- =====================================================================
-- PASSO 4: INSERÇÃO DE DADOS DE TESTE
-- =====================================================================

-- Tabela Usuarios (IDs de 1 a 20)
INSERT INTO Usuarios (userId, cpf, nome_completo, email, telefone, senha_hash) VALUES
(1, '11122233301', 'Ana Silva', 'ana.silva@example.com', '11987654321', 'hash123ana'),
(2, '22233344402', 'Bruno Costa', 'bruno.costa@example.com', '21987654322', 'hash123bruno'),
(3, '33344455503', 'Carla Dias', 'carla.dias@example.com', '31987654323', 'hash123carla'),
(4, '44455566604', 'Daniel Alves', 'daniel.alves@example.com', '41987654324', 'hash123daniel'),
(5, '55566677705', 'Eliana Farias', 'eliana.farias@example.com', '51987654325', 'hash123eliana'),
(6, '66677788806', 'Fernando Gomes', 'fernando.gomes@example.com', '11987654326', 'hash123fernando'),
(7, '77788899907', 'Gabriela Santos', 'gabriela.santos@example.com', '21987654327', 'hash123gabriela'),
(8, '88899900008', 'Hugo Lima', 'hugo.lima@example.com', '31987654328', 'hash123hugo'),
(9, '99900011109', 'Isabela Mendes', 'isabela.mendes@example.com', '41987654329', 'hash123isabela'),
(10, '00011122210', 'Joao Pereira', 'joao.pereira@example.com', '51987654330', 'hash123joao'),
(11, '10121232311', 'Kelly Rocha', 'kelly.rocha@example.com', '11987654331', 'hash123kelly'),
(12, '20230343412', 'Luiz Souza', 'luiz.souza@example.com', '21987654332', 'hash123luiz'),
(13, '30341454513', 'Monica Vieira', 'monica.vieira@example.com', '31987654333', 'hash123monica'),
(14, '40452565614', 'Nelson Torres', 'nelson.torres@example.com', '41987654334', 'hash123nelson'),
(15, '50563676715', 'Olivia Castro', 'olivia.castro@example.com', '51987654335', 'hash123olivia'),
(16, '60674787816', 'Pedro Rodrigues', 'pedro.rodrigues@example.com', '11987654336', 'hash123pedro'),
(17, '70785898917', 'Quiteria Fernandes', 'quiteria.fernandes@example.com', '21987654337', 'hash123quiteria'),
(18, '80896909018', 'Rafael Barreto', 'rafael.barreto@example.com', '31987654338', 'hash123rafael'),
(19, '90907010119', 'Sandra Nogueira', 'sandra.nogueira@example.com', '41987654339', 'hash123sandra'),
(20, '01018121220', 'Thiago Viana', 'thiago.viana@example.com', '51987654340', 'hash123thiago');

-- Tabela Passageiro (alguns usuários são passageiros)
INSERT INTO Passageiro (userId, cartao_tipo, cartao_saldo) VALUES
(1, 'Estudante', 150.75), (2, 'Comum', 200.00), (3, 'Idoso', 50.00), (4, 'Comum', 120.50),
(5, 'Estudante', 80.25), (6, 'Comum', 300.00), (7, 'Idoso', 75.00), (8, 'Comum', 180.00),
(9, 'Estudante', 90.00), (10, 'Comum', 250.00), (11, 'Comum', 100.00), (12, 'Estudante', 60.00);

-- Tabela Motorista (alguns usuários são motoristas)
INSERT INTO Motorista (userId, status, cnh, data_valid, categoria) VALUES
(13, 'Ativo', '12345678901', '2028-01-15', 'AB'), (14, 'Inativo', '23456789012', '2027-05-20', 'D'),
(15, 'Ativo', '34567890123', '2029-11-10', 'C'), (16, 'Ativo', '45678901234', '2026-03-25', 'AD'),
(17, 'Ativo', '56789012345', '2030-07-01', 'B'), (18, 'Inativo', '67890123456', '2027-09-30', 'E');

-- Tabela Veiculo
INSERT INTO Veiculo (veiculoId, placa, tipo_veiculo, status, data_aquisicao, ulti_manutenc) VALUES
(1, 'ABC1A23', 'Ônibus', 'Ativo', '2020-03-10', '2025-05-01'),
(2, 'DEF4B56', 'Micro-ônibus', 'Ativo', '2018-07-20', '2025-04-15'),
(3, 'GHI7C89', 'VLT', 'Manutenção', '2022-01-05', '2025-06-10'),
(4, 'JKL0D12', 'Ônibus', 'Ativo', '2021-09-01', '2025-05-20'),
(5, 'MNO3E45', 'Ônibus', 'Ativo', '2019-02-28', '2025-06-01');

-- Tabela Responsavel
INSERT INTO Responsavel (userId, veiculoId) VALUES (13, 1), (14, 2), (15, 3), (16, 4), (17, 5);

-- Tabela Realiza
INSERT INTO Realiza (userId, veiculoId) VALUES
(13, 1), (14, 2), (15, 3), (16, 4), (17, 5),
(13, 4); -- Motorista 13 também pode dirigir o veículo 4

-- Tabela Linha
INSERT INTO Linha (id_linha, nome_linha, tempo_medio, tipo, status) VALUES
(101, 'Centro - Bairro A', 45, 'Urbana', 'Ativa'),
(102, 'Terminal - Zona Sul', 60, 'Urbana', 'Ativa'),
(103, 'Via Expressa', 30, 'Expresso', 'Ativa'),
(104, 'Rural - Cidade', 90, 'Rural', 'Ativa'),
(105, 'Circular Leste', 50, 'Circular', 'Manutenção');

-- Tabela Ponto
INSERT INTO Ponto (id, endereco, tipo) VALUES
(1001, 'Rua das Flores, 123', 'Parada'), (1002, 'Avenida Principal, 456', 'Terminal'),
(1003, 'Praça da Matriz', 'Parada'), (1004, 'Rua do Comércio, 789', 'Parada'),
(1005, 'Estação Central', 'Terminal'), (1006, 'Ponto de ônibus 6', 'Parada'),
(1007, 'Ponto de ônibus 7', 'Parada'), (1008, 'Ponto de ônibus 8', 'Parada'),
(1009, 'Ponto de ônibus 9', 'Parada'), (1010, 'Ponto de ônibus 10', 'Parada'),
(1011, 'Ponto de ônibus 11', 'Parada'), (1012, 'Ponto de ônibus 12', 'Parada');

-- Tabela Passa_por
INSERT INTO Passa_por (id_linha, pontoId) VALUES
(101, 1001), (101, 1003), (101, 1004), (102, 1002), (102, 1001), (102, 1005),
(103, 1005), (103, 1002), (104, 1006), (104, 1007), (104, 1008),
(105, 1009), (105, 1010), (105, 1011);

-- Tabela Viagem
INSERT INTO Viagem (id, data_hora_partida, id_linha) VALUES
(1, '2025-06-28 08:00:00', 101), (2, '2025-06-28 09:30:00', 102),
(3, '2025-06-28 10:00:00', 101), (4, '2025-06-28 11:00:00', 103),
(5, '2025-06-28 12:15:00', 104), (6, '2025-06-28 13:00:00', 105),
(7, '2025-06-28 14:30:00', 101);

-- Tabela Faz (Passageiros fazem viagens)
INSERT INTO Faz (userId, viagemId) VALUES
(1, 1), (2, 1), (3, 1), (1, 2), (4, 2), (5, 3), (6, 3),
(7, 4), (8, 5), (9, 5), (10, 5), (11, 6), (12, 7);

-- Tabela Participa (Veículos participam de viagens)
INSERT INTO Participa (viagemId, veiculoId) VALUES
(1, 1), (2, 2), (3, 1), (4, 3), (5, 4), (6, 5), (7, 1);


-- =====================================================================
-- PASSO 5: CRIAÇÃO DE PROCEDURES, FUNCTIONS E TRIGGERS
-- =====================================================================

-- O comando DELIMITER é necessário para o cliente MySQL interpretar
-- o corpo da procedure/function/trigger como um bloco único.

-- 1. Procedures
DELIMITER $$

CREATE PROCEDURE sp_RegistrarManutencao(IN p_veiculoId INT, IN p_dataManutencao DATE)
BEGIN
    UPDATE Veiculo
    SET status = 'Manutenção', ulti_manutenc = p_dataManutencao
    WHERE veiculoId = p_veiculoId;
END$$

CREATE PROCEDURE sp_RecarregarCartao(IN p_passageiroId INT, IN p_valor DECIMAL(10,2))
BEGIN
    IF p_valor > 0 THEN
        UPDATE Passageiro
        SET cartao_saldo = cartao_saldo + p_valor
        WHERE userId = p_passageiroId;
    END IF;
END$$

CREATE PROCEDURE sp_DesativarLinha(IN p_linhaId INT)
BEGIN
    UPDATE Linha SET status = 'Inativa' WHERE id_linha = p_linhaId;
    
    UPDATE Veiculo v
    JOIN (
        SELECT DISTINCT p.veiculoId 
        FROM Participa p 
        JOIN Viagem vi ON p.viagemId = vi.id 
        WHERE vi.id_linha = p_linhaId
    ) AS veiculos_da_linha ON v.veiculoId = veiculos_da_linha.veiculoId
    SET v.status = 'Manutenção';
END$$

DELIMITER ;

-- 2. Functions
DELIMITER $$

CREATE FUNCTION fn_VerificarValidadeCNH(p_motoristaId INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE v_dataValidade DATE;
    SELECT data_valid INTO v_dataValidade FROM Motorista WHERE userId = p_motoristaId;
    IF v_dataValidade >= CURDATE() THEN
        RETURN 'Válida';
    ELSE
        RETURN 'Vencida';
    END IF;
END$$

CREATE FUNCTION fn_ContarPassageirosPorViagem(p_viagemId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_totalPassageiros INT;
    SELECT COUNT(*) INTO v_totalPassageiros FROM Faz WHERE viagemId = p_viagemId;
    RETURN v_totalPassageiros;
END$$

CREATE FUNCTION fn_CalcularIdadeVeiculo(p_veiculoId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_dataAquisicao DATE;
    SELECT data_aquisicao INTO v_dataAquisicao FROM Veiculo WHERE veiculoId = p_veiculoId;
    RETURN TIMESTAMPDIFF(YEAR, v_dataAquisicao, CURDATE());
END$$

DELIMITER ;

-- 3. Triggers
DELIMITER $$

CREATE TRIGGER tg_LogNovoUsuario
AFTER INSERT ON Usuarios
FOR EACH ROW
BEGIN
    INSERT INTO LogAuditoria(tabela_afetada, descricao)
    VALUES ('Usuarios', CONCAT('Novo usuário criado. ID: ', NEW.userId, ', Nome: ', NEW.nome_completo));
END$$

CREATE TRIGGER tg_VerificarStatusVeiculo
BEFORE INSERT ON Participa
FOR EACH ROW
BEGIN
    DECLARE v_statusVeiculo VARCHAR(20);
    SELECT status INTO v_statusVeiculo FROM Veiculo WHERE veiculoId = NEW.veiculoId;
    IF v_statusVeiculo != 'Ativo' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Operação cancelada: Não é possível alocar um veículo que não esteja ativo.';
    END IF;
END$$

CREATE TRIGGER tg_VerificarMotoristaAtivoComCNHVencida
BEFORE UPDATE ON Motorista
FOR EACH ROW
BEGIN
    IF NEW.status = 'Ativo' AND OLD.status != 'Ativo' AND NEW.data_valid < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Operação cancelada: Não é possível ativar um motorista com a CNH vencida.';
    END IF;
END$$

DELIMITER ;


-- =====================================================================
-- FIM DO SCRIPT
-- =====================================================================