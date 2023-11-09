create or replace TRIGGER Exec_Update
before update on movieexec
for each row
declare
    avg_networth movieexec.networth%type;
    cnt_pres integer;
    cnt_prod integer;
    cnt_star integer;
    n_pres movieexec.certno%type;
    max_networth movieexec.networth%type;
    pragma autonomous_transaction;
begin
    select count(presno) into cnt_pres
    from studio
    where :new.certno = presno;
    
    select count(producerno) into cnt_prod
    from movie
    where :new.certno = producerno;
    
    select avg(networth) into avg_networth
    from movieexec;
    
    select count(starname) into cnt_star
    from starsin
    where starname = :new.name;

    select presno into n_pres
    from (select presno from studio order by dbms_random.value)
    where rownum = 1;
    if cnt_pres > 0 or cnt_prod > 0 then
        :new.name := :old.name;
        dbms_output.put_line(' MOVIEEXEC 튜플이 사장 또는 영화제작자 입니다 !!');
    else
        if :new.networth > avg_networth then
            update studio
            set presno = :new.certno
            where presno = n_pres;
            commit;
        end if;
    end if;
    if :new.networth is null then
        select max(networth) into max_networth
        from movieexec;
        :new.networth := max_networth;
    end if;
    if cnt_star > 0 then
        :new.address := '['|| :old.address || ']' ||'에 배우가 삽니다!';
    end if;
end;