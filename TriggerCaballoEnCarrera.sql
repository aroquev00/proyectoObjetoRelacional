
--trigger para agregar una nueva carrera al array en_carrera de caballo cuando este se inserta en algún arranque

create or replace function tgr_addEn_carrera()
returns trigger as
   $func$
    begin
        update caballo
        SET en_carrera = array_append(en_carrera, ARRAY[new.en_carrera, new.posicion_inicio])
        where new.un_caballo=caballo.registro;
    end;
    $func$ language plpgsql;


create trigger En_Carrera_Caballo
    before insert or update of  un_caballo
    on arranque
    for each row execute procedure tgr_addEn_carrera();

--Trigger que inserta una posición nueva al array posiciones en carrera cuando se crea una

create or replace function tgr_addpos_carrera()
returns trigger as
   $func$
    begin
        update carrera
        SET posiciones = array_append(posiciones, new.posicion_inicio)
        where new.en_carrera=carrera.num_carrera;
    end;
    $func$ language plpgsql;

create trigger Carrera_posiciones
    before insert or update of posicion_inicio
    on arranque
    for each row execute procedure tgr_addpos_carrera();


