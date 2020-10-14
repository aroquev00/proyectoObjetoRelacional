create type tipo_carrera as enum ('400m pista', '2km pista', 'a campo traviesa', 'carrera con obstáculos', 'tiro-de-carro');

create type tipo_caballo as enum ('Pura Sangre', 'Quarter', 'Árabe', 'Appaloosa');

create type tecnica as enum ('carreras planas', 'carreras de campo', 'tiro', 'salto');

create type sexo as enum ('M', 'F');

create table persona(
    rfc varchar(13),
    nombre varchar(50),
    sexo sexo,
    direccion varchar(100),
    telefono varchar(10),
    primary key (rfc)
);

create table duenio (
    ganancias numeric,
    es_duenio varchar[] -- No se si deberia apuntar a Propiedad o a Caballo Directamente
) inherits (persona);


create table entrenador (
    anios_experiencia int,
    tecnica_entrena tecnica[],
    entrena varchar[] -- deben ser referencias a caballos
) inherits (persona);

create table jockey (
    estatura numeric,
    peso numeric,
    edad int,
    salario numeric,
    arranques int[][] -- deben referencias a arranque
) inherits (persona);

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

create table propiedad (
    duenio varchar(13),
    caballo varchar(30),
    porcentaje numeric,
    cantidad numeric,
    primary key (duenio, caballo),
    --foreign key (duenio) references duenio(rfc),
    foreign key (caballo) references caballo(registro)
);
