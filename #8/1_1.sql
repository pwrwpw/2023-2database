create or replace trigger Movie_Insert
before insert on movie
for each row
declare

begin
    if :new.length is null then
        select avg(length) into :new.length from movie;
    end if;
    
    if :new.incolor is null then
        select incolor into :new.incolor from movie where incolor = 't' and rownum = 1;
    end if;
    
    if :new.studioname is null then
        select studioname into :new.studioname
            from (select studioname
                  from (select studioname
                               from movie
                               group by studioname
                               having count(*) =  (select min(cnt) from(select count(*) as cnt
                                                   from movie
                                                   group by studioname))
                                                   order by dbms_random.value)
                                                   where rownum = 1);
    end if;
    
    if :new.producerno is null then
        select certno into :new.producerno
        from (select *
              from movieexec
              order by dbms_random.value)
              where rownum = 1;
    end if;
end;