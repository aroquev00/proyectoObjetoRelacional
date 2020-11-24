-- Check entrenador
create or replace function tgr_checkEntrenador()
returns trigger as
    $func$
    begin
        if (new.rfc in (select rfc from persona)) then
            RAISE exception 'El RFC del entrenador debe ser único';
        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger check_entrenador on entrenador;

create trigger check_entrenador
    before insert or update of rfc
    on entrenador
    for each row execute procedure tgr_checkEntrenador();

-- Check duenio
create or replace function tgr_checkDuenio()
returns trigger as
    $func$
    begin
        if (new.rfc in (select rfc from persona)) then
            RAISE exception 'El RFC del dueño debe ser único';
        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger check_duenio on duenio;

create trigger check_duenio
    before insert or update of rfc
    on duenio
    for each row execute procedure tgr_checkDuenio();

-- Check jockey
create or replace function tgr_checkJockey()
returns trigger as
    $func$
    begin
        if (new.rfc in (select rfc from persona)) then
            RAISE exception 'El RFC del jockey debe ser único';
        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger check_jockey on jockey;

create trigger check_jockey
    before insert or update of rfc
    on jockey
    for each row execute procedure tgr_checkJockey();
