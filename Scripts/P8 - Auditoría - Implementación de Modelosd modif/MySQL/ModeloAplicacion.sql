CREATE TABLE Invoice_Header(
    idInvoice INT PRIMARY KEY,
    idConstumer NVARCHAR(45),
    dataInvoice DATE,
    dataDue DATE
);


CREATE TABLE Invoice_LineItem(
    idLineItem INT PRIMARY KEY,
    idInvoice INT,
    amount DOUBLE
);



insert into App_Audit_Actions (Action_Desc) values ('Credit Invoice');
insert into App_Data_Dictionary(Class_Desc) values ('Invoice');

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