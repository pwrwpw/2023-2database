create or replace procedure Get_StarInfo (star_name in out starsin.starname%type,cnt out integer,avg in out float)
is
begin
    select count(*),avg(length) into cnt,avg 
    from movie,starsin
    where title = movietitle and year = movieyear and starname = star_name
    group by starname;

exception
    when others then
        cnt := -1;
        avg := -1;
end;
