DECLARE
    CURSOR S_CSR IS SELECT * FROM studioinfo order by name asc;
    movies studioinfo.movies%type;
    stars studioinfo.stars%type;
BEGIN
    for s in s_csr loop
    dbms_output.put_line('['||s_csr%rowcount||']'||'영화사 이름: '||s.name||' , '||'주소 : '||s.address||' , '||'사장 : '||s.president);
    movies := s.movies;
    if movies.count > 0 then
        for i in movies.first..movies.last loop
            dbms_output.put_line(lpad('-',5)||' 제목:'||rpad(movies(i).title,30)||
                                '('||rpad(movies(i).year,4)||')'||
                                rpad('예산: ',6)||movies(i).budget||'원,'||rpad('제작자: ',8)||movies(i).producer);
        END LOOP;
    else
        dbms_output.put_line('제작한 영화의 정보가 존재하지 않습니다.');
    END IF;
    stars := s.stars;
    if stars.count > 0 then
        for i in stars.first..stars.last loop
            dbms_output.put_line(lpad('-',10)||'소속 배우:'||rpad(stars(i).name,25)||'계약 금액:'||stars(i).salary||'원, '||'계약 기간:'||stars(i).cont_period||'년');
        end loop;
    else
        dbms_output.put_line('소속 영화배우가 존재하지 않습니다.');
    END IF;
    END LOOP;
END;