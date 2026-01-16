SET SERVEROUTPUT ON;

BEGIN
  p_afficher_msg('---- TESTS PACKAGE GESTION LIVRAISONS ----');

  INSERT INTO Postes (codeposte, libelle, indice) 
  VALUES (CONCAT('P00',seq_postes.NEXTVAL), 'Livreur', 1);
  INSERT INTO Postes (codeposte, libelle, indice) 
  VALUES (CONCAT('P00',seq_postes.NEXTVAL), 'Chef Livreur', 2);
  INSERT INTO Postes (codeposte, libelle, indice) 
  VALUES (CONCAT('P00',seq_postes.NEXTVAL), 'Administrateur', 3);


  INSERT INTO Personnel (idpers, nompers, prenompers, adrpers, villepers, telpers, d_embauche, login, motP, codeposte)
  VALUES (seq_personnel.NEXTVAL, 'Ben Sassi', 'Samir', 'Rue de l''Ariana 25', 'Ariana', 98888888, SYSDATE, 'samir.ben', 'pass1234', 'P001');
  INSERT INTO Personnel (idpers, nompers, prenompers, adrpers, villepers, telpers, d_embauche, login, motP, codeposte)
  VALUES (seq_personnel.NEXTVAL, 'Trabelsi', 'Karim', 'Rue de Tunis 50', 'Tunis', 97777777, SYSDATE, 'karim.trab', 'pass5678', 'P001');
  INSERT INTO Personnel (idpers, nompers, prenompers, adrpers, villepers, telpers, d_embauche, login, motP, codeposte)
  VALUES (seq_personnel.NEXTVAL, 'Jmaa', 'Hamza', 'Avenue Bourguiba 100', 'Ben Arous', 96666666, SYSDATE, 'hamza.jmaa', 'pass9012', 'P001');
  INSERT INTO Personnel (idpers, nompers, prenompers, adrpers, villepers, telpers, d_embauche, login, motP, codeposte)
  VALUES (seq_personnel.NEXTVAL, 'Ayouni', 'Fatima', 'Rue de Sfax 75', 'Sfax', 95555555, SYSDATE, 'fatima.ayo', 'passat01', 'P002');
  INSERT INTO Personnel (idpers, nompers, prenompers, adrpers, villepers, telpers, d_embauche, login, motP, codeposte)
  VALUES (seq_personnel.NEXTVAL, 'Admin', 'Système', 'Bureau Central', 'Tunis', 94444444, SYSDATE, 'admin', 'admin123', 'P003');
  

  pkg_gestion_livraisons.p_ajouter_livraison(1, SYSDATE, 1, 'avant_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(2, SYSDATE, 2, 'apres_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(3, SYSDATE + 1, 1, 'avant_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(4, SYSDATE + 1, 3, 'apres_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(5, SYSDATE + 2, 2, 'avant_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(6, SYSDATE + 2, 1, 'apres_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(7, SYSDATE + 3, 3, 'avant_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(8, SYSDATE + 3, 2, 'apres_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(9, SYSDATE + 4, 1, 'avant_livraison');
  pkg_gestion_livraisons.p_ajouter_livraison(10, SYSDATE + 4, 3, 'apres_livraison');

  pkg_gestion_livraisons.p_chercher_par_livreur_et_date(2, SYSDATE);
  
  -- Livraison 3 : changement de livreur de 1 (Samir) à 2 (Karim)
  pkg_gestion_livraisons.p_modifier_livraison(3, SYSDATE + 1, SYSDATE + 1, 2);
  
  -- Supprimer livraison 10 : passage commande en état AN (annulée)
  pkg_gestion_livraisons.p_supprimer_livraison(10, SYSDATE + 4);
  
  pkg_gestion_livraisons.p_chercher_par_commande(1);
  
  pkg_gestion_livraisons.p_chercher_par_livreur(1);

  pkg_gestion_livraisons.p_chercher_par_ville(75001);

  pkg_gestion_livraisons.p_chercher_par_date(SYSDATE);
  
  pkg_gestion_livraisons.p_chercher_par_livreur_et_date(2, SYSDATE);

END;

select * from personnel;
select * from LivraisonCom;

