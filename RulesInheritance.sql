
DROP RULE "Check_entrenador" On entrenador;
DROP RULE "Check_persona" On persona;

CREATE RULE "Check_persona" AS
    ON INSERT TO persona
    WHERE new.rfc in (Select rfc FROM persona)
    DO INSTEAD
    Nothing;

CREATE RULE "Check_entrenador" AS
    ON INSERT TO entrenador
    WHERE new.rfc in (Select rfc FROM persona)
    DO INSTEAD
    Nothing;

CREATE RULE "Check_duenio" AS
    ON INSERT TO duenio
    WHERE new.rfc in (Select rfc FROM persona)
    DO INSTEAD
    Nothing;

CREATE RULE "Check_jockey" AS
    ON INSERT TO jockey
    WHERE new.rfc in (Select rfc FROM persona)
    DO INSTEAD
    Nothing;
