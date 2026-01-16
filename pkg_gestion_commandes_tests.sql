SET SERVEROUTPUT ON

BEGIN
  p_afficher_msg('---- TESTS PACKAGE GESTION COMMANDES ----');

  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Younsi', 'Imed', '10 Rue de la Paix', 75001, 'Paris', 91111111, 'imed@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Salmi', 'Ahmed', '20 Rue du Commerce', 75002, 'Paris', 92222222, 'ahmed@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Jmaa', 'Fatima', '30 Avenue Maréchal', 13001, 'Marseille', 93333333, 'fatima@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Trabelsi', 'Karim', '40 Boulevard Victor', 69001, 'Lyon', 94444444, 'karim@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Ben Sassi', 'Samir', '50 Rue Saint André', 59000, 'Lille', 95555555, 'samir@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Ayouni', 'Leila', '60 Rue de Toulouse', 33000, 'Bordeaux', 96666666, 'leila@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Amara', 'Zainab', '70 Rue Nice', 06000, 'Nice', 97777777, 'zainab@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Mbarek', 'Hassan', '80 Rue Nantes', 44000, 'Nantes', 98888888, 'hassan@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Saidane', 'Rania', '90 Rue Strasbourg', 67000, 'Strasbourg', 89999999, 'rania@email.com');
  INSERT INTO Clients(noclt, nomclt, prenomclt, adrclt, code_postal, villeclt, telclt, adrmail)
  VALUES (seq_clients.NEXTVAL, 'Belkadi', 'Jalal', '100 Rue Montpellier', 34000, 'Montpellier', 80000000, 'jalal@email.com');


  pkg_gestion_commandes.p_ajouter_commande(1);
  pkg_gestion_commandes.p_ajouter_commande(2);
  pkg_gestion_commandes.p_ajouter_commande(3);
  pkg_gestion_commandes.p_ajouter_commande(4);
  pkg_gestion_commandes.p_ajouter_commande(5);
  pkg_gestion_commandes.p_ajouter_commande(6);
  pkg_gestion_commandes.p_ajouter_commande(7);
  pkg_gestion_commandes.p_ajouter_commande(8);
  pkg_gestion_commandes.p_ajouter_commande(9);
  pkg_gestion_commandes.p_ajouter_commande(10);


  pkg_gestion_commandes.p_ajouter_ligneCommande(1, 'Ar1', 5);
  pkg_gestion_commandes.p_ajouter_ligneCommande(2, 'Ar2', 3);
  pkg_gestion_commandes.p_ajouter_ligneCommande(3, 'Ar3', 7);
  pkg_gestion_commandes.p_ajouter_ligneCommande(4, 'Ar4', 2);
  pkg_gestion_commandes.p_ajouter_ligneCommande(5, 'Ar5', 4);
  pkg_gestion_commandes.p_ajouter_ligneCommande(6, 'Ar6', 6);
  pkg_gestion_commandes.p_ajouter_ligneCommande(7, 'Ar7', 2);
  pkg_gestion_commandes.p_ajouter_ligneCommande(8, 'Ar8', 3);
  pkg_gestion_commandes.p_ajouter_ligneCommande(9, 'Ar9', 5);
  pkg_gestion_commandes.p_ajouter_ligneCommande(10, 'Ar1', 1);


  -- Modifier la ligne de commande 1: passer quantité de 6 à 50 sachant que la quantite en stock 15
  pkg_gestion_commandes.p_modifier_ligneCommande(1, 'Ar1', 50);

  -- Modifier l'état commande 3 de EC  à LI (impossible)
  pkg_gestion_commandes.modifier_etat(3, 'LI');
  
  -- Annuler la commande 5 (qui est en PR)
  pkg_gestion_commandes.annuler_commande(5);

  pkg_gestion_commandes.p_chercher_commande_numero(1);
  
  pkg_gestion_commandes.p_chercher_commandes_client(1);
  
  pkg_gestion_commandes.p_modifier_ligneCommande(1, 'Ar1', 50);

  pkg_gestion_commandes.modifier_etat(1, 'PR');
  pkg_gestion_commandes.modifier_etat(2, 'PR');
  pkg_gestion_commandes.modifier_etat(3, 'PR');
  pkg_gestion_commandes.modifier_etat(4, 'PR');
  pkg_gestion_commandes.modifier_etat(5, 'PR');
  pkg_gestion_commandes.modifier_etat(6, 'PR');
  pkg_gestion_commandes.modifier_etat(7, 'PR');
  pkg_gestion_commandes.modifier_etat(8, 'PR');
  pkg_gestion_commandes.modifier_etat(9, 'PR');
  pkg_gestion_commandes.modifier_etat(10, 'PR');
  
END;
select * from clients;
select * from commandes;
select * from ligcdes;
select * from articles;
select * from hcommandesannulees;


