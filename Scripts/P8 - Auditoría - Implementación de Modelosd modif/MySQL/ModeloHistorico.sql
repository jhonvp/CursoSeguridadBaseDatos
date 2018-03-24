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



DROP TRIGGER IF EXISTS empresaHistoricoUpdate;

DELIMITER $$

CREATE TRIGGER empresaHistoricoUpdate BEFORE UPDATE ON Empresas
	FOR EACH ROW
       BEGIN
          INSERT INTO Empresas_Historico_Update
          (idEmpresa,nombreEmpresaOld,nombreEmpresaNew,ciudadEmpresaOld,
          ciudadEmpresaNew,fecha)
            VALUES (NEW.idEmpresa,OLD.nombreEmpresa,
            NEW.nombreEmpresa,OLD.ciudadEmpresa,
            NEW.ciudadEmpresa, CURDATE());
       END; $$
DELIMITER ;

UPDATE Empresas
SET nombreEmpresa="Nueva Empresa",ciudadEmpresa="NuevaCiudad"
WHERE idEmpresa=1;

SELECT *
FROM Empresas;
SELECT *
FROM Empresas_Historico_Update;