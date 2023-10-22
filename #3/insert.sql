-- 데이터 입력을 위한 제약 삭제 --
ALTER TABLE department
    DROP CONSTRAINT chair_of;

-- 학과 --
INSERT INTO Department VALUES (1, '컴퓨터공학과', '부산시 남구 수영로 309 (대연동) 제 2공학관 308호', 3);
INSERT INTO Department VALUES (2, '전자공학과', '부산시 남구 수영로 309 (대연동) 제 2공학관 309호', 4);
INSERT INTO Department VALUES (3, '산업경영공학과', '부산시 남구 수영로 309 (대연동) 7호관 산업경영공학과', 6);
INSERT INTO Department VALUES (4, '기계자동차공학과', '부산시 남구 수영로 309 (대연동) 7호관 110호', 7);
INSERT INTO Department VALUES (5, '소프트웨어학과', '부산시 남구 수영로 309 (대연동) 8호관 608호', 1);
INSERT INTO Department VALUES (6, '신소재공학과', '부산시 남구 수영로 309 (대연동) 8호관 609호', 8);

-- 교수 --

INSERT INTO Professor VALUES (1, person_info('홍석희','부산시 남구 대연동',phoneno_info('010-1234-5678','051-1323-4567',null)), '부산시 남구 수영로 309 (대연동) 제 2공학관 609호', '데이터베이스', 5);
INSERT INTO Professor VALUES (2, person_info('강인수','부산시 서구 암남동',phoneno_info('010-3331-4144',null,'051-1626-4127')), '부산시 남구 수영로 309 (대연동) 제 2공학관 610호', '알고리즘', 5);
INSERT INTO Professor VALUES (3, person_info('양태천','부산시 북구 동안동',phoneno_info('010-1515-5111','051-7651-5432',null)), '부산시 남구 수영로 309 (대연동) 제 2공학관 611호', '운영체제', 1);
INSERT INTO Professor VALUES (4, person_info('손봉균','부산시 동대구 신병동',phoneno_info('010-2321-2314','051-5444-5555',null)), '부산시 남구 수영로 309 (대연동) 제 2공학관 612호', '전자기학', 2);
INSERT INTO Professor VALUES (5, person_info('지상문','부산시 부산진구 부전동',phoneno_info('010-4646-5775','051-2422-333',null)), '부산시 남구 수영로 309 (대연동) 7호관 613호', '인공지능', 5);
INSERT INTO Professor VALUES (6, person_info('김주현','부산시 남구 경성동',phoneno_info('010-4514-2351',null,null)), '부산시 남구 수영로 309 (대연동) 8호관 614호', '산업학', 3);
INSERT INTO Professor VALUES (7, person_info('김현수','부산시 대구 동대구',phoneno_info('010-2335-6464','051-1243-4567','051-8884-8888')), '부산시 남구 수영로 309 (대연동) 제 2공학관 615호', '기계학', 4);
INSERT INTO Professor VALUES (8, person_info('전지환','부산시 남구 대연동',phoneno_info('010-1677-1515','051-5514-4567',null)), '부산시 남구 수영로 309 (대연동) 제 2공학관 616호', '신소재공학', 6);

-- 입력후 제약 추가 --
ALTER TABLE department
    ADD CONSTRAINT chair_of FOREIGN KEY ( chairman )
        REFERENCES professor ( professorno );

-- 학생 --
insert into student values (2018742029,person_info('이현석','부산시 해운대구 반여동',phoneno_info('010-7755-0542',null,null)),'학부',5,null);
insert into student values (2020100011,person_info('김현수','부산시 남구 개길동',phoneno_info('010-1515-1515','051-5135-4567',null)),'학부',1,null);
insert into student values (2021742031,person_info('김주현','부산시 남구 개시동',phoneno_info('010-1414-1414','051-7346-3434',null)),'학부',5,null);
insert into student values (2018742032,person_info('나인우','부천시 남구 고일동',phoneno_info('010-1313-1313','051-2354-4242',null)),'학부',2,null);
insert into student values (2019742033,person_info('김지은','부산시 남구 고연동',phoneno_info('010-1616-1717','051-6366-6536','051-1264-7465')),'학부',3,5);
insert into student values (2020742034,person_info('권율','부산시 남구 연고동',phoneno_info('010-1881-5151','051-7677-5757',null)),'학부',5,1);
insert into student values (2010742035,person_info('권수현','부산시 남구 연지동',phoneno_info('010-2322-4244',null,'051-1463-6465')),'학부',5,4);
insert into student values (2011742036,person_info('김현아','부산시 북구 대연동',phoneno_info('010-5151-2422',null,'051-9569-5563')),'학부',5,2);
insert into student values (2012742037,person_info('김제인','부산시 남구 대연동',phoneno_info('010-1414-6464','051-2353-3535',null)),'학부',5,3);
insert into student values (2013742038,person_info('김조아','대구시 서구 대연동',phoneno_info('010-8686-5454',null,'051-6631-3333')),'학부',5,4);

-- 조교 --
INSERT INTO assistant VALUES (1, person_info('정부용','부산시 남구 대연동',phoneno_info('010-1515-2344','051-5555-4444',null)), 1);
INSERT INTO assistant VALUES (2, person_info('이기제','부산시 남구 런던동',phoneno_info('010-1521-2888','051-8337-5677',null)), 3);
INSERT INTO assistant VALUES (3, person_info('손흥민','부산시 남구 러시아동',phoneno_info('010-5115-7777','051-6455-4233',null)), 2);
INSERT INTO assistant VALUES (4, person_info('김민재','부산시 남남구 영국동',phoneno_info('010-5566-6767','051-1151-2332',null)), 5);
INSERT INTO assistant VALUES (5, person_info('양민철','부산시 남구 남천동',phoneno_info('010-1111-2244','051-1251-6666',null)), 4);
INSERT INTO assistant VALUES (6, person_info('배수훈','부산시 수영구 광안동',phoneno_info('010-1333-5252','051-7766-5533',null)), 5);

-- 강의 --
INSERT INTO lecture VALUES ('CSE101', '프로그래밍기초', 3, 6, 5);
INSERT INTO lecture VALUES ('CSE201', '자료구조', 3, 4, 5);
INSERT INTO lecture VALUES ('ASS101', '데이터베이스응용', 3, 4, 5);
INSERT INTO lecture VALUES ('ASS102', '파일처리론', 3, 4, 5);
INSERT INTO lecture VALUES ('CSE202', '알고리즘', 3, 1, 1);
INSERT INTO lecture VALUES ('CSE203', '운영체제', 2, 1, 1);
INSERT INTO lecture VALUES ('CSE204', '데이터베이스', 3, 4, 5);
INSERT INTO lecture VALUES ('CSE209', '컴파일러', 1, 2, 3);
INSERT INTO lecture VALUES ('CSE210', '데이터통신', 3, 2, 3);
INSERT INTO lecture VALUES ('ASE101', '전자기학', 2, 3, 2);
INSERT INTO lecture VALUES ('ASE201', '전자회로', 2, 3, 2);
INSERT INTO lecture VALUES ('ASE202', '디지털회로', 1, 5, 4);
INSERT INTO lecture VALUES ('ASE203', '신호및시스템', 3, 5, 4);

-- 강의시간 --
INSERT INTO lecturetime VALUES ('월', 1);
INSERT INTO lecturetime VALUES ('월', 2);
INSERT INTO lecturetime VALUES ('월', 3);
INSERT INTO lecturetime VALUES ('월', 4);
INSERT INTO lecturetime VALUES ('월', 5);
INSERT INTO lecturetime VALUES ('월', 6);
INSERT INTO lecturetime VALUES ('월', 7);
INSERT INTO lecturetime VALUES ('월', 8);
INSERT INTO lecturetime VALUES ('월', 9);
INSERT INTO lecturetime VALUES ('월', 10);
INSERT INTO lecturetime VALUES ('화', 1);
INSERT INTO lecturetime VALUES ('화', 2);
INSERT INTO lecturetime VALUES ('화', 3);
INSERT INTO lecturetime VALUES ('화', 4);
INSERT INTO lecturetime VALUES ('화', 5);
INSERT INTO lecturetime VALUES ('화', 6);
INSERT INTO lecturetime VALUES ('화', 7);
INSERT INTO lecturetime VALUES ('화', 8);
INSERT INTO lecturetime VALUES ('화', 9);
INSERT INTO lecturetime VALUES ('화', 10);
INSERT INTO lecturetime VALUES ('수', 1);
INSERT INTO lecturetime VALUES ('수', 2);
INSERT INTO lecturetime VALUES ('수', 3);
INSERT INTO lecturetime VALUES ('수', 4);
INSERT INTO lecturetime VALUES ('수', 5);
INSERT INTO lecturetime VALUES ('수', 6);
INSERT INTO lecturetime VALUES ('수', 7);
INSERT INTO lecturetime VALUES ('수', 8);
INSERT INTO lecturetime VALUES ('수', 9);
INSERT INTO lecturetime VALUES ('수', 10);
INSERT INTO lecturetime VALUES ('목', 1);
INSERT INTO lecturetime VALUES ('목', 2);
INSERT INTO lecturetime VALUES ('목', 3);
INSERT INTO lecturetime VALUES ('목', 4);
INSERT INTO lecturetime VALUES ('목', 5);
INSERT INTO lecturetime VALUES ('목', 6);
INSERT INTO lecturetime VALUES ('목', 7);
INSERT INTO lecturetime VALUES ('목', 8);
INSERT INTO lecturetime VALUES ('목', 9);
INSERT INTO lecturetime VALUES ('목', 10);
INSERT INTO lecturetime VALUES ('금', 1);
INSERT INTO lecturetime VALUES ('금', 2);
INSERT INTO lecturetime VALUES ('금', 3);
INSERT INTO lecturetime VALUES ('금', 4);
INSERT INTO lecturetime VALUES ('금', 5);
INSERT INTO lecturetime VALUES ('금', 6);
INSERT INTO lecturetime VALUES ('금', 7);
INSERT INTO lecturetime VALUES ('금', 8);
INSERT INTO lecturetime VALUES ('금', 9);
INSERT INTO lecturetime VALUES ('금', 10);

-- lecture_schedule --
INSERT INTO lecture_schedule VALUES ('CSE101',1, '월');
INSERT INTO lecture_schedule VALUES ('CSE101',2, '월');
INSERT INTO lecture_schedule VALUES ('CSE101',3, '월');
INSERT INTO lecture_schedule VALUES ('CSE204',9, '화');
INSERT INTO lecture_schedule VALUES ('CSE204',10, '화');
INSERT INTO lecture_schedule VALUES ('CSE204',9, '수');
INSERT INTO lecture_schedule VALUES ('CSE204',10, '목');
INSERT INTO lecture_schedule VALUES ('CSE210',1, '목');
INSERT INTO lecture_schedule VALUES ('CSE210',2, '목');
INSERT INTO lecture_schedule VALUES ('CSE210',3, '목');
INSERT INTO lecture_schedule VALUES ('ASE101',6, '금');
INSERT INTO lecture_schedule VALUES ('ASE101',7, '금');
INSERT INTO lecture_schedule VALUES ('ASE101',8, '금');
INSERT INTO lecture_schedule VALUES ('ASS101',6, '수');
INSERT INTO lecture_schedule VALUES ('ASS101',7, '수');
INSERT INTO lecture_schedule VALUES ('ASS101',8, '수');
INSERT INTO lecture_schedule VALUES ('ASS102',6, '월');
INSERT INTO lecture_schedule VALUES ('ASS102',7, '월');
INSERT INTO lecture_schedule VALUES ('ASS102',8, '월');

-- lectureroom --
INSERT INTO lectureroom VALUES ('제 2공학관', 101, 1, 100);
INSERT INTO lectureroom VALUES ('제 2공학관', 102, 1, 100);
INSERT INTO lectureroom VALUES ('제 2공학관', 103, 1, 100);
INSERT INTO lectureroom VALUES ('제 2공학관', 104, 1, 100);
INSERT INTO lectureroom VALUES ('8호관', 626, 6, 40);
INSERT INTO lectureroom VALUES ('8호관', 627, 6, 37);
INSERT INTO lectureroom VALUES ('8호관', 628, 6, 60);
INSERT INTO lectureroom VALUES ('7호관', 529, 5, 10);
INSERT INTO lectureroom VALUES ('7호관', 304, 4, 30);

-- classlocation --
INSERT INTO classlocation VALUES ('CSE204','제 2공학관', 101);
INSERT INTO classlocation VALUES ('ASS101','제 2공학관', 102);
INSERT INTO classlocation VALUES ('ASS102','제 2공학관', 103);
INSERT INTO classlocation VALUES ('CSE101','8호관', 626);
INSERT INTO classlocation VALUES ('CSE210','8호관', 627);
INSERT INTO classlocation VALUES ('ASE101','7호관', 529);
INSERT INTO classlocation VALUES ('CSE203','7호관', 304);

-- takingLectures --
INSERT INTO takingLectures VALUES ('CSE210',2018742029);
INSERT INTO takingLectures VALUES ('CSE204',2020100011);
INSERT INTO takingLectures VALUES ('CSE204',2021742031);
INSERT INTO takingLectures VALUES ('CSE204',2018742032);
INSERT INTO takingLectures VALUES ('ASS101',2019742033);
INSERT INTO takingLectures VALUES ('CSE101',2020742034);
INSERT INTO takingLectures VALUES ('CSE101',2010742035);
INSERT INTO takingLectures VALUES ('CSE101',2011742036);
INSERT INTO takingLectures VALUES ('CSE210',2012742037);
INSERT INTO takingLectures VALUES ('CSE210',2013742038);
INSERT INTO takingLectures VALUES ('ASS101',2018742029);
INSERT INTO takingLectures VALUES ('ASS101',2020100011);
INSERT INTO takingLectures VALUES ('ASS102',2020100011);
INSERT INTO takingLectures VALUES ('ASS102',2018742029);
INSERT INTO takingLectures VALUES ('ASE101',2021742031);
INSERT INTO takingLectures VALUES ('ASE101',2018742032);
INSERT INTO takingLectures VALUES ('ASE101',2019742033);
INSERT INTO takingLectures VALUES ('CSE203',2020742034);
INSERT INTO takingLectures VALUES ('CSE203',2010742035);
INSERT INTO takingLectures VALUES ('CSE203',2011742036);

-- lecture_of --
INSERT INTO lecture_of VALUES (1, 'CSE204');
INSERT INTO lecture_of VALUES (2, 'CSE204');
INSERT INTO lecture_of VALUES (3, 'CSE101');
INSERT INTO lecture_of VALUES (4, 'ASE202');
INSERT INTO lecture_of VALUES (5, 'CSE101');
INSERT INTO lecture_of VALUES (6, 'ASE101');
INSERT INTO lecture_of VALUES (7, 'CSE203');
INSERT INTO lecture_of VALUES (1, 'ASS101');
INSERT INTO lecture_of VALUES (1, 'ASS102');
