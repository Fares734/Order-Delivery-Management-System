CREATE OR REPLACE TRIGGER trg_articles_prix
BEFORE INSERT OR UPDATE ON articles
FOR EACH ROW
BEGIN
    IF :NEW.prixV <= :NEW.prixA THEN
        RAISE_APPLICATION_ERROR(-20004, 'Le prix de vente doit être strictement 
        supérieur au prix d''achat.');
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_articles_unique
BEFORE INSERT ON articles
FOR EACH ROW
DECLARE
    vcount NUMBER;
BEGIN
    SELECT COUNT(*) INTO vcount
    FROM articles
    WHERE designation = :NEW.designation;

    IF vcount > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Cet article existe déjà .');
    END IF;
END;