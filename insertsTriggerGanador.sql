


insert into caballo values ('caballo1', 'Pharaoh', null, 'H', 'Quarter', null, null, null);

insert into entrenador(rfc, nombre, sexo, direccion, telefono, anios_experiencia, tecnica_entrena, salario, entrena) values ('abc', 'armando', 'M', 'mi casa', '818181', 1, null, 0, '{"caballo1"}');

insert into duenio(rfc, nombre, sexo, direccion, telefono, ganancias, es_duenio) values ('arv', 'armando', 'M', 'mty', '8181', 0, null);

insert into propiedad(porcentaje, cantidad, registrocaballo, rfcduenio) VALUES (100, 1000, 'caballo1', 'arv');


update caballo
set entrenado_por = 'abc',
propiedad_de = ARRAY[cast (row ( 'caballo1', 'arv' ) as Propiedad_de)]
where registro = 'caballo1';

insert into carrera values (1, 100, null, '400m pista', null);
insert into carrera values (2, 1000, null, '400m pista', null);

insert into arranque values (2, 3, 1, 'rojo', 'caballo1', 'jinete1');

insert into persona values ('abc', null, null,null, null);