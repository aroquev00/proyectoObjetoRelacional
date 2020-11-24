delete from propiedad;

delete from caballo;

delete from duenio;


insert into caballo(registro, nombre, fecha_nacimiento, genero, tipo, entrenado_por, en_carrera, propiedad_de) values ('caballo1', 'Pharaoh', null, 'H', 'Quarter', null, null, '{}');

insert into duenio(rfc, nombre, sexo, direccion, telefono, ganancias, es_duenio) values ('arv', 'armando', 'M', 'mty', '8181', 0, '{}');

insert into propiedad(porcentaje, cantidad, registrocaballo, rfcduenio) VALUES (100, 1000, 'caballo1', 'arv');

