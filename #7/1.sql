create or replace Trigger Star_Insert
before insert on moviestar
for each row
declare
    type add_ty is table of moviestar.address%type;
    city add_ty := add_ty('부산광역시','대구광역시','인천광역시','광주광역시','대전광역시','울산광역시','서울특별시','세종특별자치시');
    gu add_ty := add_ty('해운대구','남구','북구','서구','동구','영등포구','도봉구','관악구','강서구');
    dong add_ty := add_ty('반여동','재송동','신림동','대연동','남천동','수영동','거제동');
    birth moviestar.birthdate%type;
    gen moviestar.gender%type;
    cnt_f integer;
    cnt_m integer;
begin
    if :new.address is null then
        :new.address := city(trunc(dbms_random.value(1, city.last + 1))) ||' '||
                        gu(trunc(dbms_random.value(1,gu.last + 1)))||' '||
                        dong(trunc(dbms_random.value(1,dong.last + 1)))||' '||
                        trunc(dbms_random.value(1,2000))||'번지'||'-'||
                        trunc(dbms_random.value(1,20));
    end if;
    select birthdate into birth from (select * from moviestar order by dbms_random.value) where rownum = 1;
    if :new.birthdate is null then
        :new.birthdate := to_date('1940-01-01') + dbms_random.value(1, 83 * 365);
    end if;
    select count(gender) into cnt_f from moviestar where gender = 'female' and birthdate > birth;
    select count(gender) into cnt_m from moviestar where gender = 'male' and birthdate > birth;
    select gender into gen from (select gender from moviestar order by dbms_random.value) where rownum = 1;
    if :new.gender is null then
        if cnt_m > cnt_f then
            :new.gender := 'male';
        elsif cnt_m = cnt_f then
            :new.gender := gen;
        else
            :new.gender := 'female';
        end if;
    end if;
end;