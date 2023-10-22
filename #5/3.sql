DECLARE
    TYPE ME_TYPE IS TABLE OF MOVIEEXEC%ROWTYPE;
    TYPE ST_TYPE IS TABLE OF STUDIO%ROWTYPE;
    TYPE SI_TYPE IS TABLE OF STARSIN%ROWTYPE;
    TYPE MS_TYPE IS TABLE OF MOVIESTAR%ROWTYPE;
    me ME_TYPE;
    st ST_TYPE;
    si SI_TYPE;
    ms MS_TYPE;
    CURSOR csr_me IS
        SELECT *
        FROM MOVIEEXEC
        ORDER BY NAME ASC;
    CURSOR csr_st(sno MOVIEEXEC.certNo%TYPE) IS
        SELECT *
        FROM STUDIO
        WHERE sno = presNo;
    CURSOR csr_ss(name MOVIEEXEC.name%type) IS
        SELECT *
        FROM STARSIN
        WHERE name = starName
        ORDER BY movieYear ASC;
    CURSOR csr_ms(mename MOVIEEXEC.name%type) IS
        SELECT *
        FROM MOVIESTAR
        WHERE mename = name;
BEGIN
    FOR m IN csr_me LOOP
        OPEN csr_st(m.certNo);
            FETCH csr_st BULK COLLECT INTO st;
        CLOSE csr_st;
        OPEN csr_ss(m.name);
            FETCH csr_ss BULK COLLECT INTO si;
        CLOSE csr_ss;
        OPEN csr_ms(m.name);
            FETCH csr_ms BULK COLLECT INTO ms;
        CLOSE csr_ms;
        DBMS_OUTPUT.PUT_LINE('제작자[' || m.name || ']' || ': ' || '주소[' || m.address || '], ' || '재산[' || m.NETWORTH || ']');
        DBMS_OUTPUT.PUT(LPAD('운영 영화사 : ', 20));
        IF st.COUNT > 0 THEN
            DBMS_OUTPUT.NEW_LINE;
            FOR i IN st.FIRST .. st.LAST LOOP
                DBMS_OUTPUT.PUT_LINE(LPAD('이름[',15) || st(i).name || '],' || '사무실 주소[' || st(i).address || ']');
            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('없음');
        END IF;
        DBMS_OUTPUT.PUT(LPAD('배우 경력 : ', 18));
        IF ms.COUNT > 0 THEN
                if ms(1).gender = 'male' THEN
                    DBMS_OUTPUT.PUT_LINE(
                        '성별[남성], ' || '총 영화편수[' || si.COUNT || '편]'
                    );
                else 
                    DBMS_OUTPUT.PUT_LINE(
                        '성별[여성], ' || '총 영화편수[' || si.COUNT || '편]'
                    );
                END IF;
            FOR j IN si.FIRST .. si.LAST LOOP
                IF j = si.FIRST THEN
                    DBMS_OUTPUT.PUT_LINE(
                        LPAD('최초 출연 영화 : ', 25) || si(j).movieTitle || '[' || si(j).movieYear || ']'
                    );
                END IF;
                IF j = si.LAST THEN
                    DBMS_OUTPUT.PUT_LINE(
                        LPAD('최근 출연 영화 : ', 25) || si(j).movieTitle || '[' || si(j).movieYear || ']'
                    );
                END IF;
                END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('해당 없음.');
            END IF;

    END LOOP;
END;