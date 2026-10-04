   -- p01_lingkungan_25430056.sql (password diganti penanda)
   CREATE DATABASE IF NOT EXISTS kopma_056
     CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER IF NOT EXISTS 'mhs_056'@'localhost' IDENTIFIED BY '<password_kerja>';
   GRANT ALL PRIVILEGES ON kopma_056.* TO 'mhs_056'@'localhost';