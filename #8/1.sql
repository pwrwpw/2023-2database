create or replace trigger MovieProd_Insert
instead of insert or update on movieprod
for each row
declare
    p_no movieexec.certno%type;
    cnt integer;
begin
    select count(*) into cnt from movie
    where title = :new.title and year = :new.year;
    
    if cnt = 0 then
        insert into movie(title,year) values (:new.title,:new.year);
    end if;
    
    select count(*) into cnt from movieexec
    where name = :new.producer;
    
    if cnt = 0 then
        insert into movieexec(name) values (:new.producer);
    end if;
    
    select certno into p_no
    from movieexec
    where name = :new.producer;
    
    update movie
    set producerno = p_no
    where title = :new.title and year = :new.year;
end;