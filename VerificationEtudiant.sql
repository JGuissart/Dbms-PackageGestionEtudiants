CREATE OR REPLACE FUNCTION VerificationEtudiant(P_Old IN Etudiants%ROWTYPE, P_Verif IN Etudiants%ROWTYPE)
RETURN BOOLEAN
AS
	v_UnEtudiant Etudiants%ROWTYPE;
	E_MatriculeNull EXCEPTION;
	BEGIN
		IF(P_MATRICULE IS NULL) THEN
			RAISE E_MatriculeNull;
		END IF;
		SELECT * INTO v_UnEtudiant
		FROM Etudiants
		WHERE Matricule = RechercherByMatricule.P_MATRICULE;
		RETURN v_UnEtudiant;
	EXCEPTION
		WHEN E_MatriculeNull THEN RAISE_APPLICATION_ERROR(-20101, 'Le matricule passe en parametre est NULL ...');
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20102, 'Le matricule ' || P_MATRICULE || ' n''existe pas ...');
			RETURN NULL;
		WHEN OTHERS THEN RAISE;
END RechercherByMatricule;