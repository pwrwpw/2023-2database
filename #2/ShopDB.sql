-- 생성자 Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   위치:        2023-09-16 22:32:46 KST
--   사이트:      Oracle Database 12c
--   유형:      Oracle Database 12c



DROP TABLE answer CASCADE CONSTRAINTS;

DROP TABLE board CASCADE CONSTRAINTS;

DROP TABLE delivery_board CASCADE CONSTRAINTS;

DROP TABLE employee CASCADE CONSTRAINTS;

DROP TABLE manufacturers CASCADE CONSTRAINTS;

DROP TABLE member CASCADE CONSTRAINTS;

DROP TABLE order_of_product CASCADE CONSTRAINTS;

DROP TABLE orders CASCADE CONSTRAINTS;

DROP TABLE product CASCADE CONSTRAINTS;

DROP TABLE product_board CASCADE CONSTRAINTS;

DROP TABLE product_of_manufac CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE answer (
    manageno    NUMBER(7) NOT NULL,
    title       VARCHAR2(30) NOT NULL,
    postingdate DATE NOT NULL
);

ALTER TABLE answer
    ADD CHECK ( postingdate >= DATE '2023-01-01'
                AND postingdate < DATE '2024-01-01' );

CREATE UNIQUE INDEX answer__idx ON
    answer (
        title
    ASC,
        postingdate
    ASC );

ALTER TABLE answer ADD CONSTRAINT answer_pk PRIMARY KEY ( manageno );

CREATE TABLE board (
    title       VARCHAR2(30) NOT NULL,
    postingdate DATE NOT NULL,
    context     VARCHAR2(255) NOT NULL
);

ALTER TABLE board
    ADD CHECK ( postingdate >= DATE '2023-01-01'
                AND postingdate < DATE '2024-01-01' );

ALTER TABLE board ADD CONSTRAINT board_pk PRIMARY KEY ( title,
                                                        postingdate );

CREATE TABLE delivery_board (
    dboardtitle       VARCHAR2(30) NOT NULL,
    dboardpostingdate DATE NOT NULL,
    writeacc          CHAR(20) NOT NULL
);

ALTER TABLE delivery_board
    ADD CHECK ( dboardpostingdate >= DATE '2023-01-01'
                AND dboardpostingdate < DATE '2024-01-01' );

ALTER TABLE delivery_board ADD CONSTRAINT delivery_board_pk PRIMARY KEY ( dboardtitle,
                                                                          dboardpostingdate );

CREATE TABLE employee (
    empno      NUMBER(7) NOT NULL,
    empaccount CHAR(20) NOT NULL,
    empname    VARCHAR2(30) NOT NULL,
    empphoneno CHAR(13),
    empaddress VARCHAR2(255),
    empemail   VARCHAR2(100),
    department VARCHAR2(30)
);

ALTER TABLE employee ADD CHECK ( empphoneno LIKE '010-____-____' );

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY ( empno );

ALTER TABLE employee ADD CONSTRAINT "Unique" UNIQUE ( empaccount );

CREATE TABLE manufacturers (
    companyname    VARCHAR2(30) NOT NULL,
    companyphoneno CHAR(13),
    companyaddress VARCHAR2(255) NOT NULL
);

ALTER TABLE manufacturers ADD CHECK ( companyphoneno LIKE '010-____-____' );

ALTER TABLE manufacturers ADD CONSTRAINT manufacturers_pk PRIMARY KEY ( companyname );

CREATE TABLE member (
    memaccount  CHAR(20) NOT NULL,
    homeaddress VARCHAR2(255) NOT NULL,
    memname     VARCHAR2(30) NOT NULL,
    workaddress VARCHAR2(255),
    homephoneno CHAR(13),
    workphoneno CHAR(13),
    mememail    VARCHAR2(100)
);

ALTER TABLE member ADD CHECK ( homephoneno LIKE '010-____-____' );

ALTER TABLE member ADD CHECK ( workphoneno LIKE '010-____-____' );

ALTER TABLE member ADD CONSTRAINT member_pk PRIMARY KEY ( memaccount );

CREATE TABLE order_of_product (
    orderno   NUMBER(7) NOT NULL,
    productno NUMBER(7) NOT NULL
);

ALTER TABLE order_of_product ADD CONSTRAINT order_of_product_pk PRIMARY KEY ( orderno,
                                                                              productno );

CREATE TABLE orders (
    orderno         NUMBER(7) NOT NULL,
    orderdate       DATE NOT NULL,
    orderaccount    CHAR(20) NOT NULL,
    deliveryaddress VARCHAR2(255)
);

ALTER TABLE orders
    ADD CHECK ( orderdate >= DATE '2023-01-01'
                AND orderdate < DATE '2024-01-01' );

ALTER TABLE orders ADD CONSTRAINT order_pk PRIMARY KEY ( orderno );

CREATE TABLE product (
    productno      NUMBER(7) NOT NULL,
    productname    VARCHAR2(30) NOT NULL,
    price          NUMBER(9) NOT NULL,
    inventorycount NUMBER(7) NOT NULL
);

ALTER TABLE product ADD CONSTRAINT product_pk PRIMARY KEY ( productno );

CREATE TABLE product_board (
    pboardtitle       VARCHAR2(30) NOT NULL,
    pboardpostingdate DATE NOT NULL,
    writeacc          CHAR(20) NOT NULL
);

ALTER TABLE product_board
    ADD CHECK ( pboardpostingdate >= DATE '2023-01-01'
                AND pboardpostingdate < DATE '2024-01-01' );

ALTER TABLE product_board ADD CONSTRAINT product_board_pk PRIMARY KEY ( pboardtitle,
                                                                        pboardpostingdate );

CREATE TABLE product_of_manufac (
    companyname VARCHAR2(30) NOT NULL,
    productno   NUMBER(7) NOT NULL
);

ALTER TABLE product_of_manufac ADD CONSTRAINT product_of_manufac_pk PRIMARY KEY ( companyname,
                                                                                  productno );

ALTER TABLE answer
    ADD CONSTRAINT board_of_answer FOREIGN KEY ( title,
                                                 postingdate )
        REFERENCES board ( title,
                           postingdate );

ALTER TABLE delivery_board
    ADD CONSTRAINT dboard_of_board FOREIGN KEY ( dboardtitle,
                                                 dboardpostingdate )
        REFERENCES board ( title,
                           postingdate );

ALTER TABLE answer
    ADD CONSTRAINT employee_of_answer FOREIGN KEY ( manageno )
        REFERENCES employee ( empno );

ALTER TABLE delivery_board
    ADD CONSTRAINT member_of_dboard FOREIGN KEY ( writeacc )
        REFERENCES member ( memaccount );

ALTER TABLE orders
    ADD CONSTRAINT member_of_order FOREIGN KEY ( orderaccount )
        REFERENCES member ( memaccount );

ALTER TABLE product_board
    ADD CONSTRAINT member_of_pboard FOREIGN KEY ( writeacc )
        REFERENCES member ( memaccount );

ALTER TABLE order_of_product
    ADD CONSTRAINT order_of_product_order_fk FOREIGN KEY ( orderno )
        REFERENCES orders ( orderno );

ALTER TABLE order_of_product
    ADD CONSTRAINT order_of_product_product_fk FOREIGN KEY ( productno )
        REFERENCES product ( productno );

ALTER TABLE product_board
    ADD CONSTRAINT pboard_of_board FOREIGN KEY ( pboardtitle,
                                                 pboardpostingdate )
        REFERENCES board ( title,
                           postingdate );

ALTER TABLE product_of_manufac
    ADD CONSTRAINT product_of_manufac_fk FOREIGN KEY ( companyname )
        REFERENCES manufacturers ( companyname );

ALTER TABLE product_of_manufac
    ADD CONSTRAINT product_of_manufac_product_fk FOREIGN KEY ( productno )
        REFERENCES product ( productno );



-- Oracle SQL Developer Data Modeler 요약 보고서: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             1
-- ALTER TABLE                             32
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
