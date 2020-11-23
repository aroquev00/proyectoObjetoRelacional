create or replace function tgr_checkEntrena()
returns trigger as
    $func$
    begin
        if ((not exists (select registro from caballo)) or (not (new.entrena <@ (select array_agg(registro) from caballo)))) then
            RAISE exception 'entrena debe contener llaves foraneas de caballo';
        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_caballo_entrenado on entrenador;

create trigger insert_caballo_entrenado
    before insert or update of entrena
    on entrenador
    for each row execute procedure tgr_checkEntrena();
