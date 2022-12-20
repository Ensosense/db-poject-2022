use iths;

drop table if exists UNF;


CREATE TABLE `UNF` (
    `Id` DECIMAL(38, 0) NOT NULL,
    `Name` VARCHAR(26) NOT NULL,
    `Grade` VARCHAR(11) NOT NULL,
    `Hobbies` VARCHAR(25),
    `City` VARCHAR(10) NOT NULL,
    `School` VARCHAR(30) NOT NULL,
    `HomePhone` VARCHAR(15),
    `JobPhone` VARCHAR(15),
    `MobilePhone1` VARCHAR(15),
    `MobilePhone2` VARCHAR(15)
)  ENGINE=INNODB;

LOAD DATA INFILE '/var/lib/mysql-files/denormalized-data.csv'
INTO TABLE UNF
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table if exists Student;

create table Student (
	StudentId int not null,
	FirstName varchar(255) not null,
	LastName varchar(255) not null,
	constraint primary key(StudentId)
)engine = innodb;

insert into Student (StudentId, FirstName, LastName) select distinct Id, substring_index(Name, ' ', 1), substring_index(Name, ' ', -1) from UNF;

