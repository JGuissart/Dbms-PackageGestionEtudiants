/*
PROCEDURE AJOUTER
	1. Contraintes structurelles du modèle relationnel
		1.1. intégrité de domaine
			l'ensemble des valeurs autorisées pour une colonne
			Une fois qu'on change le domaine, on change l'attribut de toutes les colonnes de ...
		1.2. intégrité d'entité/de relation
			ORA-00001 ==> DUP_VAL_ON_INDEX
			ORA-01400 ==> pas nommée, faire un PRAGMA EXCEPTION_INIT
		1.3. intégrité référentielle
			ORA-02291
	2. Contraintes applicatives
		cfr cahier de labo + énoncé
		ORA-02290
		
PROCEDURE MODIFIER
	1. Lire le tuple à modifier
	2. Afficher ce tuple
	3. Encoder les nouvelles valeurs
	4. UPDATE
	-- La méthode ci-dessus n'est pas bonne !!!
	1. Lire le tuple à modifier
	2. Poser un verrou
	3. Afficher ce tuple
	4. Encoder les nouvelles valeurs
	5. UPDATE
	-- Cette méthode n'est toujours pas bonne !!!
	1. Lire le tuple ancien à modifier
	2. Afficher ce tuple
	3. Encoder les nouvelles valeurs (tuple nouveau)
	4. Appel procédure modifier
	
	/!\ UTILISER DBMS_LOCK.SLEEP(n) ==> n étant le nombre de secondes
	
	
	procédure modifier (tupleAncien, tupleNouveau)
	{
		1. Lire (SELECT INTO FROM WHERE FOR UPDATE NOWAIT) le tuple courant
			ORA-54 ==> resource busy
			ORA- ==> NO_DATA_FOUND (si je tuple a été supprimé)
			==> Tuple modifié
		2. comparer tuple courant == tupleAncien (/!\/!\ NULL)
			SI <> ==> EXCEPTION
			SI == ==> MAJ + confirmation
	}
*/







