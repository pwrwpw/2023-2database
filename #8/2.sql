create or replace trigger StarPlays_Trigger
instead of insert on starplays
for each row
declare
    type add_ty is table of moviestar.address%type;

    city add_ty := add_ty('부산광역시','대구광역시','인천광역시','광주광역시','대전광역시','울산광역시','서울특별시','세종특별자치시');
    gu add_ty := add_ty('해운대구','남구','북구','서구','동구','영등포구','도봉구','관악구','강서구');
    dong add_ty := add_ty('반여동','재송동','신림동','대연동','남천동','수영동','거제동');

    gen moviestar.gender%type;
    addr moviestar.address%type;
    birth moviestar.birthdate%type;
    cnt integer;
    max_producerno movie.producerno%type;
begin
    select count(*) into cnt from movie where title = :new.title and year = :new.year;

    if cnt = 0 then
        select producerno into max_producerno
        from (select producerno
              from movie
              group by producerno
              HAVING count(*) = (select max(produce_cnt)
                                 from (select count(*) as produce_cnt from movie group by producerno)
                                 group by producerno)
                                 order by dbms_random.value)
                                 where rownum = 1;
    end if;
    insert into movie(title,year,producerno) values (:new.title,:new.year,max_producerno);

    select count(*) into cnt from moviestar where name = :new.name;

    if cnt = 0 then
        addr := city(trunc(dbms_random.value(1, city.last + 1))) ||' '||
                                                gu(trunc(dbms_random.value(1,gu.last + 1)))||' '||
                                                dong(trunc(dbms_random.value(1,dong.last + 1)))||' '||
                                                trunc(dbms_random.value(1,2000))||'번지'||'-'||
                                                trunc(dbms_random.value(1,20));
        birth := to_date('1970-01-01') + dbms_random.value(1, 53 * 365);
        select gender into gen 
        from (select gender
              from moviestar
              where birthdate = (select max(birthdate)
                                 from moviestar)
                                 order by dbms_random.value)
                                 where rownum = 1;
        insert into moviestar values (:new.name,addr,gen,birth);
    end if;
    insert into starsin(movietitle,movieyear,starname) values (:new.title,:new.year,:new.name);
end;