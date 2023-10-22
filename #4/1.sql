accept sn prompt '배우이름은?'
declare
    sn starsin.starname%type;
    len float;
    cnt Integer;
begin
    select avg(length),count(*) into len,cnt
    from movie,starsin
    where title = movietitle and year = movieyear and starname = lower('&sn')
    group by starname;
    
    dbms_output.put_line('&sn : 출연영화 편수 : ['|| cnt || '], 출연영화의 평균상영시간 : [' || len ||'분]');
    
    exception
    when others then
        dbms_output.put_line('"' || '&sn' || '"' || '배우 이름 검색 실패!!!!');
end;