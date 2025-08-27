--
-- Create database user
--
SET @dbuser_username = '';
SET @dbuser_password = '';
SET @dbuser_database = '';

DROP USER 'dfuser'@'%';
FLUSH PRIVILEGES;

CREATE USER 'dfuser'@'%' IDENTIFIED BY 'unity';

GRANT ALL PRIVILEGES ON 'testdatabase'.* TO 'dfuser'@'%';
GRANT CREATE ON 'testdatabase'.* TO 'dfuser'@'%';
COMMIT;
FLUSH PRIVILEGES;