--Excluir banco em uso
DROP DATABASE teste01;
--Excluir banco em uso
USE MASTER 
GO 
ALTER DATABASE teste01
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE teste01;

CREATE DATABASE Biblioteca;


CREATE TABLE Autor(
IdAutor SMALLINT IDENTITY,
NomeAutor VARCHAR(50) NOT NULL,
SobrenomeAutor VARCHAR(60) NOT NULL,
CONSTRAINT pk_id_autor PRIMARY KEY(IdAutor)
);

sp_help Autor;

CREATE TABLE Editora(
IdEditora SMALLINT PRIMARY KEY IDENTITY,
NomeEditora VARCHAR(50) NOT NULL
);


CREATE TABLE Assunto(
IdAssunto TINYINT PRIMARY KEY IDENTITY,
NomeAssunto VARCHAR(25) NOT NULL
);

CREATE TABLE Livro(
IdLivro SMALLINT NOT NULL PRIMARY KEY IDENTITY(100,1),
NomeLivro VARCHAR(70) NOT NULL,
ISBN13 CHAR(13) UNIQUE NOT NULL,
DataPub DATE,
PrecoLivro MONEY NOT NULL,
NumeroPagina SMALLINT NOT NULL, 
IdEditora SMALLINT NOT NULL,
IdAssunto TINYINT NOT NULL,
CONSTRAINT fk_id_editora FOREIGN KEY(IdEditora)
REFERENCES Editora(IdEditora) ON DELETE CASCADE,
CONSTRAINT fk_id_Assunto FOREIGN KEY(IdAssunto)
REFERENCES Assunto(IdAssunto) ON DELETE CASCADE,
CONSTRAINT verifica_preco CHECK(PrecoLivro >= 0)

);

CREATE TABLE LivroAutor(
IdLivro SMALLINT NOT NULL,
IdAutor SMALLINT NOT NULL,
CONSTRAINT fk_id_livros FOREIGN KEY(IdLivro) REFERENCES Livro(IdLivro),
CONSTRAINT fk_id_Autores FOREIGN KEY(IdLivro) REFERENCES Autor(IdAutor),
CONSTRAINT pk_livro_autor PRIMARY KEY(IdLivro, IdAutor)
);

SELECT name FROM Biblioteca.sys.tables;

--Gerenciamento de Tabelas
--ALTER TABLE, DROP, RENAME

ALTER TABLE NomeTabela
--ADD/ ALTER / DROP Objeto;

--Adicionar uma nova coluna a uma nova tabela existente 
ALTER TABLE Livro 
ADD Edição SMALLINT;

--Alterar o tipo de dados de uma coluna 
ALTER TABLE Livro
ALTER COLUMN Edição TINYINT;

--Adicionar chave primária 
ALTER TABLE Livro
ADD PRIMARY KEY (Coluna);

--Excluir uma constraint de uma coluna 
ALTER TABLE NomeTabela
DROP CONSTRAINT NomeConstraint;

--Verificar nomes das constraints
sp_help Livro;

--Excluir uma conluna de uma tabela 
ALTER TABLE Livro 
DROP COLUMN Edição;

--Excluir uma tabela: DROP TABLE
DROP TABLE NomeTabela;


--Excluirr uma constraint de uma coluna 
ALTER TABLE NomeTabela 
DROP CONSTRAINT NomeConstraint;

--Verificar nomes das constraints:
sp_help Livro;


--Renomear uma tabela: sp_rename 
--sp_name 'nome atual', 'novo nome';
sp_rename 'Livro', 'tbl_livros';

INSERT INTO Assunto (NomeAssunto)
VALUES 
('Ficção Científica'), ('Botânica'),
('Eletrônica'), ('Matemática'),
('Aventura'), ('Romance'),
('Finanças'), ('Gastronomia'),
('Terror'), ('Administração'),
('Informática'), ('Suspense');

SELECT * FROM
Assunto


INSERT INTO Editora (NomeEditora)
VALUES
('Prentice Hall'), ('O´Reilly');

SELECT * FROM 
Editora

INSERT INTO Editora (NomeEditora)
VALUES
('Aleph'), ('Microsoft Press'),
('Wiley'), ('HarperCollins'),
('Érica'), ('Novatec'),
('McGraw-Hill'), ('Apress'),
('Francisco Alves'), ('Sybex'),
('Globo'), ('Companhia das Letras'),
('Morro Branco'), ('Penguin Books'), ('Martin Claret'),
('Record'), ('Springer'), ('Melhoramentos'),
('Oxford'), ('Taschen'), ('Ediouro'),('Bookman');

INSERT INTO Autor (NomeAutor, SobrenomeAutor)
VALUES ('Umberto','Eco');

SELECT * FROM Autor

INSERT INTO Autor (NomeAutor, SobrenomeAutor)
VALUES
('Daniel', 'Barret'), ('Gerald', 'Carter'), ('Mark', 'Sobell'),
('William', 'Stanek'), ('Christine', 'Bresnahan'), ('William', 'Gibson'),
('James', 'Joyce'), ('John', 'Emsley'), ('José', 'Saramago'),
('Richard', 'Silverman'), ('Robert', 'Byrnes'), ('Jay', 'Ts'),
('Robert', 'Eckstein'), ('Paul', 'Horowitz'), ('Winfield', 'Hill'),
('Joel', 'Murach'), ('Paul', 'Scherz'), ('Simon', 'Monk'),
('George', 'Orwell'), ('Ítalo','Calvino'), ('Machado','de Assis'),
('Oliver', 'Sacks'), ('Ray', 'Bradbury'), ('Walter', 'Isaacson'),
('Benjamin','Graham'), ('Júlio','Verne'), ('Marcelo', 'Gleiser'),
('Harri','Lorenzi'), ('Humphrey', 'Carpenter'), ('Isaac', 'Asimov'),
('Aldous', 'Huxley'), ('Arthur','Conan Doyle'), ('Blaise', 'Pascal'),
('Jostein', 'Gaarder'), ('Stephen', 'Hawking'), ('Stephen', 'Jay Gould'),
('Neil', 'De Grasse Tyson'), ('Charles', 'Darwin'), ('Alan', 'Turing'), ('Arthur', 'C. Clarke');

SELECT * FROM Autor;

INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPagina, IdAssunto, IdEditora)
VALUES ('A Arte da Eletrônica', '9788582604342',
'20170308', 300.74,  1160, 3, 24);


SELECT * FROM Livro;

INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPagina, IdAssunto, IdEditora)
VALUES
	('Vinte Mil Léguas Submarinas', '9788582850022', '2014-09-16', 24.50, 448, 1, 16), -- Júlio Verne
	('O Investidor Inteligente', '9788595080805', '2016-01-25', 79.90, 450, 7, 6); -- Benjamin Graham	

	

SELECT * FROM Livro;

-- Inserir em lote (bulk) a partir de arquivo CSV
INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPaginas, IdEditora, IdAssunto)
SELECT 
    NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPaginas,
	IdEditora, IdAssunto
FROM OPENROWSET(
    BULK 'C:\SQL\Livros.CSV',
    FORMATFILE = 'C:\SQL\Formato.xml',
	CODEPAGE = '65001',  -- UTF-8
	FIRSTROW = 2
) AS LivrosCSV;
