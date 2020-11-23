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

create type tecnica as enum ('carreras planas', 'carreras de campo', 'tiro', 'salto');

--
create or replace function tgr_Tipo_carrera_Caballo()
returns trigger as
    $func$
    begin
        if exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and (new.tipo_carrera ='400m pista' or new.tipo_carrera = '2km pista'))  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Pura Sangre' or tipo  = 'Quarter')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera'
            end if;

        else if exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and new.tipo_carrera ='a campo traviesa')  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Pura Sangre' or tipo  = 'Appaloosa')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera'
            end if;

        else if exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and new.tipo_carrera = 'carrera con obstáculos')  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Árabe' or tipo  = 'Appaloosa')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera'
            end if;

         else if exists (Select tipo_carrera from carrera where new.en_carrera = num_carrera  and new.tipo_carrera = 'tiro-de-carro')  then
            if not exists (select tipo FROM  caballo where new.un_caballo = registro and (tipo = 'Árabe' or tipo  = 'Quarter')) then
                RAISE exception  'La técnica del caballo no es adecuada para la carrera'
            end if;

        end if;
        return new;
    end;
    $func$ language plpgsql;

create trigger insert_CarreraCorr_caballo
    before insert or update of un_caballo
    on arranque
    for each row execute procedure tgr_Tipo_carrera_Caballo()
--La información de los tipos de caballo debe ser consistente con la técnica de su entrenador y con el tipo de carrera en el
--que participa. Es decir un caballo que participa en alguna modalidad de carrera debe tener un entrenador que domina
--esa técnica


--pura sangre: planas y campo
--quarter : plana y tiro 'carreras planas' 'tiro'
--árabe: tiro y salto 'tiro' 'salto'
--appalosa: salto ycampo 'tiro' 'carreras de campo'

--Los valores posibles en las técnicas de entrenamiento son: carreras planas (400m y 2km), de campo (campo traviesa), tiro
--(tiro-de-carro) y salto (carrera de obstáculos). Note que los entrenadores pueden dominar más de una técnica.
--Los tipos de caballo que se tienen registrados en la base de datos son Pura Sangre (400m, 2km, campo traviesa), Quarter
--(400m, 2km, tiro-de-carro), Árabe (tiro-de-carro, carrera con obstáculos) y Appaloosa (carrera de obstáculos y campo
--traviesa)

-- 440 y 2 'Pura Sangre' 'Quarter'
--'a campo traviesa' 'Pura Sangre' 'Appaloosa'
--'carrera con obstáculos' 'Appaloosa' 'Árabe'
-- 'tiro-de-carro'  'Árabe' 'Quarter'



create table caballo (
    registro varchar(30),
    nombre varchar,
    fecha_nacimiento date,
    genero char,
    tipo tipo_caballo,
    entrenado_por varchar(13),
    en_carrera int[][],
    primary key (registro)
    --foreign key (entrenado_por) references entrenador(rfc)
);


create table entrenador (
    anios_experiencia int,
    tecnica_entrena tecnica[],
    entrena varchar[] -- deben ser referencias a caballos
) inherits (persona);

create table carrera (
  num_carrera int,
  bolsa_premio numeric,
  fecha date,
  tipo_carrera tipo_carrera,
  posiciones int[], -- referencias a arranques
  primary key (num_carrera)
);

create table arranque (
  en_carrera int,
  posicion_inicio int,
  posicion_final int,
  color varchar(10),
  un_caballo varchar,
  un_jinete varchar(13),
  primary key (en_carrera, posicion_inicio),
  foreign key (en_carrera) references carrera(num_carrera),
  foreign key (un_caballo) references caballo(registro)
  --foreign key (un_jinete) references jockey(rfc)
);