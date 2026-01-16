
CREATE OR REPLACE PACKAGE BODY pkg_gestion_livraisons AS

  FUNCTION f_livraison_existe(p_nocde IN LivraisonCom.nocde%TYPE, p_dateliv 
  IN LivraisonCom.dateliv%TYPE) RETURN BOOLEAN IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM LivraisonCom
    WHERE nocde = p_nocde AND TRUNC(dateliv) = TRUNC(p_dateliv);
    RETURN v_count > 0;
  END f_livraison_existe;
  
  FUNCTION f_commande_existe(p_nocde IN commandes.nocde%TYPE) RETURN BOOLEAN IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM commandes
    WHERE nocde = p_nocde;
    RETURN v_count > 0;
  END f_commande_existe;
  
  FUNCTION f_livreur_existe(p_livreur IN personnel.idpers%TYPE) RETURN BOOLEAN IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM personnel
    WHERE idpers = p_livreur;
    RETURN v_count > 0;
  END f_livreur_existe;

  PROCEDURE p_ajouter_livraison(
    p_nocde    IN LivraisonCom.nocde%TYPE,
    p_dateliv  IN LivraisonCom.dateliv%TYPE,
    p_livreur  IN LivraisonCom.livreur%TYPE,
    p_modepay  IN LivraisonCom.modepay%TYPE
  ) IS
    v_count NUMBER;
  BEGIN
    IF NOT f_commande_existe(p_nocde) THEN
      RAISE errCommandeNonTrouvee;
    END IF;
    IF NOT f_livreur_existe(p_livreur) THEN
      RAISE errLivreurNonTrouve;
    END IF;

    IF f_livraison_existe(p_nocde, p_dateliv) THEN
      RAISE errLivraisonExiste;
    END IF;
    SELECT count(*) INTO v_count
    FROM LivraisonCom
    WHERE nocde = p_nocde;
    IF v_count > 0 THEN
      RAISE errComExiste;
    END IF;
    INSERT INTO LivraisonCom(nocde, dateliv, livreur, modepay, etatliv)
    VALUES (p_nocde, p_dateliv, p_livreur, p_modepay, 'EC');
    p_afficher_msg(msgLivraisonCree || p_nocde || ' - Livreur: ' || p_livreur 
    || ' - Date: ' || TO_CHAR(p_dateliv, 'DD/MM/YYYY'));
  EXCEPTION
    WHEN errCommandeNonTrouvee THEN
      p_afficher_msg(msgCommandeNonTrouvee || p_nocde);
    WHEN errLivreurNonTrouve THEN
      p_afficher_msg(msgLivreurNonTrouve || p_livreur);
    WHEN errLivraisonExiste THEN
        p_afficher_msg(msgLivraisonExiste || ' pour commande ' || p_nocde 
        || ' à la date ' || TO_CHAR(p_dateliv, 'DD/MM/YYYY'));
    WHEN errComExiste THEN
        p_afficher_msg('Erreur: Une livraison existe déjà pour la commande ' || p_nocde);
  END p_ajouter_livraison;

  PROCEDURE p_supprimer_livraison(
    p_nocde   IN LivraisonCom.nocde%TYPE,
    p_dateliv IN LivraisonCom.dateliv%TYPE) IS
    v_noclt clients.noclt%TYPE;
    v_nbrart NUMBER := 0;
    v_montantc NUMBER := 0;
    v_datecde commandes.datecde%TYPE;
    v_code_postal clients.code_postal%TYPE;
  BEGIN
    IF NOT f_livraison_existe(p_nocde, p_dateliv) THEN
      RAISE errLivraisonNonTrouvee;
    END IF;
    SELECT c.noclt, c.datecde, cli.code_postal
    INTO v_noclt, v_datecde, v_code_postal
    FROM commandes c , clients cli
    WHERE c.noclt = cli.noclt
    AND c.nocde = p_nocde;
    SELECT NVL(SUM(l.qtecde), 0), NVL(SUM(l.qtecde * a.prixV), 0)
    INTO v_nbrart, v_montantc
    FROM ligcdes l , articles a
    WHERE l.refart = a.refart
    AND l.nocde = p_nocde;
    UPDATE commandes SET etatcde = 'AN' WHERE nocde = p_nocde;
   
    INSERT INTO HCommandesAnnulees(
    nocde, numclt, nbrart, montantc, datecde, dateAnnulation, code_postal, avantLiv)
    VALUES (p_nocde, v_noclt, v_nbrart, v_montantc, v_datecde, SYSDATE, v_code_postal, 'TRUE');
    UPDATE LivraisonCom
    SET etatliv = 'AL'
    WHERE nocde = p_nocde AND TRUNC(dateliv) = TRUNC(p_dateliv);
    p_afficher_msg(msgLivraisonSupprimee || p_nocde);
  EXCEPTION
    WHEN errLivraisonNonTrouvee THEN
      p_afficher_msg(msgLivraisonNonTrouvee || p_nocde);
  END p_supprimer_livraison;

  PROCEDURE p_modifier_livraison(
    p_nocde       IN LivraisonCom.nocde%TYPE,
    p_dateliv_old IN LivraisonCom.dateliv%TYPE,
    p_dateliv_new IN LivraisonCom.dateliv%TYPE DEFAULT NULL,
    p_livreur_new IN LivraisonCom.livreur%TYPE DEFAULT NULL
  ) IS
    v_dateliv_finale LivraisonCom.dateliv%TYPE;
    v_livreur_finale LivraisonCom.livreur%TYPE;
  BEGIN
    IF NOT f_livraison_existe(p_nocde, p_dateliv_old) THEN
      RAISE errLivraisonNonTrouvee;
    END IF;
    SELECT dateliv, livreur
    INTO v_dateliv_finale, v_livreur_finale
    FROM LivraisonCom
    WHERE nocde = p_nocde AND TRUNC(dateliv) = TRUNC(p_dateliv_old);
    IF p_dateliv_new IS NOT NULL THEN
      v_dateliv_finale := p_dateliv_new;
    END IF;
    IF p_livreur_new IS NOT NULL THEN
      v_livreur_finale := p_livreur_new;
    END IF;

    IF p_livreur_new IS NOT NULL AND NOT f_livreur_existe(p_livreur_new) THEN
      RAISE errLivreurNonTrouve;
    END IF;
    UPDATE LivraisonCom
    SET dateliv = v_dateliv_finale,
        livreur = v_livreur_finale
    WHERE nocde = p_nocde AND TRUNC(dateliv) = TRUNC(p_dateliv_old);
    p_afficher_msg(msgLivraisonModifiee || p_nocde || ' - Date: ' 
    || TO_CHAR(v_dateliv_finale, 'DD/MM/YYYY') || ' - Livreur: ' || v_livreur_finale);

  EXCEPTION
    WHEN errLivraisonNonTrouvee THEN
      p_afficher_msg(msgLivraisonNonTrouvee || p_nocde);
    WHEN errLivreurNonTrouve THEN
      p_afficher_msg(msgLivreurNonTrouve || p_livreur_new);
  END p_modifier_livraison;

 PROCEDURE p_chercher_par_commande(p_nocde IN LivraisonCom.nocde%TYPE) IS
    v_nocde LivraisonCom.nocde%TYPE;
    v_dateliv LivraisonCom.dateliv%TYPE;
    v_livreur LivraisonCom.livreur%TYPE;
    v_nompers personnel.nompers%TYPE;
    v_modepay LivraisonCom.modepay%TYPE;
    v_etatliv LivraisonCom.etatliv%TYPE;
  BEGIN
    p_afficher_msg('Livraison pour la commande ' || p_nocde || ':');
      SELECT lc.nocde, lc.dateliv, lc.livreur, p.nompers, lc.modepay, lc.etatliv 
      INTO v_nocde, v_dateliv, v_livreur, v_nompers, v_modepay, v_etatliv
      FROM LivraisonCom lc , personnel p
      WHERE lc.livreur = p.idpers
      AND  lc.nocde = p_nocde;
p_afficher_msg('  ' || v_nocde || ' | ' || TO_CHAR(v_dateliv, 'DD/MM/YYYY HH24:MI') 
|| ' | Livreur: ' || v_nompers || ' | Mode: ' || v_modepay || ' | État: ' || v_etatliv);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       p_afficher_msg(msgAucunResultat);
  END p_chercher_par_commande;

  PROCEDURE p_chercher_par_livreur(p_livreur IN LivraisonCom.livreur%TYPE) IS
    CURSOR cur_livraisons IS
      SELECT lc.nocde, lc.dateliv, lc.modepay, lc.etatliv
      FROM LivraisonCom lc
      WHERE lc.livreur = p_livreur;
    rec cur_livraisons%ROWTYPE;
    vnb NUMBER := 0;
  BEGIN
    p_afficher_msg('Livraisons du livreur ' || p_livreur || ':');
    OPEN cur_livraisons;
    LOOP
      FETCH cur_livraisons INTO rec;
      EXIT WHEN cur_livraisons%NOTFOUND;
p_afficher_msg('  Commande: ' || rec.nocde || ' | Date: ' || TO_CHAR(rec.dateliv, 'DD/MM/YYYY HH24:MI') 
|| ' | Mode: ' || rec.modepay || ' | État: ' || rec.etatliv);
    END LOOP;
    vnb := cur_livraisons%ROWCOUNT;
    CLOSE cur_livraisons;
    IF vnb = 0 THEN
      RAISE errLivraisonNonTrouvee;
    END IF;
  EXCEPTION
    WHEN errLivraisonNonTrouvee THEN
      p_afficher_msg(msgAucunResultat);
  END p_chercher_par_livreur;

  PROCEDURE p_chercher_par_ville(p_code_postal IN clients.code_postal%TYPE) IS
    CURSOR cur_livraisons_ville IS
      SELECT lc.nocde, lc.dateliv, lc.livreur, p.nompers, lc.modepay, lc.etatliv
      FROM LivraisonCom lc , commandes c , clients cli , personnel p
      WHERE lc.nocde = c.nocde
      AND c.noclt = cli.noclt
      AND lc.livreur = p.idpers
      AND cli.code_postal = p_code_postal;
    rec cur_livraisons_ville%ROWTYPE;
    vnb NUMBER := 0;
  BEGIN
    p_afficher_msg('Livraisons ville (code postal ' || p_code_postal || '):');
    OPEN cur_livraisons_ville;
    LOOP
      FETCH cur_livraisons_ville INTO rec;
      EXIT WHEN cur_livraisons_ville%NOTFOUND;
      p_afficher_msg('  Commande: ' || rec.nocde || ' | Date: ' 
      || TO_CHAR(rec.dateliv, 'DD/MM/YYYY HH24:MI') 
      || ' | Livreur: ' || rec.nompers || ' | Mode: ' || rec.modepay 
      || ' | État: ' || rec.etatliv);
    END LOOP;
    vnb := cur_livraisons_ville%ROWCOUNT;
    CLOSE cur_livraisons_ville;
    IF vnb = 0 THEN
      RAISE errLivraisonNonTrouvee;
    END IF;
  EXCEPTION
    WHEN errLivraisonNonTrouvee THEN
      p_afficher_msg(msgAucunResultat);
  END p_chercher_par_ville;

  PROCEDURE p_chercher_par_date(p_dateliv IN LivraisonCom.dateliv%TYPE) IS
    CURSOR cur_livraisons_date IS
      SELECT lc.nocde, lc.dateliv, lc.livreur, p.nompers, lc.modepay, lc.etatliv
      FROM LivraisonCom lc , personnel p
      WHERE lc.livreur = p.idpers
      AND TRUNC(lc.dateliv) = TRUNC(p_dateliv);
    
    rec cur_livraisons_date%ROWTYPE;
    vnb NUMBER := 0;
  BEGIN
    p_afficher_msg('Livraisons du ' || TO_CHAR(p_dateliv, 'DD/MM/YYYY') || ':');
    OPEN cur_livraisons_date;
    LOOP
      FETCH cur_livraisons_date INTO rec;
      EXIT WHEN cur_livraisons_date%NOTFOUND;
      p_afficher_msg('  Commande: ' || rec.nocde || ' | Livreur: ' || rec.nompers 
      || ' | Mode: ' || rec.modepay || ' | État: ' || rec.etatliv);
    END LOOP;
    vnb := cur_livraisons_date%ROWCOUNT;
    CLOSE cur_livraisons_date;
    IF vnb = 0 THEN
        RAISE errLivraisonNonTrouvee;
    END IF;
  EXCEPTION
    WHEN errLivraisonNonTrouvee THEN
      p_afficher_msg(msgAucunResultat);
  END p_chercher_par_date;

  PROCEDURE p_chercher_par_livreur_et_date(
    p_livreur IN LivraisonCom.livreur%TYPE,
    p_dateliv IN LivraisonCom.dateliv%TYPE
  ) IS
    CURSOR cur_livraisons_liv_date IS
      SELECT lc.nocde, lc.dateliv, lc.modepay, lc.etatliv
      FROM LivraisonCom lc
      WHERE lc.livreur = p_livreur
        AND TRUNC(lc.dateliv) = TRUNC(p_dateliv);
    
    rec cur_livraisons_liv_date%ROWTYPE;
    vnb NUMBER := 0;
  BEGIN
    p_afficher_msg('Livraisons livreur ' || p_livreur || ' du ' 
    || TO_CHAR(p_dateliv, 'DD/MM/YYYY') || ':');
    OPEN cur_livraisons_liv_date;
    LOOP
      FETCH cur_livraisons_liv_date INTO rec;
      EXIT WHEN cur_livraisons_liv_date%NOTFOUND;
      p_afficher_msg('  Commande: ' || rec.nocde || ' | Mode: ' || rec.modepay 
      || ' | État: ' || rec.etatliv);
    END LOOP;
    vnb := cur_livraisons_liv_date%ROWCOUNT;
    CLOSE cur_livraisons_liv_date;
    
    IF vnb = 0 THEN
        RAISE errLivraisonNonTrouvee;
    END IF;
  EXCEPTION
    WHEN errLivraisonNonTrouvee THEN
      p_afficher_msg(msgAucunResultat);
  END p_chercher_par_livreur_et_date;

END pkg_gestion_livraisons;
