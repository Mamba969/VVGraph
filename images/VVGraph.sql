USE MASTER
GO
DROP DATABASE IF EXISTS VVGraph
GO
CREATE DATABASE VVGraph
GO
USE VVGraph
GO

-- Создание таблицы для врачей
CREATE TABLE Doctor (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    experience_years INT NOT NULL
) AS NODE;

-- Создание таблицы для пациентов
CREATE TABLE Patient (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    condition VARCHAR(100) NOT NULL
) AS NODE;

-- Создание таблицы для палат
CREATE TABLE Ward (
    id INT PRIMARY KEY IDENTITY,
    ward_number VARCHAR(10) NOT NULL,
    type VARCHAR(100) NOT NULL
) AS NODE;


CREATE TABLE Occupies AS EDGE
CREATE TABLE Heals AS EDGE
CREATE TABLE Works AS EDGE

-- Вставка данных в таблицу врачей
INSERT INTO Doctor (name, specialization, experience_years) VALUES 
('Dr. Alice Brown', 'Cardiologist', 15),
('Dr. Bob Green', 'Orthopedist', 10),
('Dr. Charlie White', 'Neurologist', 20),
('Dr. Diana Black', 'Pediatrician', 12),
('Dr. Edward Harris', 'Dermatologist', 8),
('Dr. Fiona Clark', 'General Practitioner', 5),
('Dr. George King', 'Endocrinologist', 18),
('Dr. Hannah Scott', 'Oncologist', 22),
('Dr. Ian Miller', 'Urologist', 9),
('Dr. Jane Walker', 'Rheumatologist', 11);

-- Вставка данных в таблицу пациентов
INSERT INTO Patient (name, age, condition) VALUES 
('John Doe', 45, 'Cardiac'),
('Jane Smith', 30, 'Orthopedic'),
('Emily Davis', 50, 'Neurology'),
('Michael Johnson', 40, 'Pediatric'),
('Sarah Wilson', 25, 'Dermatology'),
('David Moore', 60, 'General'),
('Linda Taylor', 35, 'Endocrinology'),
('James Anderson', 55, 'Oncology'),
('Patricia Thomas', 70, 'Urology'),
('Robert Jackson', 20, 'Rheumatology');

-- Вставка данных в таблицу палат
INSERT INTO Ward (ward_number, type) VALUES 
('101', 'Intensive Care'),
('102', 'General'),
('103', 'Surgery'),
('104', 'Pediatric'),
('105', 'Dermatology'),
('106', 'General'),
('107', 'Endocrinology'),
('108', 'Oncology'),
('109', 'Urology'),
('110', 'Rheumatology');



INSERT INTO Works ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Doctor WHERE id = 1),
 (SELECT $node_id FROM Doctor WHERE id = 2)),
 ((SELECT $node_id FROM Doctor WHERE id = 10),
 (SELECT $node_id FROM Doctor WHERE id = 5)),
 ((SELECT $node_id FROM Doctor WHERE id = 2),
 (SELECT $node_id FROM Doctor WHERE id = 9)),
 ((SELECT $node_id FROM Doctor WHERE id = 3),
 (SELECT $node_id FROM Doctor WHERE id = 1)),
 ((SELECT $node_id FROM Doctor WHERE id = 3),
 (SELECT $node_id FROM Doctor WHERE id = 6)),
 ((SELECT $node_id FROM Doctor WHERE id = 4),
 (SELECT $node_id FROM Doctor WHERE id = 2)),
 ((SELECT $node_id FROM Doctor WHERE id = 5),
 (SELECT $node_id FROM Doctor WHERE id = 4)),
 ((SELECT $node_id FROM Doctor WHERE id = 6),
 (SELECT $node_id FROM Doctor WHERE id = 7)),
 ((SELECT $node_id FROM Doctor WHERE id = 6),
 (SELECT $node_id FROM Doctor WHERE id = 8)),
 ((SELECT $node_id FROM Doctor WHERE id = 8),
 (SELECT $node_id FROM Doctor WHERE id = 3));

INSERT INTO Heals ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Doctor WHERE ID = 1),
 (SELECT $node_id FROM Patient WHERE ID = 1)),
 ((SELECT $node_id FROM Doctor WHERE ID = 5),
 (SELECT $node_id FROM Patient WHERE ID = 1)),
 ((SELECT $node_id FROM Doctor WHERE ID = 8),
 (SELECT $node_id FROM Patient WHERE ID = 1)),
 ((SELECT $node_id FROM Doctor WHERE ID = 2),
 (SELECT $node_id FROM Patient WHERE ID = 2)),
 ((SELECT $node_id FROM Doctor WHERE ID = 3),
 (SELECT $node_id FROM Patient WHERE ID = 3)),
 ((SELECT $node_id FROM Doctor WHERE ID = 4),
 (SELECT $node_id FROM Patient WHERE ID = 3)),
 ((SELECT $node_id FROM Doctor WHERE ID = 6),
 (SELECT $node_id FROM Patient WHERE ID = 4)),
 ((SELECT $node_id FROM Doctor WHERE ID = 7),
 (SELECT $node_id FROM Patient WHERE ID = 4)),
 ((SELECT $node_id FROM Doctor WHERE ID = 1),
 (SELECT $node_id FROM Patient WHERE ID = 9)),
 ((SELECT $node_id FROM Doctor WHERE ID = 9),
 (SELECT $node_id FROM Patient WHERE ID = 4)),
 ((SELECT $node_id FROM Doctor WHERE ID = 10),
 (SELECT $node_id FROM Patient WHERE ID = 9));


INSERT INTO Occupies ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Patient WHERE ID = 1),
 (SELECT $node_id FROM Ward WHERE ID = 6)),
 ((SELECT $node_id FROM Patient WHERE ID = 5),
 (SELECT $node_id FROM Ward WHERE ID = 1)),
 ((SELECT $node_id FROM Patient WHERE ID = 8),
 (SELECT $node_id FROM Ward WHERE ID = 7)),
 ((SELECT $node_id FROM Patient WHERE ID = 2),
 (SELECT $node_id FROM Ward WHERE ID = 2)),
 ((SELECT $node_id FROM Patient WHERE ID = 3),
 (SELECT $node_id FROM Ward WHERE ID = 5)),
 ((SELECT $node_id FROM Patient WHERE ID = 4),
 (SELECT $node_id FROM Ward WHERE ID = 3)),
 ((SELECT $node_id FROM Patient WHERE ID = 6),
 (SELECT $node_id FROM Ward WHERE ID = 4)),
 ((SELECT $node_id FROM Patient WHERE ID = 7),
 (SELECT $node_id FROM Ward WHERE ID = 2)),
 ((SELECT $node_id FROM Patient WHERE ID = 1),
 (SELECT $node_id FROM Ward WHERE ID = 9)),
 ((SELECT $node_id FROM Patient WHERE ID = 9),
 (SELECT $node_id FROM Ward WHERE ID = 8)),
 ((SELECT $node_id FROM Patient WHERE ID = 10),
 (SELECT $node_id FROM Ward WHERE ID = 9));

 SELECT D1.name, D2.name
FROM Doctor AS D1
	, Works AS w
	, Doctor AS D2
WHERE MATCH(D1-(w)->D2)
	AND D1.name = 'Dr. Charlie White';

SELECT D.name, P.name
FROM Doctor AS D
	, Heals AS h
	, Patient AS P
WHERE MATCH(D-(h)->P)
AND D.name = 'Dr. Alice Brown';

SELECT D.name, P.name
FROM Doctor AS D
	, Heals AS h
	, Patient AS P
WHERE MATCH(D-(h)->P)
AND P.name = 'Emily Davis';

SELECT W.ward_number, P.name
FROM Ward AS W
	, Occupies AS o
	, Patient AS P
WHERE MATCH(P-(o)->W)
AND P.name = 'John Doe';


SELECT W.ward_number, P.name
FROM Ward AS W
	, Occupies AS o
	, Patient AS P
WHERE MATCH(P-(o)->W)
AND W.ward_number = 102;

SELECT D1.name
	, STRING_AGG(D2.name, '->') WITHIN GROUP (GRAPH PATH)
FROM Doctor AS D1
	, Works FOR PATH AS W
	, Doctor FOR PATH AS D2
WHERE MATCH(SHORTEST_PATH(D1(-(W)->D2)+))
	AND D1.name = 'Dr. Charlie White';

	
SELECT D1.name
	, STRING_AGG(D2.name, '->') WITHIN GROUP (GRAPH PATH)
FROM Doctor AS D1
	, Works FOR PATH AS W
	, Doctor FOR PATH AS D2
WHERE MATCH(SHORTEST_PATH(D1(-(W)->D2){1,2}))
	AND D1.name = 'Dr. Charlie White';

SELECT D1.ID AS IdFirst
	, D1.name AS First
	, CONCAT(N'doctor (', D1.id, ')') AS [First image name]
	, D2.ID AS IdSecond
	, D2.name AS Second
	, CONCAT(N'doctor (', D2.id, ')') AS [Second image name]
FROM Doctor AS D1
	, Works AS w
	, Doctor AS D2
WHERE MATCH(D1-(w)->D2)

SELECT D.ID AS IdFirst
	, D.name AS First
	, CONCAT(N'doctor (', D.id, ')') AS [First image name]
	, P.ID AS IdSecond
	, P.name AS Second
	, CONCAT(N'patient (', P.id, ')') AS [Second image name]
FROM Doctor AS D
	, Heals AS h
	, Patient AS P
WHERE MATCH(D-(h)->P)

SELECT W.ID AS IdFirst
	, W.ward_number AS First
	, CONCAT(N'ward (', W.id, ')') AS [First image name]
	, P.ID AS IdSecond
	, P.name AS Second
	, CONCAT(N'patient (', P.id, ')') AS [Second image name]
FROM Ward AS W
	, Occupies AS o
	, Patient AS P
WHERE MATCH(P-(o)->W)

select @@servername