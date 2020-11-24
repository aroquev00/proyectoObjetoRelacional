
update caballo
set entrenado_por = (select rfc from entrenador where entrenador.nombre = 'Jonas Melton')
where nombre = 'Phillip';

INSERT INTO arranque (en_carrera,posicion_inicio,posicion_final,color,un_caballo,un_jinete) VALUES
 (87,1,1,'rojo','ZMQMZ18279OGGRY','XCM307574AXA');--

select d.ganancias as gananciasDuenio, e.salario as salarioEntrenador, j.salario as salarioJockey
from arranque a
join caballo c on c.registro = a.un_caballo
join jockey j on j.rfc = a.un_jinete
join entrenador e on e.rfc = c.entrenado_por
join propiedad p on c.registro = p.registrocaballo
join duenio d on p.rfcduenio = d.rfc
where a.un_caballo = (select c2.registro from caballo c2 where c2.nombre = 'Philip');


select ganancias as gananciasDuenio
from duenio
where rfc = 'WHY482297VVM';

select salario as salarioEntrenador
from entrenador
where rfc = 'WOH808818WEK';

select salario as salarioJockey
from jockey
where rfc = 'XCM307574AXA';

INSERT INTO arranque (en_carrera,posicion_inicio,posicion_final,color,un_caballo,un_jinete) VALUES
 (96,1,1,'rojo','ZMQMZ18279OGGRY','XCM307574AXA');--

select c.en_carrera
from caballo c
where nombre = 'Phillip';

select j.arranques
from jockey j
where j.nombre = 'Brock Trevino';

delete from jockey where nombre = 'Some Jockey';

insert into jockey values
('WZH014239ZLX','Some Jockey','M','331-7732 Id Rd.','901-355-0814',168,45,17,13162,'{}');
