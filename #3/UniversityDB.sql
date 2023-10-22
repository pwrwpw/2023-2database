-- 생성자 Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   위치:        2023-09-24 01:09:09 KST
--   사이트:      Oracle Database 12c
--   유형:      Oracle Database 12c

DROP TYPE phoneno_info force;

DROP TYPE person_info force;

DROP VIEW Dept_Info CASCADE CONSTRAINTS 
;

DROP VIEW Prof_of_CS CASCADE CONSTRAINTS 
;

DROP VIEW Special_Lectures CASCADE CONSTRAINTS 
;

DROP TABLE assistant CASCADE CONSTRAINTS;

DROP TABLE classlocation CASCADE CONSTRAINTS;

DROP TABLE department CASCADE CONSTRAINTS;

DROP TABLE lecture CASCADE CONSTRAINTS;

DROP TABLE lecture_of CASCADE CONSTRAINTS;

DROP TABLE lecture_schedule CASCADE CONSTRAINTS;

DROP TABLE lectureroom CASCADE CONSTRAINTS;

DROP TABLE lecturetime CASCADE CONSTRAINTS;

DROP TABLE professor CASCADE CONSTRAINTS;

DROP TABLE student CASCADE CONSTRAINTS;

DROP TABLE takinglectures CASCADE CONSTRAINTS;

CREATE OR REPLACE TYPE phoneno_info AS OBJECT (
        cellphoneno   CHAR(13),
        homephoneno   CHAR(13),
        officephoneno CHAR(13)
) NOT FINAL;
/

CREATE OR REPLACE TYPE person_info AS OBJECT (
        name        VARCHAR2(30),
        homeaddress VARCHAR2(255),
        phoneno     phoneno_info
) NOT FINAL;
/

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE assistant (
    assistantno     NUMBER(10) NOT NULL,
    info            person_info,
    responsible_for NUMBER(10) NOT NULL,
    CHECK ( info.name IS NOT NULL )
);

ALTER TABLE assistant
    ADD CHECK ( info.phoneno.cellphoneno LIKE '010-____-____' );

ALTER TABLE assistant
    ADD CHECK ( info.phoneno.homephoneno LIKE '051-____-____'
                OR info.phoneno.homephoneno IS NULL );

ALTER TABLE assistant
    ADD CHECK ( info.phoneno.officephoneno LIKE '051-____-____'
                OR info.phoneno.officephoneno IS NULL );

ALTER TABLE assistant ADD CONSTRAINT assistant_pk PRIMARY KEY ( assistantno );

CREATE TABLE classlocation (
    lecturecode  CHAR(8) NOT NULL,
    buildingname VARCHAR2(30) NOT NULL,
    roomno       NUMBER(10) NOT NULL
);

ALTER TABLE classlocation
    ADD CONSTRAINT classlocation_pk PRIMARY KEY ( buildingname,
                                                  roomno,
                                                  lecturecode );

CREATE TABLE department (
    departmentno     NUMBER(10) NOT NULL,
    name             VARCHAR2(30) NOT NULL,
    departmentoffice VARCHAR2(255) NOT NULL,
    chairman         NUMBER(10) NOT NULL
);

CREATE UNIQUE INDEX department__idx ON
    department (
        chairman
    ASC );

ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY ( departmentno );

CREATE TABLE lecture (
    lecturecode  CHAR(8) NOT NULL,
    name         VARCHAR2(30) NOT NULL,
    credit       NUMBER(2) NOT NULL,
    departmentno NUMBER(10) NOT NULL,
    assistantno  NUMBER(10) NOT NULL
);

CREATE UNIQUE INDEX lecture__idx ON
    lecture (
        lecturecode
    ASC );

ALTER TABLE lecture ADD CONSTRAINT lecture_pk PRIMARY KEY ( lecturecode );

CREATE TABLE lecture_of (
    professorno NUMBER(10) NOT NULL,
    lecturecode CHAR(8) NOT NULL
);

ALTER TABLE lecture_of ADD CONSTRAINT lecture_of_pk PRIMARY KEY ( professorno,
                                                                  lecturecode );

CREATE TABLE lecture_schedule (
    lecturecode CHAR(8) NOT NULL,
    lecturetime NUMBER NOT NULL,
    lectureday  CHAR(2) NOT NULL
);

ALTER TABLE lecture_schedule
    ADD CONSTRAINT lecture_schedule_pk PRIMARY KEY ( lecturetime,
                                                     lectureday,
                                                     lecturecode );

CREATE TABLE lectureroom (
    buildingname VARCHAR2(30) NOT NULL,
    roomno       NUMBER(10) NOT NULL,
    floor        NUMBER(2) NOT NULL,
    maxcapacity  NUMBER(10) NOT NULL
);

ALTER TABLE lectureroom ADD CONSTRAINT lectureroom_pk PRIMARY KEY ( buildingname,
                                                                    roomno );

CREATE TABLE lecturetime (
    lectureday  CHAR(2) NOT NULL,
    lecturetime NUMBER NOT NULL
);

ALTER TABLE lecturetime ADD CONSTRAINT lecturetime_pk PRIMARY KEY ( lecturetime,
                                                                    lectureday );

CREATE TABLE professor (
    professorno   NUMBER(10) NOT NULL,
    info          person_info,
    officeaddress VARCHAR2(255) NOT NULL,
    major         VARCHAR2(50) NOT NULL,
    departmentno  NUMBER(10) NOT NULL,
    CHECK ( info.name IS NOT NULL )
);

ALTER TABLE professor
    ADD CHECK ( info.phoneno.cellphoneno LIKE '010-____-____' );

ALTER TABLE professor
    ADD CHECK ( info.phoneno.homephoneno LIKE '051-____-____'
                OR info.phoneno.homephoneno IS NULL );

ALTER TABLE professor
    ADD CHECK ( info.phoneno.officephoneno LIKE '051-____-____'
                OR info.phoneno.officephoneno IS NULL );

ALTER TABLE professor ADD CONSTRAINT professor_pk PRIMARY KEY ( professorno );

CREATE TABLE student (
    studentno NUMBER(10) NOT NULL,
    info      person_info,
    degree    VARCHAR2(50) NOT NULL,
    major     NUMBER(10) NOT NULL,
    minor     NUMBER(10),
    CHECK ( info.name IS NOT NULL )
);

ALTER TABLE student
    ADD CHECK ( info.phoneno.cellphoneno LIKE '010-____-____' );

ALTER TABLE student
    ADD CHECK ( info.phoneno.homephoneno LIKE '051-____-____'
                OR info.phoneno.homephoneno IS NULL );

ALTER TABLE student
    ADD CHECK ( info.phoneno.officephoneno LIKE '051-____-____'
                OR info.phoneno.officephoneno IS NULL );

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( studentno );

CREATE TABLE takinglectures (
    lecturecode CHAR(8) NOT NULL,
    studentno   NUMBER(10) NOT NULL
);

ALTER TABLE takinglectures ADD CONSTRAINT takinglectures_pk PRIMARY KEY ( lecturecode,
                                                                          studentno );

ALTER TABLE assistant
    ADD CONSTRAINT belong_to_assis FOREIGN KEY ( responsible_for )
        REFERENCES department ( departmentno );

ALTER TABLE professor
    ADD CONSTRAINT belong_to_profess FOREIGN KEY ( departmentno )
        REFERENCES department ( departmentno );

ALTER TABLE department
    ADD CONSTRAINT chair_of FOREIGN KEY ( chairman )
        REFERENCES professor ( professorno );

ALTER TABLE classlocation
    ADD CONSTRAINT classlocation_lecture_fk FOREIGN KEY ( lecturecode )
        REFERENCES lecture ( lecturecode );

ALTER TABLE classlocation
    ADD CONSTRAINT classlocation_lectureroom_fk FOREIGN KEY ( buildingname,
                                                              roomno )
        REFERENCES lectureroom ( buildingname,
                                 roomno );

ALTER TABLE lecture
    ADD CONSTRAINT depart_of_lecture FOREIGN KEY ( departmentno )
        REFERENCES department ( departmentno );

ALTER TABLE lecture_schedule
    ADD CONSTRAINT lecture_fk FOREIGN KEY ( lecturecode )
        REFERENCES lecture ( lecturecode );

ALTER TABLE lecture_of
    ADD CONSTRAINT lecture_of_lecture_fk FOREIGN KEY ( lecturecode )
        REFERENCES lecture ( lecturecode );

ALTER TABLE lecture_of
    ADD CONSTRAINT lecture_of_professor_fk FOREIGN KEY ( professorno )
        REFERENCES professor ( professorno );

ALTER TABLE lecture_schedule
    ADD CONSTRAINT lecturetime_fk FOREIGN KEY ( lecturetime,
                                                lectureday )
        REFERENCES lecturetime ( lecturetime,
                                 lectureday );

ALTER TABLE student
    ADD CONSTRAINT major FOREIGN KEY ( major )
        REFERENCES department ( departmentno );

ALTER TABLE lecture
    ADD CONSTRAINT manager FOREIGN KEY ( assistantno )
        REFERENCES assistant ( assistantno );

ALTER TABLE student
    ADD CONSTRAINT minor FOREIGN KEY ( minor )
        REFERENCES department ( departmentno );

ALTER TABLE takinglectures
    ADD CONSTRAINT takinglectures_lecture_fk FOREIGN KEY ( lecturecode )
        REFERENCES lecture ( lecturecode );

ALTER TABLE takinglectures
    ADD CONSTRAINT takinglectures_student_fk FOREIGN KEY ( studentno )
        REFERENCES student ( studentno );

CREATE OR REPLACE VIEW Dept_Info ( 학과이름, 교수수, 조교수 ) AS
SELECT
    d.name                        AS 학과이름,
    COUNT(DISTINCT p.professorno) AS 교수수,
    COUNT(DISTINCT a.assistantno) AS 조교수
FROM
    department d,
    professor  p,
    assistant  a
WHERE
        d.departmentno = p.departmentno
    AND d.departmentno = a.responsible_for
GROUP BY
    d.name
HAVING
    COUNT(DISTINCT p.professorno) >= 2 
;

CREATE OR REPLACE VIEW Prof_of_CS ( 소속학과, 이름, 담당강의수, 교수사무실 ) AS
SELECT
    d.name               AS 소속학과,
    p.info.name          AS 이름,
    COUNT(l.lecturecode) AS 담당강의수,
    p.officeaddress      AS 교수사무실
FROM
    professor  p,
    department d,
    lecture_of l
WHERE
        p.departmentno = d.departmentno
    AND p.professorno = l.professorno
    AND d.name = '소프트웨어학과'
GROUP BY
    d.name,
    p.info.name,
    p.officeaddress 
;

CREATE OR REPLACE VIEW Special_Lectures ( 강의날짜, 강의시간, 강의명, 건물명, 호실 ) AS
SELECT
    ls.lectureday   AS 강의날짜,
    ls.lecturetime  AS 강의시간,
    l.name          AS 강의명,
    cl.buildingname AS 건물명,
    cl.roomno       AS 호실
FROM
    lecture_schedule ls,
    lecture          l,
    classlocation    cl
WHERE
        l.lecturecode = ls.lecturecode
    AND l.lecturecode = cl.lecturecode
    AND ls.lectureday IN ( '월', '수', '금' )
    AND ls.lecturetime >= 6
    AND ls.lecturetime <= 9
GROUP BY
    ls.lectureday,
    ls.lecturetime,
    l.name,
    cl.buildingname,
    cl.roomno
ORDER BY
    강의날짜 DESC,
    강의시간 ASC,
    강의명 ASC 
;



-- Oracle SQL Developer Data Modeler 요약 보고서: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             2
-- ALTER TABLE                             35
-- CREATE VIEW                              3
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   2
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
