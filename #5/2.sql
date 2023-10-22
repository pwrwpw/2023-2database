DECLARE
    CURSOR csr_ms IS
        SELECT *
        FROM MOVIESTAR
        WHERE NAME IN (SELECT STARNAME
                    FROM STARSIN)
        ORDER BY NAME ASC;

    CURSOR csr_s(sn STARSIN.STARNAME%TYPE) IS
        SELECT *
        FROM STARSIN
        WHERE STARNAME = sn
        ORDER BY STARNAME, MOVIEYEAR;
    v_ms MOVIESTAR%ROWTYPE;
    v_m STARSIN%ROWTYPE;
    actor_count integer := 0;
    movie_count integer := 0;
BEGIN
    OPEN csr_ms;
    LOOP
        FETCH csr_ms INTO v_ms;
        EXIT WHEN csr_ms%NOTFOUND;
        actor_count := actor_count + 1;

        DBMS_OUTPUT.PUT('[' || actor_count || '] ' || v_ms.NAME || ' : ');
        movie_count := 0;
        OPEN csr_s(v_ms.NAME);
        LOOP
            FETCH csr_s INTO v_m;
            EXIT WHEN csr_s%NOTFOUND;
            IF movie_count > 0 THEN
                DBMS_OUTPUT.PUT(',');
            END IF;
            DBMS_OUTPUT.PUT(v_m.MOVIETITLE || '(' || v_m.MOVIEYEAR || '년)');
            movie_count := movie_count + 1;
        END LOOP;
        CLOSE csr_s;
        IF movie_count = 1 THEN
            DBMS_OUTPUT.PUT_LINE(movie_count||'편 출연');
        ELSE
            DBMS_OUTPUT.PUT_LINE('등의 '||movie_count||'편에 출연');
        END IF;
    END LOOP;
    CLOSE csr_ms;
END;
