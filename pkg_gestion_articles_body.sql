
  CREATE OR REPLACE PACKAGE BODY pkg_gestion_articles AS

  FUNCTION f_article_existe(p_refart IN articles.refart%TYPE) RETURN BOOLEAN IS
    vcount NUMBER;
  BEGIN
    SELECT COUNT(*) INTO vcount FROM articles WHERE UPPER(refart) = UPPER(p_refart);
    RETURN vcount > 0;
  END f_article_existe;

  FUNCTION f_designation_existe(p_designation IN articles.designation%TYPE) RETURN BOOLEAN IS
    vcount NUMBER;
  BEGIN
    SELECT COUNT(*) INTO vcount FROM articles WHERE UPPER(designation) = UPPER(p_designation);
    RETURN vcount > 0;
  END f_designation_existe;

  PROCEDURE p_ajouter_article(
    p_designation IN articles.designation%TYPE,
    p_prixA       IN articles.prixA%TYPE,
    p_prixV       IN articles.prixV%TYPE,
    p_codetva     IN articles.codetva%TYPE,
    p_categorie   IN articles.categorie%TYPE,
    p_qtestk      IN articles.qtestk%TYPE
  ) IS
    v_design_exist NUMBER;
  BEGIN

    INSERT INTO articles(refart, designation, prixV, prixA, codetva, categorie, qtestk, supp)
    VALUES(CONCAT('Ar',seq_articles.NEXTVAL), p_designation, p_prixV, p_prixA, 
    p_codetva, p_categorie, p_qtestk, 'FALSE');

    p_afficher_msg(msgArticleCree || ' (' || p_designation || ')');
 
  END p_ajouter_article;

  PROCEDURE p_supprimer_article(p_refart IN articles.refart%TYPE) IS
    v_count_commande NUMBER;
  BEGIN
    IF NOT f_article_existe(p_refart) THEN
      RAISE errArticleNonTrouve;
    END IF;

    SELECT COUNT(*) INTO v_count_commande
    FROM ligcdes
    WHERE refart = p_refart;
    IF v_count_commande > 0 THEN
      -- Suppression logique
      UPDATE articles SET supp = 'TRUE' WHERE refart = p_refart;
      p_afficher_msg(msgArticleSupprimeLogique || p_refart);
    ELSE
     -- Suppression physique
      DELETE FROM articles WHERE refart = p_refart;
      p_afficher_msg(msgArticleSupprimePhysique || p_refart);
    END IF;
  EXCEPTION
    WHEN errArticleNonTrouve THEN
      p_afficher_msg(msgArticleNonTrouve || p_refart);
  END p_supprimer_article;

  PROCEDURE p_modifier_article(
    p_refart      IN articles.refart%TYPE,
    p_designation IN articles.designation%TYPE DEFAULT NULL,
    p_prixA       IN articles.prixA%TYPE DEFAULT NULL,
    p_prixV       IN articles.prixV%TYPE DEFAULT NULL,
    p_codetva     IN articles.codetva%TYPE DEFAULT NULL,
    p_categorie   IN articles.categorie%TYPE DEFAULT NULL) IS
    v_prixA articles.prixA%TYPE;
    v_prixV articles.prixV%TYPE;
    v_finalA  articles.prixA%TYPE;
    v_finalV  articles.prixV%TYPE;
  BEGIN
    IF NOT f_article_existe(p_refart) THEN
      RAISE errArticleNonTrouve;
    END IF;
    v_finalA := p_prixA;
    v_finalV := p_prixV;
    -- Récupérer les prix actuels
    SELECT prixA, prixV INTO v_prixA, v_prixV FROM articles WHERE refart = p_refart;
    IF v_finalA IS NULL THEN
      v_finalA := v_prixA;
    END IF;
    IF v_finalV IS NULL THEN
       v_finalV := v_prixV;
    END IF;
    IF p_designation IS NOT NULL THEN
      UPDATE articles SET designation = p_designation WHERE refart = p_refart;
    END IF;
    IF p_prixA IS NOT NULL THEN
      UPDATE articles SET prixA = p_prixA WHERE refart = p_refart;
    END IF;
    IF p_prixV IS NOT NULL THEN
      UPDATE articles SET prixV = p_prixV WHERE refart = p_refart;
    END IF;
    IF p_codetva IS NOT NULL THEN
      UPDATE articles SET codetva = p_codetva WHERE refart = p_refart;
    END IF;
    IF p_categorie IS NOT NULL THEN
      UPDATE articles SET categorie = p_categorie WHERE refart = p_refart;
    END IF;
    p_afficher_msg(msgArticleModifie || p_refart);
  EXCEPTION
    WHEN errArticleNonTrouve THEN
      p_afficher_msg(msgArticleNonTrouve || p_refart);
  END p_modifier_article;

  PROCEDURE p_chercher_par_code(p_refart IN articles.refart%TYPE) IS
    v_refart articles.refart%TYPE;
    v_designation articles.designation%TYPE;
    v_prixV articles.prixV%TYPE;
    v_prixA articles.prixA%TYPE;
    v_codetva articles.codetva%TYPE;
    v_categorie articles.categorie%TYPE;
    v_qtestk articles.qtestk%TYPE;
    v_supp articles.supp%TYPE;
  BEGIN
    SELECT refart, designation, prixV, prixA, codetva, categorie, qtestk, supp
    INTO v_refart, v_designation, v_prixV, v_prixA, v_codetva, v_categorie, v_qtestk, v_supp
    FROM articles WHERE refart = p_refart;

    p_afficher_msg(v_refart || ' | ' || v_designation || ' | ' || v_qtestk || ' | ' 
    || v_categorie || ' | ' || v_prixA || ' | ' || v_prixV || ' | supp=' || v_supp);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_afficher_msg(msgArticleNonTrouve || p_refart);
  END p_chercher_par_code;

  PROCEDURE p_chercher_par_designation(p_designation IN VARCHAR2) IS
    v_refart articles.refart%TYPE;
    v_designation articles.designation%TYPE;
    v_prixV articles.prixV%TYPE;
    v_prixA articles.prixA%TYPE;
    v_codetva articles.codetva%TYPE;
    v_categorie articles.categorie%TYPE;
    v_qtestk articles.qtestk%TYPE;
    v_supp articles.supp%TYPE;
  BEGIN
      SELECT refart, designation, prixV, prixA, codetva, categorie, qtestk, supp 
      INTO v_refart, v_designation, v_prixV, v_prixA, v_codetva, v_categorie, v_qtestk, v_supp
      FROM articles
      WHERE UPPER(designation) = UPPER(p_designation);
    
      p_afficher_msg(v_refart || ' | ' || v_designation || ' | ' || v_qtestk || ' | ' 
      || v_categorie || ' | ' || v_prixA || ' | ' || v_prixV || ' | supp=' || v_supp);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        p_afficher_msg(msgArticleNonTrouve || 'avec désignation ' || p_designation);
  END p_chercher_par_designation;

  PROCEDURE p_chercher_par_categorie(p_categorie IN articles.categorie%TYPE) IS
    CURSOR cur_cat IS
      SELECT refart, designation, prixV, prixA, codetva, categorie, qtestk, supp
      FROM articles
      WHERE UPPER(categorie) = UPPER(p_categorie);
    v_rec cur_cat%ROWTYPE;
    v_count NUMBER := 0;
  BEGIN
    OPEN cur_cat;
    LOOP
      FETCH cur_cat INTO v_rec;
      EXIT WHEN cur_cat%NOTFOUND;
      p_afficher_msg(v_rec.refart || ' | ' || v_rec.designation || ' | ' || v_rec.qtestk 
      || ' | ' || v_rec.categorie || ' | ' || v_rec.prixA || ' | ' || v_rec.prixV 
      || ' | supp=' || v_rec.supp);
    END LOOP;
    v_count := cur_cat%ROWCOUNT;
    CLOSE cur_cat;
    IF v_count = 0 THEN
      RAISE errArticleNonTrouve;
    END IF;
  EXCEPTION
        WHEN errArticleNonTrouve THEN
        p_afficher_msg(msgArticleNonTrouve || 'avec catégorie ' || p_categorie);
  END p_chercher_par_categorie;
END pkg_gestion_articles;
