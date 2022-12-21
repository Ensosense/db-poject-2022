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



drop table if exists School;

create table School select distinct 0 as SchoolId, School as Name, City from UNF;

set @id = 0;

update School set SchoolId = (select @id := @id + 1);

alter table School add primary key(SchoolId);


drop table if exists StudentSchool;

create table StudentSchool select distinct UNF.Id as StudentId, School.SchoolId from UNF join School on UNF.School = School.Name;

alter table StudentSchool modify column StudentId int;
alter table StudentSchool modify column SchoolId int;
alter table StudentSchool add primary key(StudentId, SchoolId);

SELECT StudentId, FirstName, LastName, Name, City FROM Student
JOIN StudentSchool USING (StudentId)
JOIN School USING (SchoolId);


drop table if exists Phone;

CREATE TABLE Phone (
    PhoneId INT NOT NULL AUTO_INCREMENT,
    StudentId INT NOT NULL,
    Type VARCHAR(32),
    Number VARCHAR(32) NOT NULL,
    CONSTRAINT PRIMARY KEY(PhoneId)
);

INSERT INTO Phone(StudentId, Type, Number)
SELECT ID As StudentId, "Home" AS Type, HomePhone as Number FROM UNF
WHERE HomePhone IS NOT NULL AND HomePhone != ''
UNION SELECT ID As StudentId, "Job" AS Type, JobPhone as Number FROM UNF
WHERE JobPhone IS NOT NULL AND JobPhone != ''
UNION SELECT ID As StudentId, "Mobile" AS Type, MobilePhone1 as Number FROM UNF
WHERE MobilePhone1 IS NOT NULL AND MobilePhone1 != ''
UNION SELECT ID As StudentId, "Mobile" AS Type, MobilePhone2 as Number FROM UNF
WHERE MobilePhone2 IS NOT NULL AND MobilePhone2 != ''
;	

















