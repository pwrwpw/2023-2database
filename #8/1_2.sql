create or replace trigger MovieExec_Insert
before insert on movieexec
for each row
declare

begin
    if :new.certno is null then
        select max(certno) into :new.certno from movieexec order by certno desc;
        :new.certno := :new.certno + 1;
    end if;
    
    if :new.name is null then
        :new.name := 'DUMMY|'||:new.certno;
    end if;
    
    if :new.address is null then
        select address into :new.address
        from (select address
              from moviestar
              where gender = 'male'
              order by dbms_random.value)
              where rownum = 1;
    end if;
    
    if :new.networth is null then
        select networth into :new.networth
        from movieexec
        where certno = (select producerno
                        from (select producerno
                              from movie
                              group by producerno
                              having count(*)= (select min(cnt) from(select count(*) as cnt
                                                                     from movie
                                                                     group by producerno))
                                                                     order by dbms_random.value)
                        where rownum = 1);
    end if;
end;