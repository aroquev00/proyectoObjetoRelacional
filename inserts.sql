


insert into caballo values ('caballo1', 'Pharaoh', null, 'H', 'Quarter');

insert into entrenador(rfc, nombre, sexo, direccion, telefono, anios_experiencia, tecnica_entrena, entrena) values ('abc', 'armando', 'M', 'mi casa', '818181', 1, null, '{"caballo2"}'); -- este avienta error
insert into entrenador(rfc, nombre, sexo, direccion, telefono, anios_experiencia, tecnica_entrena, entrena) values ('abc', 'armando', 'M', 'mi casa', '818181', 1, null, '{"caballo1"}'); -- este si pasa

