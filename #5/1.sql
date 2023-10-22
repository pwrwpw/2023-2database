DECLARE
    CURSOR csr_pro IS 
        SELECT *
        FROM movieexec me
        ORDER BY me.name;

    CURSOR csr_pres(mn movieexec.name%type) IS 
        SELECT s.name
        FROM movieexec me, studio s
        WHERE me.certNo = s.presNo
        AND me.name = mn
        ORDER BY me.name asc;

    v_me movieexec%ROWTYPE;
    v_st VARCHAR2(100);
    i integer := 1;
    s studio%ROWTYPE;

BEGIN
    open csr_pro;
    loop
        fetch csr_pro into v_me;
        exit when csr_pro%notfound;
        v_st := NULL;
        open csr_pres(v_me.name);
        LOOP
            FETCH csr_pres INTO s.name;
            EXIT WHEN csr_pres%notfound;

            IF v_st IS NULL THEN
                v_st := s.name;
            ELSE
                v_st := v_st || ', ' || s.name;
            END IF;
        END LOOP;

        close csr_pres;

        IF v_st IS NULL THEN
            v_st := '영화사를 운영하지 않는다.';
        ELSE
            v_st := v_st || '을 운영한다.';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
        RPAD(('[' || i || ']'||' 제작자 ' || v_me.name || '는 '||v_st),200));
        i := i + 1;
    end loop;
    close csr_pro; 
END;
