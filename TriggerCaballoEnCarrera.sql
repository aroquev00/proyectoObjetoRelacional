--trigger para agregar un caballo al entrenador cuando se le asigne a un caballo ese entrenador
create or replace function tgr_addcaballo_entrenador()
returns trigger as
   $func$
    begin
        update entrenador
        SET entrena = array_append(entrena, new.registro)
        where new.entrenado_por= entrenador.rfc;
        return new;
    end;
    $func$ language plpgsql;

drop trigger caballo_entrenador on caballo;

create trigger caballo_entrenador
    before insert or update of  entrenado_por
    on caballo
    for each row execute procedure tgr_addcaballo_entrenador();

--Trigger que inserta una posición nueva al array posiciones en carrera cuando se crea una

create or replace function tgr_addpos_carrera()
returns trigger as
   $func$
    begin
        update carrera
        SET posiciones = array_append(posiciones, new.posicion_inicio)
        where new.en_carrera=carrera.num_carrera;
        return new;
    end;
    $func$ language plpgsql;

drop trigger Carrera_posiciones on arranque;

create trigger Carrera_posiciones
    before insert or update of posicion_inicio
    on arranque
    for each row execute procedure tgr_addpos_carrera();


