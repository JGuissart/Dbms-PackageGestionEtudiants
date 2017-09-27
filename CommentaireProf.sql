/*
PROCEDURE AJOUTER
	1. Contraintes structurelles du mod�le relationnel
		1.1. int�grit� de domaine
			l'ensemble des valeurs autoris�es pour une colonne
			Une fois qu'on change le domaine, on change l'attribut de toutes les colonnes de ...
		1.2. int�grit� d'entit�/de relation
			ORA-00001 ==> DUP_VAL_ON_INDEX
			ORA-01400 ==> pas nomm�e, faire un PRAGMA EXCEPTION_INIT
		1.3. int�grit� r�f�rentielle
			ORA-02291
	2. Contraintes applicatives
		cfr cahier de labo + �nonc�
		ORA-02290
		
PROCEDURE MODIFIER
	1. Lire le tuple � modifier
	2. Afficher ce tuple
	3. Encoder les nouvelles valeurs
	4. UPDATE
	-- La m�thode ci-dessus n'est pas bonne !!!
	1. Lire le tuple � modifier
	2. Poser un verrou
	3. Afficher ce tuple
	4. Encoder les nouvelles valeurs
	5. UPDATE
	-- Cette m�thode n'est toujours pas bonne !!!
	1. Lire le tuple ancien � modifier
	2. Afficher ce tuple
	3. Encoder les nouvelles valeurs (tuple nouveau)
	4. Appel proc�dure modifier
	
	/!\ UTILISER DBMS_LOCK.SLEEP(n) ==> n �tant le nombre de secondes
	
	
	proc�dure modifier (tupleAncien, tupleNouveau)
	{
		1. Lire (SELECT INTO FROM WHERE FOR UPDATE NOWAIT) le tuple courant
			ORA-54 ==> resource busy
			ORA- ==> NO_DATA_FOUND (si je tuple a �t� supprim�)
			==> Tuple modifi�
		2. comparer tuple courant == tupleAncien (/!\/!\ NULL)
			SI <> ==> EXCEPTION
			SI == ==> MAJ + confirmation
	}
*/







