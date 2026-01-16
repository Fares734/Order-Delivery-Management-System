
CREATE OR REPLACE PACKAGE pkg_gestion_commandes AS
FUNCTION f_commande_existe(p_nocde IN Commandes.nocde%TYPE) RETURN BOOLEAN;
FUNCTION f_client_existe(p_noclt IN Clients.noclt%TYPE) RETURN BOOLEAN;

PROCEDURE p_ajouter_commande(p_noclt IN clients.noclt%TYPE);
PROCEDURE p_ajouter_ligneCommande(p_nocde IN LigCdes.nocde%TYPE,p_refart 
IN LigCdes.refart%TYPE,p_qtecde IN LigCdes.qtecde%TYPE);
PROCEDURE p_modifier_ligneCommande(p_nocde IN LigCdes.nocde%TYPE,p_refart 
IN LigCdes.refart%TYPE,p_nouvelle_qtecde IN LigCdes.qtecde%TYPE);
PROCEDURE modifier_etat(p_nocde IN Commandes.nocde%TYPE, p_nouveau_etat 
IN Commandes.etatcde%TYPE);
PROCEDURE annuler_commande(p_nocde IN Commandes.nocde%TYPE);

PROCEDURE p_chercher_commande_numero(p_nocde IN Commandes.nocde%TYPE);
PROCEDURE p_chercher_commandes_client(p_noclt IN Clients.noclt%TYPE);
PROCEDURE p_chercher_commandes_date(p_date IN Commandes.datecde%TYPE);
  
errClientExiste EXCEPTION;
erreurEtatCommande EXCEPTION;
errCommande EXCEPTION;
errCommandeEnCours EXCEPTION;
errArticleDisponible EXCEPTION;
errClientCommande EXCEPTION;
errCommandeDate EXCEPTION;
errArtCom EXCEPTION;

msgClientExist varchar(100) := 'Aucun client avec le numéro ';
msgCommandeExist varchar(100) := 'Aucune commande avec le numéro ';
msgArticleExist varchar(100) := 'Aucun article avec la référence ';
END pkg_gestion_commandes;

