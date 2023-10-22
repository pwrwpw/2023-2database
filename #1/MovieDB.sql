-- 생성자 Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   위치:        2023-09-08 00:34:44 KST
--   사이트:      Oracle Database 12c
--   유형:      Oracle Database 12c



DROP TABLE address CASCADE CONSTRAINTS;

DROP TABLE movie CASCADE CONSTRAINTS;

DROP TABLE movieexec CASCADE CONSTRAINTS;

DROP TABLE moviestar CASCADE CONSTRAINTS;

DROP TABLE phonenumber CASCADE CONSTRAINTS;

DROP TABLE starsin CASCADE CONSTRAINTS;

DROP TABLE studio CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE address (
    address VARCHAR2(255) NOT NULL,
    name    VARCHAR2(30)
);

ALTER TABLE address ADD CONSTRAINT address_pk PRIMARY KEY ( address );

CREATE TABLE movie (
    title           VARCHAR2(255) NOT NULL,
    year            NUMBER(4) NOT NULL,
    length          NUMBER(3),
    incolor         CHAR(1),
    studioname      VARCHAR2(30) NOT NULL,
    producerno      NUMBER(6) NOT NULL,
    directno        NUMBER(6) NOT NULL,
    soundstudioname VARCHAR2(30) NOT NULL
);

ALTER TABLE movie ADD CHECK ( year BETWEEN 1900 AND 2023 );

ALTER TABLE movie
    ADD CHECK ( length > 50
                AND length < 300 );

ALTER TABLE movie
    ADD CHECK ( incolor IN ( 'F', 'T', 'f', 't' ) );

ALTER TABLE movie ADD CONSTRAINT movie_pk PRIMARY KEY ( title,
                                                        year );

CREATE TABLE movieexec (
    name     VARCHAR2(30),
    address  VARCHAR2(255),
    certno   NUMBER(6) NOT NULL,
    networth NUMBER(38)
);

ALTER TABLE movieexec ADD CONSTRAINT movieexec_pk PRIMARY KEY ( certno );

ALTER TABLE movieexec ADD CONSTRAINT unique_name UNIQUE ( name );

CREATE TABLE moviestar (
    name         VARCHAR2(30) NOT NULL,
    address      VARCHAR2(255),
    gender       CHAR(6),
    birthdate    DATE,
    spousecertno NUMBER(6)
);

ALTER TABLE moviestar
    ADD CHECK ( gender IN ( 'female', 'male' ) );

CREATE UNIQUE INDEX moviestar__idx ON
    moviestar (
        spousecertno
    ASC );

ALTER TABLE moviestar ADD CONSTRAINT moviestar_pk PRIMARY KEY ( name );

CREATE TABLE phonenumber (
    phonenum   CHAR(13) NOT NULL,
    provider   VARCHAR2(30),
    plan       VARCHAR2(30),
    starname   VARCHAR2(30),
    execcertno NUMBER(6),
    studioname VARCHAR2(30)
);

ALTER TABLE phonenumber ADD CONSTRAINT phonenumber_pk PRIMARY KEY ( phonenum );

CREATE TABLE starsin (
    movietitle VARCHAR2(255) NOT NULL,
    movieyear  NUMBER(4) NOT NULL,
    starname   VARCHAR2(30) NOT NULL
);

ALTER TABLE starsin ADD CHECK ( movieyear BETWEEN 1900 AND 2023 );

ALTER TABLE starsin
    ADD CONSTRAINT starsin_pk PRIMARY KEY ( movietitle,
                                            movieyear,
                                            starname );

CREATE TABLE studio (
    name     VARCHAR2(30) NOT NULL,
    presno   NUMBER(6) NOT NULL,
    empcount NUMBER(3)
);

ALTER TABLE studio ADD CHECK ( empcount BETWEEN 10 AND 100 );

ALTER TABLE studio ADD CONSTRAINT studio_pk PRIMARY KEY ( name );

ALTER TABLE movie
    ADD CONSTRAINT directed FOREIGN KEY ( directno )
        REFERENCES movieexec ( certno );

ALTER TABLE starsin
    ADD CONSTRAINT movie_of_starsin FOREIGN KEY ( movietitle,
                                                  movieyear )
        REFERENCES movie ( title,
                           year );

ALTER TABLE phonenumber
    ADD CONSTRAINT movieexec_of_phonenumber FOREIGN KEY ( execcertno )
        REFERENCES movieexec ( certno );

ALTER TABLE phonenumber
    ADD CONSTRAINT moviestar_of_phonenumber FOREIGN KEY ( starname )
        REFERENCES moviestar ( name );

ALTER TABLE movie
    ADD CONSTRAINT owns FOREIGN KEY ( studioname )
        REFERENCES studio ( name );

ALTER TABLE studio
    ADD CONSTRAINT pres FOREIGN KEY ( presno )
        REFERENCES movieexec ( certno );

ALTER TABLE movie
    ADD CONSTRAINT producer FOREIGN KEY ( producerno )
        REFERENCES movieexec ( certno );

ALTER TABLE movie
    ADD CONSTRAINT sounds FOREIGN KEY ( soundstudioname )
        REFERENCES studio ( name );

ALTER TABLE moviestar
    ADD CONSTRAINT spouse FOREIGN KEY ( spousecertno )
        REFERENCES movieexec ( certno );

ALTER TABLE starsin
    ADD CONSTRAINT starsin_of_moviestar FOREIGN KEY ( starname )
        REFERENCES moviestar ( name );

ALTER TABLE address
    ADD CONSTRAINT studio_of_address FOREIGN KEY ( name )
        REFERENCES studio ( name );

ALTER TABLE phonenumber
    ADD CONSTRAINT studio_of_phonenumber FOREIGN KEY ( studioname )
        REFERENCES studio ( name );



-- Oracle SQL Developer Data Modeler 요약 보고서: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                             1
-- ALTER TABLE                             26
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
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
