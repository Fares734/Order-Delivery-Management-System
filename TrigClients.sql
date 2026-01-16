
CREATE OR REPLACE TRIGGER trig_clients_tel
BEFORE INSERT OR UPDATE OF telclt ON clients
FOR EACH ROW
BEGIN
    IF :NEW.telclt < 20000000 OR :NEW.telclt > 99999999 THEN
        RAISE_APPLICATION_ERROR(-20201, 
            'Erreur: Le numéro de téléphone du client ('||:NEW.telclt||') 
            doit être compris entre 20000000 et 99999999.');
    END IF;
END;

CREATE OR REPLACE TRIGGER trig_clients_doublon
BEFORE INSERT ON clients
FOR EACH ROW
DECLARE
    vcount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO vcount
    FROM clients
    WHERE UPPER(nomclt) = UPPER(:NEW.nomclt) 
      AND UPPER(prenomclt) = UPPER(:NEW.prenomclt)
      AND UPPER(adrclt) = UPPER(:NEW.adrclt);
    
    IF vcount > 0 THEN
        RAISE_APPLICATION_ERROR(-20202, 'Erreur: Ce client existe déjà.');
    END IF;
END;

