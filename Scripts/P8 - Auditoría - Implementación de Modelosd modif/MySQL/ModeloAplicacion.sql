DROP TABLE IF EXISTS `Invoice_Header` ;

CREATE TABLE Invoice_Header(
    idInvoice INT PRIMARY KEY AUTO_INCREMENT,
    idConstumer NVARCHAR(45),
    dateInvoice DATE,
    dateDue DATE
);

DROP TABLE IF EXISTS `Invoice_LineItem` ;

CREATE TABLE Invoice_LineItem(
    idLineItem INT PRIMARY KEY AUTO_INCREMENT,
    idInvoice INT,
    amount DOUBLE
);




-- -----------------------------------------------------
-- Table `DEBSEC2018`.`App_Audit_Actions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `App_Audit_Actions` ;

CREATE TABLE IF NOT EXISTS `App_Audit_Actions` (
  `Action_Id` INT NOT NULL AUTO_INCREMENT,
  `Action_Desc` VARCHAR(45) NULL,
  PRIMARY KEY (`Action_Id`));


-- -----------------------------------------------------
-- Table `DEBSEC2018`.`App_Audit_Trail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `App_Audit_Trail` ;

CREATE TABLE IF NOT EXISTS `App_Audit_Trail` (
  `Audit_Trail_Id` INT NOT NULL AUTO_INCREMENT,
  `Class_Id` INT NULL,
  `Action_Id` INT NULL,
  `Object_Id` INT NULL,
  `Reason` VARCHAR(45) NULL,
  `CTL_UPD_DTTM` DATE NULL,
  `CTL_UPD_USER` VARCHAR(45) NULL,
  PRIMARY KEY (`Audit_Trail_Id`));


-- -----------------------------------------------------
-- Table `DEBSEC2018`.`App_Data_Dictionary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `App_Data_Dictionary` ;

CREATE TABLE IF NOT EXISTS `App_Data_Dictionary` (
  `Class_Id` INT NOT NULL AUTO_INCREMENT,
  `Class_Desc` VARCHAR(45) NULL,
  PRIMARY KEY (`Class_Id`));



insert into App_Audit_Actions (Action_Desc) 
values ('Credit Invoice');
insert into App_Data_Dictionary(Class_Desc) 
values ('Invoice');

insert into Invoice_Header (idConstumer, dateInvoice, dateDue) values (1, CURDATE(),DATE_ADD(CURDATE(), INTERVAL 30 DAY));

insert into Invoice_LineItem (idInvoice, Amount) values (1, 5000);



DELIMITER $$

DROP PROCEDURE IF EXISTS `pCredit_Invoice` $$
CREATE PROCEDURE `pCredit_Invoice`(
  IN id INT,
  IN amt double,
  IN reason nvarchar(100)
)
BEGIN
	declare action_id INT;
    declare class_id INT;
	insert into Invoice_LineItem (idInvoice, Amount) values (id, amt);
	SELECT App_Audit_Actions.Action_Id into action_id
    FROM App_Audit_Actions
    WHERE Action_Desc ="Credit Invoice";
    
    SELECT App_Data_Dictionary.Class_Id into class_id
    FROM App_Data_Dictionary
    WHERE Class_Desc ="Invoice";
    
    INSERT INTO App_Audit_Trail(Action_Id,Class_Id,Object_Id,Reason)
	VALUES (action_id,class_id,id,reason);
END $$



DELIMITER ;
CALL pCredit_Invoice(1,-200,'Volume Discount');

SELECT * FROM App_Audit_Trail;