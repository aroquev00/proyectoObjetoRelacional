
------------------------------------------------------------------------

create or replace function tgr_en_carrera()
returns trigger as
    $func$
    begin
        update caballo
            set en_carrera = array_append(en_carrera, cast (row ( new.num_carrera, new.posicion_inicio ) as En_carrera))  -- Agrega la referencia a Propiedad al arreglo
            where registro = new.un_caballo;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_arranque_en_carrera on arranque;


-- Trigger que actualiza el array
create trigger insert_arranque_en_carrera
    before insert or update of un_caballo
    on arranque
    for each row execute procedure tgr_en_carrera();

---------------------------------------------------------------------------

create or replace function tgr_arranques()
returns trigger as
    $func$
    begin
        update jockey
            set arranques = array_append(arranques, cast (row ( new.num_carrera, new.posicion_inicio ) as Arranques))  -- Agrega la referencia a Propiedad al arreglo
            where rfc = new.un_jinete;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_arranque_arranques on arranque;


-- Trigger que actualiza el array
create trigger insert_arranque_arranques
    before insert or update of un_jinete
    on arranque
    for each row execute procedure tgr_arranques(); 