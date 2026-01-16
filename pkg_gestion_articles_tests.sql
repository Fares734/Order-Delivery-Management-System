SET SERVEROUTPUT ON;

BEGIN
 
  p_afficher_msg('----- TESTS PACKAGE GESTION ARTICLES -----');  
  pkg_gestion_articles.p_ajouter_article('Ordinateur Portable', 400, 899, 1, 'Info', 15);
  pkg_gestion_articles.p_ajouter_article('Souris Sans Fil', 8, 25, 1, 'Info', 50);
  pkg_gestion_articles.p_ajouter_article('Clavier Mécanique', 45, 120, 1, 'Info', 30);
  pkg_gestion_articles.p_ajouter_article('Chaise Bureau Ergonomique', 120, 350, 1, 'Mobilier', 8);
  pkg_gestion_articles.p_ajouter_article('Bureau en Bois', 180, 450, 1, 'Mobilier', 10);
  pkg_gestion_articles.p_ajouter_article('Lampe Bureau LED', 15, 60, 1, 'Éclairage', 40);
  pkg_gestion_articles.p_ajouter_article('Écran 24 Pouces', 150, 350, 1, 'Info', 12);
  pkg_gestion_articles.p_ajouter_article('Armoire Rangement', 200, 550, 1, 'Mobilier', 5);
  pkg_gestion_articles.p_ajouter_article('Casque Audio Bluetooth', 30, 150, 1, 'Électro', 25);
  pkg_gestion_articles.p_ajouter_article('Webcam HD 1080p', 25, 90, 1, 'Électro', 20);

  pkg_gestion_articles.p_ajouter_article('Webcam HD 1080p', 25, 90, 1, 'Électro', 20);
    
  p_afficher_msg('--- Modification d''un article valide ---');
  pkg_gestion_articles.p_modifier_article('Ar1', NULL, 400, 950, NULL, NULL);
  
  p_afficher_msg('--- Modification d''un article  invalide (prixV<prixA)---');
  pkg_gestion_articles.p_modifier_article('Ar1', NULL, 400, 350, NULL, NULL);
  
  p_afficher_msg('--- Recherche par désignation (Chaise Bureau Ergonomique) ---');
  pkg_gestion_articles.p_chercher_par_designation('Chaise Bureau Ergonomique');
  
  p_afficher_msg('--- Recherche par code (Ar2 - Souris) ---');
  pkg_gestion_articles.p_chercher_par_code('Ar2');
  

  p_afficher_msg('--- Recherche par désignation (Chaise Bureau Ergonomique) ---');
  pkg_gestion_articles.p_chercher_par_designation('Chaise Bureau Ergonomique');
  
  p_afficher_msg('--- Recherche par catégorie (Informatique) ---');
  pkg_gestion_articles.p_chercher_par_categorie('Informatique');
  
  p_afficher_msg('--- Suppression d''un article (Ar10 - Webcam) ---');
  pkg_gestion_articles.p_supprimer_article('Ar10');
  
END;
select * from articles;
select * from commandes;
select * from ligcdes;
