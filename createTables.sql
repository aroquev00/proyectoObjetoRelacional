create type tipo_carrera as enum ('400m pista', '2km pista', 'a campo traviesa', 'carrera con obstáculos', 'tiro-de-carro');

create type tipo_caballo as enum ('Pura Sangre', 'Quarter', 'Árabe', 'Appaloosa');

create type tecnica as enum ('carreras planas', 'carreras de campo', 'tiro', 'salto');

create type sexo as enum ('M', 'F');

create table persona(
    rfc varchar(13),
    nombre varchar(50),
    sexo sexo,
    direccion varchar(100),
    telefono varchar(20),
    primary key (rfc)
);

create type Es_duenio as (
    registroCaballo varchar(30),
    rfcDuenio varchar(13)
);

create table duenio (
    ganancias numeric,
    es_duenio Es_duenio[] -- Arreglo de referencias a Propiedades
) inherits (persona);


create table entrenador (
    anios_experiencia int,
    tecnica_entrena tecnica[],
    salario numeric,
    entrena varchar[] -- Arreglo de referencias a Caballos
) inherits (persona);

create type Arranques as (
    num_carrera int,
    posicion_inicio int
);

create table jockey (
    estatura numeric,
    peso numeric,
    edad int,
    salario numeric,
    arranques Arranques[] -- Referencias a arranques
) inherits (persona);

create type Propiedad_de as (
    registroCaballo varchar(30),
    rfcDuenio varchar(13)
);

create type En_carrera as (
    num_carrera int,
    posicion_inicio int
);

create table caballo (
    registro varchar(30),
    nombre varchar,
    fecha_nacimiento date,
    genero char,
    tipo tipo_caballo,
    entrenado_por varchar(13), -- Esto tiene que ser una FK a entrenador
    en_carrera En_carrera[], -- Referencias a arranques
    propiedad_de Propiedad_de[],
    primary key (registro)
);

create table propiedad (
    porcentaje numeric,
    cantidad numeric,
    registroCaballo varchar(30),
    rfcDuenio varchar(13),
    foreign key (registroCaballo) references caballo(registro),
    --foreign key (rfcDuenio) references duenio(rfc),
    primary key (registroCaballo, rfcDuenio)
);

create table carrera (
  num_carrera int,
  bolsa_premio numeric,
  fecha date,
  tipo_carrera tipo_carrera,
  posiciones int[], -- Posicion de inicio
  primary key (num_carrera)
);

create table arranque (
  en_carrera int,
  posicion_inicio int,
  posicion_final int,
  color varchar(10),
  un_caballo varchar,
  un_jinete varchar(13), -- FK de jockey
  primary key (en_carrera, posicion_inicio),
  foreign key (en_carrera) references carrera(num_carrera),
  foreign key (un_caballo) references caballo(registro)
);


