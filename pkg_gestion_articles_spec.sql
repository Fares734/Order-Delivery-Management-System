
CREATE OR REPLACE PACKAGE pkg_gestion_articles AS

FUNCTION f_article_existe(p_refart IN articles.refart%TYPE) RETURN BOOLEAN;
FUNCTION f_designation_existe(p_designation IN articles.designation%TYPE) RETURN BOOLEAN;

  PROCEDURE p_ajouter_article(
    p_designation IN articles.designation%TYPE,
    p_prixA       IN articles.prixA%TYPE,
    p_prixV       IN articles.prixV%TYPE,
    p_codetva     IN articles.codetva%TYPE,
    p_categorie   IN articles.categorie%TYPE,
    p_qtestk      IN articles.qtestk%TYPE);

  -- Supprimer article: logique si présent dans des commandes (supp='TRUE'), 
  -- sinon suppression physique
  PROCEDURE p_supprimer_article(p_refart IN articles.refart%TYPE);
  PROCEDURE p_modifier_article(
    p_refart      IN articles.refart%TYPE,
    p_designation IN articles.designation%TYPE DEFAULT NULL,
    p_prixA       IN articles.prixA%TYPE DEFAULT NULL,
    p_prixV       IN articles.prixV%TYPE DEFAULT NULL,
    p_codetva     IN articles.codetva%TYPE DEFAULT NULL,
    p_categorie   IN articles.categorie%TYPE DEFAULT NULL);

  PROCEDURE p_chercher_par_code(p_refart IN articles.refart%TYPE);
  PROCEDURE p_chercher_par_designation(p_designation IN VARCHAR2);
  PROCEDURE p_chercher_par_categorie(p_categorie IN articles.categorie%TYPE);

  errArticleExiste EXCEPTION;
  errArticleNonTrouve EXCEPTION;
  errArticleSupprime EXCEPTION;

  msgArticleExiste VARCHAR(200) := 'Article existant: ';
  msgArticleCree VARCHAR(200) := 'Article créé: ';
  msgArticleSupprimePhysique VARCHAR(200) := 'Article supprimé physiquement: ';
  msgArticleSupprimeLogique VARCHAR(200) := 'Article marqué comme supprimé (supp=TRUE): ';
  msgArticleModifie VARCHAR(200) := 'Article modifié: ';
  msgArticleNonTrouve VARCHAR(200) := 'Article non trouvé: ';

END pkg_gestion_articles;
