CREATE OR REPLACE PACKAGE pkg_gestion_livraisons AS

  FUNCTION f_livraison_existe(p_nocde IN LivraisonCom.nocde%TYPE, p_dateliv 
  IN LivraisonCom.dateliv%TYPE) RETURN BOOLEAN;
  FUNCTION f_commande_existe(p_nocde IN commandes.nocde%TYPE) RETURN BOOLEAN;
  FUNCTION f_livreur_existe(p_livreur IN personnel.idpers%TYPE) RETURN BOOLEAN;

  PROCEDURE p_ajouter_livraison(
    p_nocde    IN LivraisonCom.nocde%TYPE,
    p_dateliv  IN LivraisonCom.dateliv%TYPE,
    p_livreur  IN LivraisonCom.livreur%TYPE,
    p_modepay  IN LivraisonCom.modepay%TYPE
  );
  PROCEDURE p_supprimer_livraison(
    p_nocde   IN LivraisonCom.nocde%TYPE,
    p_dateliv IN LivraisonCom.dateliv%TYPE
  );
  PROCEDURE p_modifier_livraison(
    p_nocde       IN LivraisonCom.nocde%TYPE,
    p_dateliv_old IN LivraisonCom.dateliv%TYPE,
    p_dateliv_new IN LivraisonCom.dateliv%TYPE DEFAULT NULL,
    p_livreur_new IN LivraisonCom.livreur%TYPE DEFAULT NULL
  );

  PROCEDURE p_chercher_par_commande(p_nocde IN LivraisonCom.nocde%TYPE);
  PROCEDURE p_chercher_par_livreur(p_livreur IN LivraisonCom.livreur%TYPE);
  PROCEDURE p_chercher_par_ville(p_code_postal IN clients.code_postal%TYPE);
  PROCEDURE p_chercher_par_date(p_dateliv IN LivraisonCom.dateliv%TYPE);
  PROCEDURE p_chercher_par_livreur_et_date(
    p_livreur IN LivraisonCom.livreur%TYPE,
    p_dateliv IN LivraisonCom.dateliv%TYPE
  );
  
  errLivraisonExiste EXCEPTION;
  errLivraisonNonTrouvee EXCEPTION;
  errCommandeNonTrouvee EXCEPTION;
  errLivreurNonTrouve EXCEPTION;
  errComExiste EXCEPTION;

  msgLivraisonCree VARCHAR2(200) := 'Livraison créée: ';
  msgLivraisonSupprimee VARCHAR2(200) := 'Livraison supprimée (commande annulée): ';
  msgLivraisonModifiee VARCHAR2(200) := 'Livraison modifiée: ';
  msgLivraisonNonTrouvee VARCHAR2(200) := 'Livraison non trouvée pour commande: ';
  msgCommandeNonTrouvee VARCHAR2(200) := 'Commande non trouvée: ';
  msgLivreurNonTrouve VARCHAR2(200) := 'Livreur non trouvé: ';
  msgAucunResultat VARCHAR2(200) := 'Aucune livraison trouvée.';
  msgLivraisonExiste VARCHAR2(200) := 'Livraison existe déjà';
END pkg_gestion_livraisons;
