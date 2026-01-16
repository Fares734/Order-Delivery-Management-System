CREATE OR REPLACE TRIGGER trig_verif_auth
BEFORE INSERT OR UPDATE ON personnel
FOR EACH ROW
BEGIN
    IF :NEW.login IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Login obligatoire.');
    END IF;

    IF :NEW.motP IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Mot de passe obligatoire.');
    END IF;
END;

CREATE OR REPLACE TRIGGER trig_verif_tel
BEFORE INSERT OR UPDATE OF telpers ON Personnel
FOR EACH ROW
BEGIN
    IF :NEW.telpers < 20000000 OR :NEW.telpers > 99999999 THEN
        RAISE_APPLICATION_ERROR(-20003, 
            'Le numéro de téléphone doit être compris entre 20000000 et 99999999. ');
    END IF;
END;