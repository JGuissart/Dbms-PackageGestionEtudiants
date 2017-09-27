/* ********************************* PACKAGE SPECIFICATION ********************************* */

CREATE OR REPLACE PACKAGE GestionEtudiants IS
	TYPE R_Etudiants IS RECORD
	(
		Matricule Etudiants.Matricule%TYPE,
		Nom Etudiants.Nom%TYPE,
		Prenom Etudiants.Prenom%TYPE
	);
	TYPE TabEtudiants IS TABLE OF R_Etudiants INDEX BY PLS_INTEGER;
	FUNCTION Rechercher(P_MATRICULE IN Etudiants.Matricule%TYPE) RETURN Etudiants%ROWTYPE;
	FUNCTION Rechercher(P_NOM Etudiants.Nom%TYPE, P_PRENOM Etudiants.Prenom%TYPE) RETURN Etudiants%ROWTYPE;
	PROCEDURE Supprimer (P_MATRICULE Etudiants.Matricule%TYPE);
	PROCEDURE Ajouter(P_ETUDIANT Etudiants%ROWTYPE);
	PROCEDURE Modifier(P_OLD IN Etudiants%ROWTYPE, P_NEW IN Etudiants%ROWTYPE);
	PROCEDURE Lister(P_ANSCO IN Parcours_he.Ansco%TYPE, P_REFFORMDET IN Parcours_he.Refformdet%TYPE, P_TABETUDIANTS IN OUT TabEtudiants);
	PROCEDURE Lister2(P_ANSCO IN Parcours_he.Ansco%TYPE, P_REFFORMDET IN Parcours_he.Refformdet%TYPE, P_TABETUDIANTS IN OUT TabEtudiants);
END GestionEtudiants;

/* ********************************* PACKAGE BODY ********************************* */

CREATE OR REPLACE PACKAGE BODY GestionEtudiants AS
	FUNCTION Rechercher(P_MATRICULE IN Etudiants.Matricule%TYPE) RETURN Etudiants%ROWTYPE AS
		v_UnEtudiant Etudiants%ROWTYPE;
		E_MatriculeNull EXCEPTION;
		BEGIN
			IF(P_MATRICULE IS NULL) THEN
				RAISE E_MatriculeNull;
			END IF;
			SELECT * INTO v_UnEtudiant
			FROM Etudiants
			WHERE Matricule = Rechercher.P_MATRICULE;
			RETURN v_UnEtudiant;
		EXCEPTION
			WHEN E_MatriculeNull THEN RAISE_APPLICATION_ERROR(-20100, 'Le matricule passe en parametre est obligatoire.');
			WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20101, 'Le matricule ' || P_MATRICULE || ' n''existe pas.');
				RETURN NULL;
			WHEN OTHERS THEN RAISE;
	END Rechercher;

	FUNCTION Rechercher(P_NOM Etudiants.Nom%TYPE, P_PRENOM Etudiants.Prenom%TYPE)
	RETURN Etudiants%ROWTYPE
	AS
		v_UnEtudiant Etudiants%ROWTYPE;
		E_NomNull EXCEPTION;
		E_PrenomNull EXCEPTION;
		BEGIN
			IF(Rechercher.P_NOM IS NULL) THEN
				RAISE E_NomNull;
			END IF;
			IF(Rechercher.P_PRENOM IS NULL) THEN
				RAISE E_PrenomNull;
			END IF;
			SELECT * INTO v_UnEtudiant
			FROM Etudiants
			WHERE UPPER(Nom) LIKE UPPER(Rechercher.P_Nom || '%')
			AND UPPER(Prenom) LIKE UPPER(Rechercher.P_PRENOM || '%');
			RETURN v_UnEtudiant;
		EXCEPTION
			WHEN E_NomNull THEN RAISE_APPLICATION_ERROR(-20102, 'Le nom passe en parametre est obligatoire.');
			WHEN E_PrenomNull THEN RAISE_APPLICATION_ERROR(-20103, 'Le prenom passe en parametre est obligatoire.');
			WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20104, 'Il n''existe pas d''etudiant s''appelant ' || P_PRENOM || ' ' || P_NOM || '.');
				RETURN NULL;
			WHEN TOO_MANY_ROWS THEN
				RAISE_APPLICATION_ERROR(-20105, 'Il existe plusieurs etudiants dans la base qui s''appellent ' || P_PRENOM || ' ' || P_NOM || '.');
				RETURN NULL;
			WHEN OTHERS THEN RAISE;
				RETURN NULL;
	END Rechercher;

	PROCEDURE Supprimer (P_MATRICULE Etudiants.Matricule%TYPE) AS
		UnEtudiant Parcours_he%ROWTYPE;
		E_MatriculeNull EXCEPTION;
		E_EtudiantNotFound EXCEPTION;
	  BEGIN
		IF(P_MATRICULE IS NULL) THEN
			RAISE E_MatriculeNull;
		END IF;
		DELETE FROM Etudiants
		WHERE Matricule =
		(
			SELECT Matricule
			FROM Parcours_he t1
			WHERE datesortie IS NOT NULL
			AND Ansco =
			(
			  SELECT MAX(Ansco)
			  FROM Parcours_he t2
			  WHERE t1.Matricule = t2.Matricule
			)
			AND t1.Matricule = Supprimer.P_MATRICULE
		);
		IF (SQL%NOTFOUND) THEN
			RAISE E_EtudiantNotFound;
		END IF;
		COMMIT;
	  EXCEPTION
		WHEN E_MatriculeNull THEN
			RAISE_APPLICATION_ERROR(-20110, 'Le matricule passe en parametre est obligatoire.');
		WHEN E_EtudiantNotFound THEN
			RAISE_APPLICATION_ERROR(-20111, 'Il n''y a pas d''etudiant qui est sortit de l''ecole avec le matricule ' || Supprimer.P_MATRICULE || '.');
		WHEN OTHERS THEN RAISE;
	END Supprimer;

	PROCEDURE Ajouter(P_ETUDIANT Etudiants%ROWTYPE) AS
		E_EtudiantsContrainteApp EXCEPTION;
		E_EtudiantsContrainteRef EXCEPTION;
		PRAGMA EXCEPTION_INIT(E_EtudiantsContrainteApp, -2290);
		PRAGMA EXCEPTION_INIT(E_EtudiantsContrainteRef, -2291);
		BEGIN
			INSERT INTO Etudiants VALUES P_ETUDIANT;
			COMMIT;
		EXCEPTION
			WHEN E_EtudiantsContrainteApp THEN
			CASE
				WHEN INSTR(SQLERRM, 'ETUDIANTS_NOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'Le nom de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PRENOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'Le prenom de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_NATIONALITE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'La nationalite de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_DATEENTREE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'La date d''entree de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_DATENAISSANCE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'La date de naissance de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_LIEUNAISSANCE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'Le lieu de naissance de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_CODEPAYSNAISSANCE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'Le pays de naissance de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_LOCALITEDOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'La localite de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_CODEPAYSDOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'Le pays de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSAGE') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'L''etudiant doit avoir au minimum 17 ans lorsqu''il s''inscrit a l''ecole.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSSEXE') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'Le sexe (' || P_ETUDIANT.Sexe || ') de l''etudiant est obligatoire et doit etre soit F soit M.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSETATCIVIL') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'L''etat civil (' || P_ETUDIANT.EtatCivil || ') de l''etudiant doit etre soit C soit M.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSSITUATION') > 0
					THEN RAISE_APPLICATION_ERROR(-20120, 'La situation (' || P_ETUDIANT.Situation || ') de l''etudiant doit etre soit I, soit E, soit D.');
			END CASE;
		WHEN E_EtudiantsContrainteRef THEN
			CASE
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PAYSNATIONALITE_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20121, 'La nationalite ' || P_ETUDIANT.Nationalite || ' n''existe pas.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PAYSNAISSANCE_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20121, 'Le code du pays de naissance ' || P_ETUDIANT.CodePaysNaissance || ' n''existe pas.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PAYSDOM_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20121, 'Le code du pays de domiciliation ' || P_ETUDIANT.CodePaysDom || ' n''existe pas.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_COMMUNES_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20121, 'La localite ' || P_ETUDIANT.LocaliteDom || ' et / ou le code postal ' || P_ETUDIANT.CodePostalDom || ' n''existe pas.');
			END CASE;
		WHEN DUP_VAL_ON_INDEX
			THEN RAISE_APPLICATION_ERROR(-20122, 'Le matricule doit etre unique.');
		WHEN OTHERS THEN RAISE;
	END Ajouter;

	PROCEDURE Modifier(P_Old IN Etudiants%ROWTYPE, P_New IN Etudiants%ROWTYPE)
	IS
		E_EtudiantsContrainteApp EXCEPTION;
		E_EtudiantsContrainteRef EXCEPTION;
		E_ResourceBusy EXCEPTION;
		PRAGMA EXCEPTION_INIT(E_EtudiantsContrainteApp, -2290);
		PRAGMA EXCEPTION_INIT(E_EtudiantsContrainteRef, -2291);
		PRAGMA EXCEPTION_INIT(E_ResourceBusy, -54);
		E_DejaModif EXCEPTION;
		E_ModifMatricule EXCEPTION;
		V_Verif Etudiants%ROWTYPE;
		V_Boucle INTEGER := 0;
	BEGIN		
		WHILE V_Boucle < 3 LOOP	
			BEGIN
				V_Boucle := (V_Boucle + 1);
				SELECT * INTO V_Verif FROM Etudiants WHERE Matricule = P_Old.Matricule FOR UPDATE NOWAIT;
				V_Boucle := 3;
			EXCEPTION
				WHEN E_ResourceBusy THEN 
					IF(V_Boucle = 3) THEN
						RAISE;
					END IF;
					DBMS_LOCK.SLEEP(5);
				WHEN OTHERS THEN RAISE;
			END;
		END LOOP;
		
		IF(P_Old.Matricule <> V_Verif.Matricule	OR
		P_Old.Nom <> V_Verif.Nom OR
		P_Old.Prenom <> V_Verif.Prenom OR
		P_Old.Nationalite <> V_Verif.Nationalite OR
		COALESCE(P_Old.EtatCivil, 'NULL') <> COALESCE(V_Verif.EtatCivil, 'NULL') OR
		P_Old.Sexe <> V_Verif.Sexe OR
		COALESCE(P_Old.Situation, 'NULL') <> COALESCE(V_Verif.Situation, 'NULL') OR
		P_Old.DateEntree <> V_Verif.DateEntree OR
		P_Old.DateNaissance <> V_Verif.DateNaissance OR
		P_Old.LieuNaissance <> V_Verif.LieuNaissance OR
		P_Old.CodePaysNaissance <> V_Verif.CodePaysNaissance OR
		COALESCE(P_Old.DateDeces, CURRENT_DATE) <> COALESCE(V_Verif.DateDeces, CURRENT_DATE) OR
		COALESCE(P_Old.CodePostalDom, 'NULL') <> COALESCE(V_Verif.CodePostalDom, 'NULL') OR
		P_Old.LocaliteDom <> V_Verif.LocaliteDom OR
		P_Old.CodePaysDom <> V_Verif.CodePaysDom) THEN
			RAISE E_DejaModif;
		END IF;
		
		UPDATE Etudiants SET ROW = P_New WHERE Matricule = P_Old.Matricule;
		COMMIT;
	EXCEPTION
		WHEN E_ResourceBusy THEN RAISE_APPLICATION_ERROR(-20130, 'Un autre utilisateur est entrain de modifier cet etududiant.');
		WHEN E_DejaModif THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20131, 'Un autre utilisateur vient de modifier cet etudiant.');
		WHEN E_EtudiantsContrainteApp THEN
			CASE
				WHEN INSTR(SQLERRM, 'ETUDIANTS_NOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'Le nom de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PRENOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'Le prenom de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_NATIONALITE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'La nationalite de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_DATEENTREE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'La date d''entree de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_DATENAISSANCE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'La date de naissance de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_LIEUNAISSANCE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'Le lieu de naissance de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_CODEPAYSNAISSANCE_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'Le pays de naissance de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_LOCALITEDOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'La localite de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_CODEPAYSDOM_CK') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'Le pays de l''etudiant est obligatoire.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSAGE') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'L''etudiant doit avoir au minimum 17 ans lorsqu''il s''inscrit a l''ecole.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSSEXE') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'Le sexe (' || P_NEW.Sexe || ') de l''etudiant est obligatoire et doit etre soit F soit M.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSETATCIVIL') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'L''etat civil (' || P_NEW.EtatCivil || ') de l''etudiant doit etre soit C soit M.');
				WHEN INSTR(SQLERRM, 'CK_ETUDIANTSSITUATION') > 0
					THEN RAISE_APPLICATION_ERROR(-20132, 'La situation (' || P_NEW.Situation || ') de l''etudiant doit etre soit I, soit E, soit D.');
			END CASE;
		WHEN E_EtudiantsContrainteRef THEN
			CASE
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PAYSNATIONALITE_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20133, 'La nationalite ' || P_NEW.Nationalite || ' n''existe pas.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PAYSNAISSANCE_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20133, 'Le code du pays de naissance ' || P_NEW.CodePaysNaissance || ' n''existe pas.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_PAYSDOM_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20133, 'Le code du pays de domiciliation ' || P_NEW.CodePaysDom || ' n''existe pas.');
				WHEN INSTR(SQLERRM, 'ETUDIANTS_COMMUNES_FK') > 0
					THEN RAISE_APPLICATION_ERROR(-20133, 'La localite ' || P_NEW.LocaliteDom || ' et / ou le code postal ' || P_NEW.CodePostalDom || ' n''existe pas.');
			END CASE;
		WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20134, 'Cet etudiant vient d''etre supprime.');
		WHEN OTHERS THEN RAISE;
	END Modifier;
	
	-- Curseur explicite
	PROCEDURE LISTER(P_ANSCO IN Parcours_he.Ansco%TYPE, P_REFFORMDET IN Parcours_he.Refformdet%TYPE, P_TABETUDIANTS IN OUT TabEtudiants) AS 
		CURSOR c_lesEtudiants(P_ANSCO Parcours_he.Ansco%TYPE, P_REFFORMDET Parcours_he.Refformdet%TYPE) IS
			SELECT DISTINCT t1.Matricule, Nom, Prenom
			FROM Etudiants t1, Parcours_he t2, Parcours_he_sess t3
			WHERE t1.Matricule = t2.Matricule
			AND t2.Matricule = t3.Matricule
			AND Refformdet = P_REFFORMDET
			AND Annetud = '3'
			AND t2.Ansco = P_ANSCO
			AND Resultat = 'R60'
			AND t1.Matricule IN
			(
				SELECT DISTINCT Matricule
				FROM Parcours_he_sess
				WHERE Mention IN('DIS','GRD','PGD')
			)
			AND Mention NOT IN ('DIS','GRD','PGD');
		TYPE t_refformdet IS TABLE OF Formations_det.Refformdet%TYPE;
		v_tabRefformdet t_refformdet;
		v_UnEtudiant R_Etudiants;
		E_RefformdetInvalide EXCEPTION;
		E_AnscoInvalide EXCEPTION;
		E_RefformdetNull EXCEPTION;
		E_AnscoNull EXCEPTION;
		E_EtudiantsZero EXCEPTION;
		BEGIN
			SELECT Refformdet BULK COLLECT INTO v_tabRefformdet
			FROM Formations_det;
			IF(LISTER.P_ANSCO > EXTRACT (YEAR FROM CURRENT_DATE)) THEN
				RAISE E_AnscoInvalide;
			END IF;
			IF(LISTER.P_REFFORMDET NOT MEMBER OF v_tabRefformdet) THEN
				RAISE E_RefformdetInvalide;
			END IF;
			IF(LISTER.P_REFFORMDET IS NULL) THEN
				RAISE E_RefformdetNull;
			END IF;
			IF(LISTER.P_ANSCO IS NULL) THEN
				RAISE E_AnscoNull;
			END IF;
			OPEN c_lesEtudiants(P_ANSCO, P_REFFORMDET);
			FETCH c_lesEtudiants BULK COLLECT INTO P_TABETUDIANTS;
			CLOSE c_lesEtudiants;
			IF(P_TABETUDIANTS.COUNT = 0) THEN
				RAISE E_EtudiantsZero;
			END IF;
		EXCEPTION
			WHEN INVALID_CURSOR THEN RAISE_APPLICATION_ERROR(-20140, 'Le curseur ne s''est pas ouvert.');
			WHEN E_AnscoInvalide THEN RAISE_APPLICATION_ERROR(-20141, 'L''annee scolaire passee en parametre (' || P_ANSCO || ') doit etre inferieure a l''annee actuelle (' || EXTRACT(YEAR FROM CURRENT_DATE) || ').');
			WHEN E_RefformdetInvalide THEN RAISE_APPLICATION_ERROR(-20142, 'La formation passee en parametre (' || P_REFFORMDET || ') doit n''est pas valide.');
			WHEN E_RefformdetNull THEN RAISE_APPLICATION_ERROR(-20143, 'La formation passee en parametre est obligatoire.');
			WHEN E_AnscoNull THEN RAISE_APPLICATION_ERROR(-20144, 'L''annee scolaire passee en parametre est obligatoire.');
			WHEN E_EtudiantsZero THEN RAISE_APPLICATION_ERROR(-20145, 'Pas de resultat trouve avec l''annee ' || P_ANSCO || ' et la formation ' || P_REFFORMDET || '.');
			WHEN OTHERS THEN
				IF(c_lesEtudiants%ISOPEN) THEN
					CLOSE c_lesEtudiants;
				END IF;
	END LISTER;

	-- Curseur FOR implicite
	PROCEDURE LISTER2(P_ANSCO IN Parcours_he.Ansco%TYPE, P_REFFORMDET IN Parcours_he.Refformdet%TYPE, P_TABETUDIANTS IN OUT TabEtudiants) AS 
		TYPE t_refformdet IS TABLE OF Formations_det.Refformdet%TYPE;
		v_tabRefformdet t_refformdet;
		v_UnEtudiant R_Etudiants;
		E_RefformdetInvalide EXCEPTION;
		E_AnscoInvalide EXCEPTION;
		E_RefformdetNull EXCEPTION;
		E_AnscoNull EXCEPTION;
		E_EtudiantsZero EXCEPTION;
		i NUMBER := 1;
		BEGIN
			SELECT Refformdet BULK COLLECT INTO v_tabRefformdet
			FROM Formations_det;
			IF(LISTER2.P_ANSCO > EXTRACT (YEAR FROM CURRENT_DATE)) THEN
				RAISE E_AnscoInvalide;
			END IF;
			IF(LISTER2.P_REFFORMDET NOT MEMBER OF v_tabRefformdet) THEN
				RAISE E_RefformdetInvalide;
			END IF;
			IF(LISTER2.P_REFFORMDET IS NULL) THEN
				RAISE E_RefformdetNull;
			END IF;
			IF(LISTER2.P_ANSCO IS NULL) THEN
				RAISE E_AnscoNull;
			END IF;
			
			FOR unEtudiant IN (SELECT DISTINCT t1.Matricule, Nom, Prenom
								FROM Etudiants t1, Parcours_he t2, Parcours_he_sess t3
								WHERE t1.Matricule = t2.Matricule
								AND t2.Matricule = t3.Matricule
								AND Refformdet = P_REFFORMDET
								AND Annetud = '3'
								AND t2.Ansco = P_ANSCO
								AND Resultat = 'R60'
								AND t1.Matricule IN
								(
									SELECT DISTINCT Matricule
									FROM Parcours_he_sess
									WHERE Mention IN('DIS','GRD','PGD')
								)
								AND Mention NOT IN ('DIS','GRD','PGD')
							) LOOP
				P_TABETUDIANTS(i) := unEtudiant;
				i := i + 1;
			END LOOP;
			IF(P_TABETUDIANTS.COUNT = 0) THEN
				RAISE E_EtudiantsZero;
			END IF;
		EXCEPTION
			WHEN E_AnscoInvalide THEN RAISE_APPLICATION_ERROR(-20150, 'L''annee scolaire passee en parametre (' || P_ANSCO || ') doit etre inferieure a l''annee actuelle (' || EXTRACT(YEAR FROM CURRENT_DATE) || ').');
			WHEN E_RefformdetInvalide THEN RAISE_APPLICATION_ERROR(-20151, 'La formation passee en parametre (' || P_REFFORMDET || ') doit n''est pas valide.');
			WHEN E_RefformdetNull THEN RAISE_APPLICATION_ERROR(-20152, 'La formation passee en parametre est obligatoire.');
			WHEN E_AnscoNull THEN RAISE_APPLICATION_ERROR(-20153, 'L''annee scolaire passee en parametre est obligatoire.');
			WHEN E_EtudiantsZero THEN RAISE_APPLICATION_ERROR(-20154, 'Pas de resultat trouve avec l''annee ' || P_ANSCO || ' et la formation ' || P_REFFORMDET || '.');
			WHEN OTHERS THEN RAISE;
	END LISTER2;
END GestionEtudiants;