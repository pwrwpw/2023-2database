create or replace Trigger Star_Insert
before insert on moviestar
for each row
declare
    addr moviestar.address%type;
    birth moviestar.birthdate%type;
    gen moviestar.gender%type;
    cnt_f integer;
    cnt_m integer;
begin
    select address into addr from (select * from moviestar order by dbms_random.value) where rownum = 1;
    if :new.address is null then
        :new.address := addr;
    end if;
    select birthdate into birth from (select * from moviestar order by dbms_random.value) where rownum = 1;
    if :new.birthdate is null then
        :new.birthdate := birth;
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