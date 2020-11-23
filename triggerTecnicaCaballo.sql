-- trigger para revisar que al insertar un entrenador a caballo este tenga una técnica correspondiente al tipo de caballo
-- ya funciona

create or replace function tgr_checkTecnicaCaballo()
returns trigger as
    $func$
    begin
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


create trigger insert_Tecnica_caballo
    before insert or update of tipo
    on caballo
    for each row execute procedure tgr_checkTecnicaCaballo();

drop trigger insert_Tecnica_caballo on caballo;


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

create trigger insert_CarreraCorr_caballo
    before insert or update of un_caballo
    on arranque
    for each row execute procedure tgr_Tipo_carrera_Caballo();


