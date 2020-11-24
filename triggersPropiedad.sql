-- Función para el trigger insert_propiedad_es_duenio
create or replace function tgr_esDuenio()
returns trigger as
    $func$
    begin
        update duenio
            set es_duenio = es_duenio || cast (row ( new.registrocaballo, new.rfcduenio ) as Es_duenio) -- Agrega la referencia a Propiedad al arreglo
            where rfc = new.rfcduenio;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_propiedad_es_duenio on propiedad;

-- Trigger que actualiza el array es_duenio de dueño cuando se agrega una Propiedad donde él es el dueño
create trigger insert_propiedad_es_duenio
    before insert or update of rfcduenio
    on propiedad
    for each row execute procedure tgr_esDuenio();




-- Función para el trigger insert_propiedad_propiedad_de
create or replace function tgr_propiedadDe()
returns trigger as
    $func$
    begin
        update caballo
            set propiedad_de = array_append(propiedad_de, cast (row ( new.registrocaballo, new.rfcduenio ) as Propiedad_de))  -- Agrega la referencia a Propiedad al arreglo
            where registro = new.registrocaballo;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_propiedad_propiedad_de on propiedad;

-- Trigger que actualiza el array propiedad_de de propiedad cuando se agrega una Propiedad donde el caballo tiene dueño
create trigger insert_propiedad_propiedad_de
    before insert or update of registrocaballo
    on propiedad
    for each row execute procedure tgr_propiedadDe();
