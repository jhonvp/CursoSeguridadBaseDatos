ALTER USER 'jhonvillarreal'@'localhost'
IDENTIFIED BY 'nuevaclavejhonvillarreal'
PASSWORD EXPIRE;

ALTER USER 'jhonvillarreal'@'localhost'
IDENTIFIED WITH sha256_password BY 'nuevaclavejhonvillarreal'
PASSWORD EXPIRE INTERVAL 180 DAY;

ALTER USER 'jhonvillarreal'@'localhost' ACCOUNT LOCK;
ALTER USER 'jhonvillarreal'@'localhost' ACCOUNT UNLOCK;