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



create or replace function tgr_posicionFinal()
returns trigger as
    $func$
    declare
        bolsa numeric := (select bolsa_premio from carrera where num_carrera = new.en_carrera);
    begin
        if (new.posicion_final = 1) then
            -- actualizar jockey
            update jockey
            set salario = salario + (bolsa * 0.1)
            where rfc = new.un_jinete;
            -- actualizar entrenador
            update entrenador
            set salario = salario + (bolsa * 0.1)
            where (rfc = (select entrenado_por from caballo where registro = new.un_caballo));
            --where (new.un_caballo = any (entrena));
            -- actualizar duenio
            update duenio
            set ganancias = ganancias + (bolsa * 0.8 * (select (porcentaje / 100) from propiedad where registrocaballo = new.un_caballo and rfcduenio = rfc))
            where rfc = (select rfcduenio from propiedad where registrocaballo = new.un_caballo);
        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_posicion_final_arranque on arranque;

create trigger insert_posicion_final_arranque
    before insert or update of posicion_final
    on arranque
    for each row execute procedure tgr_posicionFinal();



------------------------------------------------------------------------

create or replace function tgr_en_carrera()
returns trigger as
    $func$
    begin
        update caballo
            set en_carrera = array_append(en_carrera, cast (row ( new.en_carrera, new.posicion_inicio ) as En_carrera))  -- Agrega la referencia a Propiedad al arreglo
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
            set arranques = array_append(arranques, cast (row ( new.en_carrera, new.posicion_inicio ) as Arranques))  -- Agrega la referencia a Propiedad al arreglo
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


-- trigger para revisar que al insertar un entrenador a caballo este tenga una técnica correspondiente al tipo de caballo
-- ya funciona

create or replace function tgr_checkTecnicaCaballo()
returns trigger as
    $func$
    begin
        if new.entrenado_por is null then
            return new;
        end if;
        if new.tipo ='Pura Sangre' then
            if not exists (select tecnica_entrena FROM  entrenador where rfc=new.entrenado_por and tecnica_entrena  && '{"carreras de campo" , "carreras planas"}')then
                RAISE exception  'La técnica del caballo no es dominada por el entrenador';
            end if;

        elseif (new.tipo = 'Quarter')  then
            if not exists (select tecnica_entrena FROM  entrenador where rfc=new.entrenado_por and tecnica_entrena  && '{"carreras planas","tiro"}') then
                RAISE exception  'La técnica del caballo no es dominada por el entrenador';
            end if;

        elseif (new.tipo = 'Árabe')  then
            if not exists (select tecnica_entrena FROM  entrenador where rfc=new.entrenado_por and tecnica_entrena && '{"tiro", "salto"}') then
                RAISE exception  'La técnica del caballo no es dominada por el entrenador';
            end if;

        elseif new.tipo = 'Appaloosa' then
             if not exists (select tecnica_entrena FROM  entrenador where rfc=new.entrenado_por and tecnica_entrena && '{"salto" , "carreras de campo"}') then
                RAISE exception  'La técnica del caballo no es dominada por el entrenador';
            end if;

        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_Tecnica_caballo on caballo;

create trigger insert_Tecnica_caballo
    before insert or update of tipo
    on caballo
    for each row execute procedure tgr_checkTecnicaCaballo();



--trigger para revisar que al insertar un caballo a un arranque, el caballo debe tener un entrenador que domine la técnica
create or replace function tgr_Tipo_carrera_Caballo()
returns trigger as
    $func$
    begin
        if exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and (tipo_carrera ='400m pista' or tipo_carrera = '2km pista'))  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Pura Sangre' or tipo  = 'Quarter')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera';
            end if;

        elseif exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and tipo_carrera ='a campo traviesa')  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Pura Sangre' or tipo  = 'Appaloosa')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera';
            end if;

        elseif exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and tipo_carrera = 'carrera con obstáculos')  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Árabe' or tipo  = 'Appaloosa')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera';
            end if;

         elseif exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and tipo_carrera = 'tiro-de-carro')  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Árabe' or tipo  = 'Quarter')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera';
            end if;

        end if;
        return new;
    end;
    $func$ language plpgsql;

drop trigger insert_CarreraCorr_caballo on arranque;

create trigger insert_CarreraCorr_caballo
    before insert or update of un_caballo
    on arranque
    for each row execute procedure tgr_Tipo_carrera_Caballo();




