create or replace function tgr_checkEntrena()
returns trigger as
    $func$
    begin
        --if (not (5 = 4)) then
        if (((select array_agg(registro) from caballo) is null) or (not (new.entrena <@ (select array_agg(registro) from caballo)))) then
            return null;
        end if;
        return new;
    end;
    $func$ language plpgsql;

create trigger insert_entrenado
    before insert
    on entrenador
    for each row execute procedure tgr_checkEntrena();

    --when (!(new.entrena @> (select registro from caballo)))
    --execute procedure stuff_inserting();




