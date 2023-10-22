DECLARE
    TYPE array_t IS record(
        sn studio.name%TYPE,
        sa studio.address%TYPE,
        mn movieexec.name%TYPE,
        ma movieexec.address%TYPE
    );

    TYPE array_tt IS TABLE OF array_t INDEX BY studio.name%TYPE;

    arrays_ty array_tt;

    CURSOR csr IS
        SELECT s.name AS sn, s.address AS sa, me.name AS mn, me.address AS ma
        FROM studio s, movieexec me
        WHERE presno = certno
        order by 1 desc;

    j INTEGER := 1;
BEGIN
    OPEN csr;
    LOOP
        FETCH csr INTO arrays_ty(j).sn, arrays_ty(j).sa, arrays_ty(j).mn, arrays_ty(j).ma;
        EXIT WHEN csr%NOTFOUND;
        j := j + 1;
    END LOOP;
    CLOSE csr;
    DBMS_OUTPUT.PUT_LINE(
        RPAD('순번', 10) ||
        RPAD('영화사', 40) ||
        RPAD('영화사 주소', 55) ||
        RPAD('사장', 20) ||
        RPAD('사장 주소', 50)
    );
    FOR i IN 1 .. j - 1 LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD('[' || i || ']', 5) ||
            RPAD(arrays_ty(i).sn, 30) ||
            RPAD(arrays_ty(i).sa, 60) ||
            RPAD(arrays_ty(i).mn, 20) ||
            RPAD(arrays_ty(i).ma, 50)
        );
    END LOOP;
END;