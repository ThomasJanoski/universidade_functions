SET GLOBAL log_bin_trust_function_creators = 1;

CREATE TABLE Areas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nomeArea VARCHAR(255) NOT NULL
);

CREATE TABLE Cursos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nomeCurso VARCHAR(255) NOT NULL,
    areaID INT,
    FOREIGN KEY (areaID) REFERENCES Areas(ID)
);

CREATE TABLE Alunos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nomeAluno VARCHAR(255) NOT NULL,
    sobrenomeAluno VARCHAR(255) NOT NULL,
    emailAluno VARCHAR(255) UNIQUE,
    cursoID INT NOT NULL,
    
    FOREIGN KEY (cursoID) REFERENCES Cursos(ID)
);

DELIMITER $

CREATE PROCEDURE InserirCurso (nomeCurso_Var VARCHAR(255), nomeArea_Var VARCHAR(255)) BEGIN
    DECLARE areaID INT;

    SELECT ID INTO areaID FROM Areas WHERE nomeArea = nomeArea_Var;

    IF areaID IS NULL THEN
        INSERT INTO Areas (nomeArea) VALUES (nomeArea_Var);

        SET areaId = LAST_INSERT_ID();
    END IF;

    INSERT INTO Cursos (nomeCurso, areaID) VALUES (nomeCurso_Var, areaID);
END $

DELIMITER ;

DELIMITER $

CREATE FUNCTION GetCursoID (nomeCurso_Var VARCHAR(255), nomeArea_Var VARCHAR(255)) RETURNS INT BEGIN
    DECLARE cursoID INT;

    SELECT Cursos.ID INTO cursoID FROM Cursos
    JOIN Areas ON Cursos.areaID = Areas.ID
    WHERE Cursos.nomeCurso = nomeCurso_Var AND Areas.nomeArea = nomeArea_Var;

    RETURN cursoID;
END $

DELIMITER ;
DELIMITER $

CREATE PROCEDURE InserirAluno (nomeAluno_Var VARCHAR(255), sobrenomeAluno_Var VARCHAR(255), nomeCurso_Var VARCHAR(255), nomeArea_Var VARCHAR(255)) BEGIN
    DECLARE emailAluno_Var VARCHAR(255);
	DECLARE cursoID INT;

    SET emailAluno_Var = CONCAT(LOWER(nomeAluno_Var), '.', LOWER(sobrenomeAluno_Var), '@facens.br');
	SET cursoID = GetCursoID(nomeCurso_Var, nomeArea_Var);

    INSERT INTO Alunos (nomeAluno, sobrenomeAluno, emailAluno, cursoID) VALUES (nomeAluno_Var, sobrenomeAluno_Var, emailAluno_Var, cursoID)
    ON DUPLICATE KEY UPDATE ID = LAST_INSERT_ID(ID);
END $