create type tipo_carrera as enum ('400m pista', '2km pista', 'a campo traviesa', 'carrera con obstáculos', 'tiro-de-carro');

create type tipo_caballo as enum ('Pura Sangre', 'Quarter', 'Árabe', 'Appaloosa');

create type tecnica as enum ('carreras planas', 'carreras de campo', 'tiro', 'salto');

create table caballo (
    registro varchar(30),
    nombre varchar,
    fecha_nacimiento date,
    genero char,
    tipo tipo_caballo,
    primary key (registro)
);

create table persona
    (rfc varchar(12),
    nombre varchar(50),
    sexo char,
    direccion varchar(100),
    telefono varchar(10),
    primary key (rfc)
    );

create table duenio
    (ganancias numeric) inherits (persona);


create table entrenador
    (anios_experiencia int,
    tecnica_entrena varchar[], -- deben ser referencias a caballo registro
    entrena tecnica[]
    ) inherits (persona);

create table jockey (
    estatura numeric,
    peso numeric,
    edad int,
    salario numeric
) inherits (persona);

create table carrera (
  num_carrera int,
  bolsa_premio numeric,
  fecha date,
  tipo_carrera tipo_carrera,
  primary key (num_carrera)
);

create table arranque (
  num_carrera int,
  posicion_inicio int,
  posicion_final int,
  color varchar(10),
  primary key (num_carrera, posicion_inicio),
  foreign key (num_carrera) references carrera(num_carrera)
);

