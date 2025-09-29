--
-- Create database user
--

DROP USER IF EXISTS 'db_user'@'%';
CREATE USER 'db_user'@'%' IDENTIFIED BY 'db_password';
GRANT ALL PRIVILEGES ON db_staging.* TO 'db_user'@'%';
GRANT CREATE ON db_staging.* TO 'db_user'@'%';
COMMIT;
FLUSH PRIVILEGES;
