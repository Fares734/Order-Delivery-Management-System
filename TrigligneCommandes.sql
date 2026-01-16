CREATE OR REPLACE TRIGGER trg_VerifQtStock
BEFORE INSERT ON Ligcdes
FOR EACH ROW
DECLARE
    v_qtestk Articles.qtestk%TYPE;
BEGIN
    SELECT qtestk INTO v_qtestk FROM Articles WHERE refart = :NEW.refart;
    
    IF v_qtestk < :NEW.qtecde THEN
        RAISE_APPLICATION_ERROR(-20401, 
            'Erreur: Stock insuffisant' );
    END IF;
END;
CREATE OR REPLACE TRIGGER trg_MAJStock_ApresLigneCde
AFTER INSERT ON Ligcdes
FOR EACH ROW
BEGIN
    UPDATE Articles
    SET qtestk = qtestk - :NEW.qtecde
    WHERE refart = :NEW.refart;
END;
CREATE OR REPLACE TRIGGER trg_verif_stock_avant_modif
BEFORE UPDATE OF qtecde ON Ligcdes
FOR EACH ROW
WHEN (NEW.qtecde > OLD.qtecde)
DECLARE
    v_qtestk Articles.qtestk%TYPE;
    v_qte_diff NUMBER;

BEGIN
    SELECT qtestk INTO v_qtestk FROM Articles WHERE refart = :OLD.refart;
    v_qte_diff := :NEW.qtecde - :OLD.qtecde;
    IF v_qtestk < v_qte_diff THEN
        RAISE_APPLICATION_ERROR(-20402, 
            'Erreur: Stock insuffisant pour la modification de 
la quantité commandée.' );
 END IF;
END;   
CREATE OR REPLACE TRIGGER trg_MAJStock_ApresModif
AFTER UPDATE OF qtecde ON Ligcdes
FOR EACH ROW
BEGIN
    IF :NEW.qtecde != :OLD.qtecde THEN
        UPDATE Articles
        SET qtestk = qtestk + (:OLD.qtecde - :NEW.qtecde)
        WHERE refart = :OLD.refart;
    END IF;
END;