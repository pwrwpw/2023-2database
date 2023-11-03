DECLARE
    cnt INTEGER;
    sql_e VARCHAR2(200) := 'INSERT INTO StudioInfo VALUES (:1, :2, :3, movie_tab(), star_tab())';
    sql_m VARCHAR2(200) := 'INSERT INTO TABLE (SELECT MOVIES FROM StudioInfo WHERE NAME = :1) VALUES (mv_ty(:2, :3, :4, :5))';
    sql_s VARCHAR2(200) := 'INSERT INTO TABLE (SELECT STARS FROM StudioInfo WHERE NAME = :1) VALUES (star_ty(:6, :7, :8))';
    
    CURSOR me_csr(pres studio.presno%TYPE) IS
        SELECT * FROM movieexec WHERE pres = certno;
    
    CURSOR m_csr(sname studio.name%TYPE) IS
        SELECT * FROM MOVIE WHERE sname = studioname;
    
    CURSOR pro_csr(proNo movie.producerno%TYPE) IS
        SELECT name FROM movieexec WHERE certNo = proNo;
    
    CURSOR st_csr IS
        SELECT name AS sname, ROWNUM AS r
        FROM (
            SELECT m.*, ROWNUM r
            FROM (
                SELECT *
                FROM moviestar m
                ORDER BY DBMS_RANDOM.VALUE
            ) m
            WHERE ROWNUM <= TRUNC(DBMS_RANDOM.VALUE(0, cnt / 3))
        );
begin
    for s in (select * from studio) LOOP
        select count(*) into cnt
        from moviestar;
        
        for me in me_csr(s.presno) loop
            execute immediate sql_e using s.name, s.address, me.name;
        END LOOP;
        for m in m_csr(s.name) loop
            for p in pro_csr(m.producerNo) loop
                execute immediate sql_m using s.name, m.title, m.year,
                trunc(dbms_random.value(10000,999999999)), p.name;
            END LOOP;
        END LOOP;
        for st in st_csr loop
            execute immediate sql_s using s.name,st.sname,
                trunc(dbms_random.value(10000,999999)),trunc(dbms_random.value(1,10));
        END LOOP;
    END LOOP;
end;