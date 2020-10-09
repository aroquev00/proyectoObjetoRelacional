create type PersonaUdt as
    (rfc varchar(10));

create table Persona of PersonaUdt;