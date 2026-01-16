CREATE OR REPLACE PACKAGE BODY pkg_gestion_commandes AS

  FUNCTION f_commande_existe(p_nocde IN Commandes.nocde%TYPE) RETURN BOOLEAN IS
        vcount NUMBER;
    BEGIN
        SELECT COUNT(*) INTO vcount
        FROM Commandes
        WHERE nocde = p_nocde;
        RETURN vcount > 0;
    END f_commande_existe;
    
    FUNCTION f_client_existe(p_noclt IN Clients.noclt%TYPE) RETURN BOOLEAN IS
        vcount NUMBER;
    BEGIN
        SELECT COUNT(*) INTO vcount
        FROM Clients
        WHERE noclt = p_noclt;
        RETURN vcount > 0;
    END f_client_existe;

  PROCEDURE p_ajouter_commande(p_noclt IN clients.noclt%TYPE) IS
    vcount NUMBER;
    BEGIN
        IF NOT f_client_existe(p_noclt) THEN
            RAISE errClientExiste;
        END IF;
    INSERT INTO Commandes (nocde, noclt, datecde, etatcde)
    VALUES (seq_commandes.NEXTVAL, p_noclt, SYSDATE, 'EC');
    p_afficher_msg('Commande numéro: ' || seq_commandes.CURRVAL|| 'créée avec succès.');
    EXCEPTION
        WHEN errClientExiste THEN
            p_afficher_msg(msgClientExist || p_noclt);
    END p_ajouter_commande;

  PROCEDURE p_ajouter_ligneCommande(p_nocde IN LigCdes.nocde%TYPE,p_refart IN LigCdes.refart%TYPE,
        p_qtecde IN LigCdes.qtecde%TYPE) IS
        v_etat Commandes.etatcde%TYPE;
        v_stock Articles.qtestk%TYPE;
        v_supp Articles.supp%TYPE;
        v_countArtCom NUMBER;
    BEGIN
        IF NOT f_commande_existe(p_nocde) THEN
            RAISE errCommande;
        END IF;
        SELECT etatcde INTO v_etat FROM Commandes WHERE nocde = p_nocde;
        IF v_etat != 'EC' THEN
           RAISE errCommandeEnCours;
        END IF;
        SELECT qtestk, supp INTO v_stock, v_supp
        FROM Articles WHERE refart = p_refart;
        IF UPPER(v_supp) = 'TRUE' THEN
            RAISE errArticleDisponible;
        END IF;
        SELECT COUNT(*) INTO v_countArtCom FROM LigCdes WHERE nocde = p_nocde AND refart = p_refart;
        IF v_countArtCom > 0 THEN
        RAISE errArtCom;
        END IF;
        INSERT INTO LigCdes (nocde, refart, qtecde)
        VALUES (p_nocde, p_refart, p_qtecde);
        p_afficher_msg('Ligne de commande ajoutée avec succès.');
        
    EXCEPTION
        WHEN errCommande THEN
            p_afficher_msg(msgCommandeExist || p_nocde);
        WHEN errCommandeEnCours THEN
            p_afficher_msg('La commande n°' || p_nocde || ' n''est pas en état ''EC'' (En Cours).');
        WHEN errArticleDisponible THEN
            p_afficher_msg('L''article ' ||p_refart|| ' n''est pas disponible (supprimé)');
        WHEN errArtCom THEN
            p_afficher_msg('L''article ' ||p_refart|| ' existe déjà dans la commande ' ||p_nocde);
        WHEN NO_DATA_FOUND THEN
            p_afficher_msg(msgArticleExist || p_refart);
    END p_ajouter_ligneCommande;

    PROCEDURE p_modifier_ligneCommande(p_nocde IN LigCdes.nocde%TYPE,
        p_refart IN LigCdes.refart%TYPE,
        p_nouvelle_qtecde IN LigCdes.qtecde%TYPE) IS
        v_etat Commandes.etatcde%TYPE;
        v_countArtCom NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_countArtCom FROM LigCdes WHERE nocde = p_nocde AND refart = p_refart;
        IF v_countArtCom = 0 THEN
        RAISE errArtCom;
        END IF;
        SELECT etatcde INTO v_etat FROM Commandes WHERE nocde = p_nocde;
        IF v_etat != 'EC' THEN
           RAISE errCommandeEnCours;
        END IF;
        UPDATE LigCdes
        SET qtecde = p_nouvelle_qtecde
        WHERE nocde = p_nocde AND refart = p_refart;
        p_afficher_msg('Ligne de commande modifiée avec succès.');
        EXCEPTION
        WHEN errCommandeEnCours THEN
            p_afficher_msg('La commande n°' || p_nocde || ' n''est pas en état ''EC'' (En Cours).');
        WHEN errArtCom THEN
            p_afficher_msg('L''article ' ||p_refart|| ' n''existe pas dans la commande ' ||p_nocde);
    END p_modifier_ligneCommande;

    
  PROCEDURE modifier_etat(p_nocde IN Commandes.nocde%TYPE, p_nouveau_etat IN Commandes.etatcde%TYPE) IS
    v_prec_etat CHAR(2);
  BEGIN
    SELECT etatcde INTO v_prec_etat FROM commandes WHERE nocde = p_nocde;
    UPDATE commandes SET etatcde = p_nouveau_etat WHERE nocde = p_nocde;
    p_afficher_msg('État de la commande est modifié avec succés. ');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_afficher_msg(msgCommandeExist || p_nocde);
  END modifier_etat;

  PROCEDURE annuler_commande(p_nocde IN Commandes.nocde%TYPE) IS
    v_prec_etat Commandes.etatcde%TYPE;
    v_noclt Clients.noclt%TYPE;
    v_nbrart NUMBER := 0;
    v_montantc NUMBER := 0;
    v_datecde Commandes.datecde%TYPE;
    v_code_postal Clients.code_postal%TYPE;
    v_refart Articles.refart%TYPE;
    v_qtecde LigCdes.qtecde%TYPE;
  BEGIN
    SELECT c.etatcde, c.noclt, c.datecde, cli.code_postal
    INTO v_prec_etat, v_noclt, v_datecde, v_code_postal
    FROM commandes c , clients cli
    WHERE c.noclt = cli.noclt
    AND c.nocde = p_nocde;
    IF v_prec_etat IN ('LI','SO','AN','AL') THEN
      RAISE erreurEtatCommande;
          END IF;
    SELECT NVL(SUM(l.qtecde),0), NVL(SUM(l.qtecde * a.prixV),0)
    INTO v_nbrart, v_montantc
    FROM ligcdes l , articles a
    WHERE l.refart = a.refart
    AND l.nocde = p_nocde;
    UPDATE commandes SET etatcde = 'AN' WHERE nocde = p_nocde;

    INSERT INTO HCommandesAnnulees(
      nocde, numclt, nbrart, montantc, datecde, dateAnnulation, code_postal, avantLiv) 
      VALUES (p_nocde, v_noclt, v_nbrart, v_montantc, v_datecde, SYSDATE, v_code_postal, 'TRUE');
    SELECT refart, qtecde INTO v_refart, v_qtecde 
    FROM Ligcdes
    WHERE nocde = p_nocde;
    UPDATE Articles 
    SET qtestk = qtestk + v_qtecde
    WHERE refart = v_refart;
     p_afficher_msg('Commande ' || p_nocde || ' annulée avec succès.');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_afficher_msg(msgCommandeExist || p_nocde);
    WHEN erreurEtatCommande THEN
        p_afficher_msg('La commande ne peut pas être annulée car elle est déjà livrée ou annulée.');
  END annuler_commande;

  PROCEDURE p_chercher_commande_numero(p_nocde IN Commandes.nocde%TYPE) IS
    v_nocde    Commandes.nocde%TYPE;
    v_noclt    Commandes.noclt%TYPE;
    v_nomclt   Clients.nomclt%TYPE;
    v_datecde  Commandes.datecde%TYPE;
    v_etatcde  Commandes.etatcde%TYPE;
  BEGIN
    SELECT c.nocde, c.noclt, cl.nomclt, c.datecde, c.etatcde
    INTO   v_nocde, v_noclt, v_nomclt, v_datecde, v_etatcde
    FROM   Commandes c , Clients cl
    WHERE c.noclt = cl.noclt
    AND c.nocde = p_nocde;
    p_afficher_msg(v_nocde || ' | ' || v_noclt || ' | ' || v_nomclt || 
            ' | ' || TO_CHAR(v_datecde, 'DD/MM/YYYY') ||' | ' || v_etatcde);
    p_afficher_msg('Articles de la commande:');
    FOR rec IN (
        SELECT a.refart, a.designation, lc.qtecde, a.prixV,
               (lc.qtecde * a.prixV) AS total
        FROM   LigCdes lc , Articles a
        WHERE lc.refart = a.refart
        AND   lc.nocde = p_nocde)
    LOOP
        p_afficher_msg(
            '  ' || rec.refart || ' , ' || rec.designation || 
            ' , ' || rec.qtecde || ' , ' || rec.prixV || 
            ' = ' || rec.total);
    END LOOP;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_afficher_msg(msgCommandeExist || p_nocde);
    END p_chercher_commande_numero;


    PROCEDURE p_chercher_commandes_client(p_noclt IN Clients.noclt%TYPE) IS
        CURSOR curCmd IS
            SELECT c.nocde, c.noclt, cl.nomclt, c.datecde, c.etatcde
            FROM Commandes c, Clients cl
            WHERE c.noclt = cl.noclt
            AND c.noclt = p_noclt;
        vCurCmd curCmd%ROWTYPE;
        vnb NUMBER := 0;
    BEGIN
        IF NOT f_client_existe(p_noclt) THEN
            RAISE errClientExiste;
        END IF;
        
        OPEN curCmd;
        p_afficher_msg('Commandes du client ' || p_noclt);
        LOOP
            FETCH curCmd INTO vCurCmd;
            EXIT WHEN curCmd%NOTFOUND;
            p_afficher_msg(vCurCmd.nocde || ' | ' || TO_CHAR(vCurCmd.datecde, 'DD/MM/YYYY') 
            || ' | ' || vCurCmd.etatcde );
        END LOOP;
        vnb := curCmd%ROWCOUNT;
        CLOSE curCmd;
        
        IF vnb = 0 THEN
            RAISE errClientCommande;
        ELSE
            p_afficher_msg('Total: ' || vnb || ' commande(s)');
        END IF;
        
    EXCEPTION
        WHEN errClientExiste THEN
            p_afficher_msg(msgClientExist || p_noclt);
        WHEN errClientCommande THEN
            p_afficher_msg('Aucune commande trouvée pour le client ' || p_noclt);
    END p_chercher_commandes_client;

  PROCEDURE p_chercher_commandes_date(p_date IN Commandes.datecde%TYPE) IS
        CURSOR curCmd IS
            SELECT c.nocde, c.noclt, cl.nomclt, c.datecde, c.etatcde
            FROM Commandes c, Clients cl
            WHERE c.noclt = cl.noclt
            AND TRUNC(c.datecde) = TRUNC(p_date);
        vCurCmd curCmd%ROWTYPE;
        vnb NUMBER := 0;
    BEGIN
        OPEN curCmd;
        p_afficher_msg('Commandes du ' || TO_CHAR(p_date, 'DD/MM/YYYY'));
        LOOP
            FETCH curCmd INTO vCurCmd;
            EXIT WHEN curCmd%NOTFOUND;
    p_afficher_msg(vCurCmd.nocde || ' | ' || vCurCmd.nomclt || ' | ' || vCurCmd.etatcde);
        END LOOP;
        vnb := curCmd%ROWCOUNT;
        CLOSE curCmd;
        IF vnb = 0 THEN
            RAISE errCommandeDate;
        ELSE
            p_afficher_msg('Total: ' || vnb || ' commande(s)');
        END IF;
    
    EXCEPTION
        WHEN errCommandeDate THEN
    p_afficher_msg('Aucune commande trouvée pour la date ' || TO_CHAR(p_date, 'DD/MM/YYYY'));
    END p_chercher_commandes_date;
END pkg_gestion_commandes;

