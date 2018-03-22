CREATE TABLE Empresas(
    idEmpresa INT PRIMARY KEY AUTOINCREMENT,
    nombreEmpresa VARCHAR(45),
    ciudadEmpresa varchar(45)
);

CREATE TABLE Empresas_Historico(
    idHistorico INT PRIMARY KEY AUTOINCREMENT,
    idEmpresa INT,
    nombreEmpresa VARCHAR(45),
    ciudadEmpresa varchar(45)
);

DROP TRIGGER IF EXISTS empresaHistorico;

DELIMITER $$

CREATE TRIGGER empresaHistorico BEFORE INSERT ON Empresas
	FOR EACH ROW
       BEGIN
          INSERT INTO Empresas_Historico(idEmpresa,nombreEmpresa,ciudadEmpresa) VALUES (NEW.idEmpresa,NEW.nombreEmpresa,NEW.ciudadEmpresa);
       END; $$
DELIMITER ;

INSERT INTO Empresas(nombreEmpresa,ciudadEmpresa) VALUES ("COCA COLA","BOGOTA");

SELECT * FROM Empresas;

SELECT * FROM Empresas_Historico;
