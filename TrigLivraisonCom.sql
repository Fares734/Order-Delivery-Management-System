CREATE OR REPLACE TRIGGER trig_livraisoncom_insert
BEFORE INSERT ON LivraisonCom
FOR EACH ROW
DECLARE
    vetatcommande CHAR(2);
    vcodepostalclient NUMBER(5);
    vnblivraisons NUMBER;
    vmaxlivraisons NUMBER := 15;  -- Limite configurable
BEGIN
    SELECT c.etatcde, cli.code_postal
    INTO vetatcommande, vcodepostalclient
    FROM commandes c , clients cli
    WHERE c.noclt = cli.noclt
    AND c.nocde = :NEW.nocde;
    
    IF vetatcommande != 'PR' THEN
        RAISE_APPLICATION_ERROR(-20501,
        'Erreur: La commande n°'||:NEW.nocde||' doit être à l''état ''PR'' 
        (Prête) pour être livrée.');
    END IF;
    
    SELECT COUNT(*)
    INTO vnblivraisons
    FROM LivraisonCom lc , clients cli , commandes c
    WHERE lc.nocde = c.nocde
    AND c.noclt = cli.noclt
    AND lc.livreur = :NEW.livreur
    AND TRUNC(lc.dateliv) = TRUNC(:NEW.dateliv)
    AND cli.code_postal = vcodepostalclient;
    
    IF vnblivraisons >= vmaxlivraisons THEN
        RAISE_APPLICATION_ERROR(-20502, 
    'Erreur: Le livreur n°'||:NEW.livreur||' a déjà '||vnblivraisons||' livraisons le '
    ||TO_CHAR(:NEW.dateliv, 'DD/MM/YYYY')||' dans la ville (code postal: '||vcodepostalclient
    ||'). La limite de '||vmaxlivraisons||' livraisons par jour et par ville est atteinte.');
    END IF;
END;


CREATE OR REPLACE TRIGGER trig_livraisoncom_update
BEFORE UPDATE ON LivraisonCom
FOR EACH ROW
DECLARE
    vcodepostalclient NUMBER(5);
    vnblivraisons NUMBER;
    vmaxlivraisons NUMBER := 15;  -- Limite configurable
    vheureactuelle NUMBER;
    vistoday BOOLEAN;
    visafternoon BOOLEAN;
BEGIN
    
    SELECT cli.code_postal
    INTO vcodepostalclient
    FROM commandes c , clients cli
    WHERE c.noclt = cli.noclt
    AND c.nocde = :NEW.nocde;
    
    IF :NEW.dateliv != :OLD.dateliv OR :NEW.livreur != :OLD.livreur THEN
        IF :NEW.livreur != :OLD.livreur OR :NEW.dateliv != :OLD.dateliv THEN
            SELECT COUNT(*)
            INTO vnblivraisons
            FROM LivraisonCom lc , commandes c , clients cli
            WHERE lc.nocde = c.nocde
            AND c.noclt = cli.noclt
            AND lc.livreur = :NEW.livreur
            AND TRUNC(lc.dateliv) = TRUNC(:NEW.dateliv)
            AND cli.code_postal = vcodepostalclient
            AND lc.nocde != :NEW.nocde;  
            
            IF vnblivraisons >= vmaxlivraisons THEN
                RAISE_APPLICATION_ERROR(-20503, 
'Erreur: Le livreur n°'||:NEW.livreur||' aurait '||(vnblivraisons + 1)||' livraisons le '
||TO_CHAR(:NEW.dateliv, 'DD/MM/YYYY')||' dans la ville (code postal: '||vcodepostalclient
||'). La limite de '||vmaxlivraisons||' livraisons par jour et par ville serait dépassée.');
            END IF;
        END IF;
        
        vheureactuelle := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
        vistoday := (TRUNC(:NEW.dateliv) = TRUNC(SYSDATE));
        visafternoon := (TO_NUMBER(TO_CHAR(:NEW.dateliv, 'HH24')) >= 12);
        
        IF vistoday THEN
            IF visafternoon AND vheureactuelle >= 14 THEN
                RAISE_APPLICATION_ERROR(-20504, 
'Erreur: Les modifications pour les livraisons de l''après-midi (à partir de 12:00) '
||'doivent être effectuées avant 14:00. Il est actuellement '||vheureactuelle||':00.');
            ELSIF NOT visafternoon AND vheureactuelle >= 9 THEN
                RAISE_APPLICATION_ERROR(-20505, 
'Erreur: Les modifications pour les livraisons du matin (avant 12:00) '
||'doivent être effectuées avant 09:00. Il est actuellement '||vheureactuelle||':00.');
            END IF;
        END IF; 
    END IF;
END;

