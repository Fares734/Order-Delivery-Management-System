CREATE OR REPLACE TRIGGER trig_commandes_date_etat
BEFORE INSERT ON commandes
FOR EACH ROW
BEGIN
   
    IF TRUNC(:NEW.datecde) != TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20301, 
            'Erreur: La date de la commande doit être égale à la date système.');
    END IF;
    
    IF :NEW.etatcde IS NULL THEN
        :NEW.etatcde := 'EC';
    END IF;
    
    IF :NEW.etatcde != 'EC' THEN
        RAISE_APPLICATION_ERROR(-20302, 
            'Erreur: L''état initial d''une nouvelle commande doit être ''EC'' (En Cours).');
    END IF;
END;

CREATE OR REPLACE TRIGGER trig_commandes_transition_etat
BEFORE UPDATE OF etatcde ON commandes
FOR EACH ROW
DECLARE
    vetatvalide BOOLEAN := FALSE;
BEGIN
    -- Vérifier les transitions d'état autorisées:
    -- EC -> PR -> LI -> SO
    -- EC -> AN
    -- EC -> PR -> AN
    -- EC -> PR -> AL
    
    IF :OLD.etatcde = 'EC' THEN
        IF :NEW.etatcde IN ('PR', 'AN') THEN
            vetatvalide := TRUE;
        END IF;
    ELSIF :OLD.etatcde = 'PR' THEN
        IF :NEW.etatcde IN ('LI', 'AN', 'AL') THEN
            vetatvalide := TRUE;
        END IF;
    ELSIF :OLD.etatcde = 'LI' THEN
        IF :NEW.etatcde = 'SO' THEN
            vetatvalide := TRUE;
        END IF;
    ELSIF :OLD.etatcde = 'SO' THEN
        vetatvalide := FALSE;
    ELSIF :OLD.etatcde = 'AN' OR :OLD.etatcde = 'AL' THEN
        vetatvalide := FALSE;
    END IF;
    
    IF NOT vetatvalide THEN
        RAISE_APPLICATION_ERROR(-20303, 
            'Erreur: Transition d''état non autorisée. Passage de '||:OLD.etatcde||' à '
            ||:NEW.etatcde||' est impossible.');
    END IF;
END;

