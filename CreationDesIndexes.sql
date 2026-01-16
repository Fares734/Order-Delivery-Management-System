
CREATE INDEX idx_commandes_noclt ON commandes(noclt);
CREATE INDEX idx_commandes_etat ON commandes(etatcde);
CREATE INDEX idx_commandes_date ON commandes(datecde);
CREATE INDEX idx_clients_nom ON clients(nomclt);
CREATE INDEX idx_ligcdes_nocde ON ligcdes(nocde);
CREATE INDEX idx_articles_designation ON articles(designation);
CREATE INDEX idx_articles_categorie ON articles(categorie);
CREATE INDEX idx_livraisoncom_date ON LivraisonCom(dateliv);


