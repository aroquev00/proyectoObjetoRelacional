
create or replace function tgr_posicionFinal()
returns trigger as
    $func$
    declare
        bolsa numeric := (select bolsa_premio from carrera where num_carrera = new.en_carrera);
    begin
        if (new.posicion_final = 1) then
            -- actualizar jockey
            update jockey
            set salario = salario + (bolsa * 0.1)
            where rfc = new.un_jinete;
            -- actualizar entrenador
            update entrenador
            set salario = salario + (bolsa * 0.1)
            where (rfc = (select entrenado_por from caballo where registro = new.un_caballo));
            --where (new.un_caballo = any (entrena));
            -- actualizar duenio
            update duenio
            set ganancias = ganancias + (bolsa * 0.8)
            where rfc = (select rfcduenio from propiedad where registrocaballo = new.un_caballo);
        end if;
        return new;
    end;
    $func$ language plpgsql;


create trigger insert_posicion_final_arranque
    before insert or update of posicion_final
    on arranque
    for each row execute procedure tgr_posicionFinal();
