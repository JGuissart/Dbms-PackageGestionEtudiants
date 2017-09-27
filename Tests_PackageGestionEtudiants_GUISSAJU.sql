/* *************************** TEST FONCTIONS RECHERCHER MATRICULE *************************** */

-- Test exception E_MatriculeNull
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher(NULL);
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

-- Résultat: ORA-20100: Le matricule passe en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test matricule inconnu
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('1950605GROHER');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

-- Résultat : ORA-20101: Le matricule 1950605GROHER n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test matricule connu
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('1920506GUIJUL');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

/*
Matricule : 1920506GUIJUL
Nom : GUISSART
Prenom : Julien
*/

/* *************************** TEST FONCTIONS RECHERCHER NOM PRENOM *************************** */

-- Test exception E_NomNull
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher(NULL, 'Julien');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

-- Résultat : ORA-20102: Le nom passe en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_PrenomNull
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('Guissart', NULL);
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

-- Résultat : ORA-20103: Le prenom passe en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception NO_DATA_FOUND

DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('Grosjean', 'Herve');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

-- Résultat : ORA-20104: Il n'existe pas d'etudiant s'appelant Herve Grosjean.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception TOO_MANY_ROWS

DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('Guissart', 'Julien');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

-- Résultat : ORA-20105: Il existe plusieurs etudiants dans la base qui s'appellent Julien Guissart.

-----------------------------------------------------------------------------------------------------------------------

-- Test Nom incomplet
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('Crai', 'Pakota');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

/*
Matricule : 1841230CRAPAK
Nom : Craig
Prenom : Pakota
*/

-----------------------------------------------------------------------------------------------------------------------

-- Test Nom complet
DECLARE
  UnEtudiant Etudiants%ROWTYPE;
BEGIN
  UnEtudiant := GestionEtudiants.Rechercher('Gourde', 'Julien');
  DBMS_OUTPUT.PUT_LINE ('Matricule : ' || UnEtudiant.Matricule);
  DBMS_OUTPUT.PUT_LINE ('Nom : ' || UnEtudiant.Nom);
  DBMS_OUTPUT.PUT_LINE ('Prenom : ' || UnEtudiant.Prenom);
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;

/*
Matricule : 1891219GOUJUL
Nom : Gourde
Prenom : Julien
*/

/* *************************** TEST PROCEDURE SUPPRIMER *************************** */

-- Test exception E_MatriculeNull

BEGIN
	GestionEtudiants.Supprimer(NULL);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20110: Le matricule passe en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_EtudiantNotFound

BEGIN
	GestionEtudiants.Supprimer('1920605GUIJUL');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20111: Il n'y a pas d'etudiant qui est sortit de l'ecole avec le matricule 1920605GUIJUL.

-----------------------------------------------------------------------------------------------------------------------

-- Test suppression correcte

BEGIN
	GestionEtudiants.Supprimer('1810619RENALP');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : /

/* *************************** TEST PROCEDURE AJOUTER *************************** */

-- Test exception ETUDIANTS_NOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_NOM_CK');
	unEtudiant.Nom := NULL;
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_NOM_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: Le nom de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PRENOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_PRENOM_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := NULL;
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_PRENOM_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: Le prenom de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_NATIONALITE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_NATIONALITE_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := NULL;
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_NATIONALITE_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: La nationalite de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_DATEENTREE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_DATEENTREE_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := NULL;
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_DATEENTREE_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: La date d'entree de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_DATENAISSANCE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_DATENAISSANCE_CK');
	unEtudiant.Matricule := '1891219GOUJUL';
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := NULL;
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_DATENAISSANCE_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: La date de naissance de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_LIEUNAISSANCE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_LIEUNAISSANCE_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := NULL;
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_LIEUNAISSANCE_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: Le lieu de naissance de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_CODEPAYSNAISSANCE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_CODEPAYSNAISSANCE_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := NULL;
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_CODEPAYSNAISSANCE_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: Le pays de naissance de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_LOCALITEDOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_LOCALITEDOM_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := NULL;
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_LOCALITEDOM_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: La localite de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_CODEPAYSDOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_CODEPAYSDOM_CK');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := NULL;
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_CODEPAYSDOM_CK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: Le pays de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSAGE (DateNaissance - DateEntrée >= 17)

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test CK_ETUDIANTSAGE');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/04 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test CK_ETUDIANTSAGE');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: L'etudiant doit avoir au minimum 17 ans lorsqu'il s'inscrit a l'ecole.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSSEXE

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test CK_ETUDIANTSSEXE');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'J';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test CK_ETUDIANTSSEXE');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: Le sexe (J) de l'etudiant est obligatoire et doit etre soit F soit M.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSETATCIVIL

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test CK_ETUDIANTSETATCIVIL');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'B';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test CK_ETUDIANTSETATCIVIL');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: L'etat civil (B) de l'etudiant doit etre soit C soit M.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSSITUATION

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test CK_ETUDIANTSSITUATION');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'R';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test CK_ETUDIANTSSITUATION');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20120: La situation (R) de l'etudiant doit etre soit I, soit E, soit D.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PAYSNATIONALITE_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_PAYSNATIONALITE_FK');
	unEtudiant.Nom := 'GUISSART';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'XYZ';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_PAYSNATIONALITE_FK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20121: La nationalite XYZ n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PAYSNAISSANCE_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_PAYSNAISSANCE_FK');
	unEtudiant.Nom := 'GUISSART';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'XYZ';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_PAYSNAISSANCE_FK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20121: Le code du pays de naissance XYZ n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PAYSDOM_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_PAYSDOM_FK');
	unEtudiant.Nom := 'GUISSART';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'XYZ';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_PAYSDOM_FK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20121: Le code du pays de domiciliation XYZ n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_COMMUNES_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test ETUDIANTS_COMMUNES_FK');
	unEtudiant.Nom := 'GUISSART';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '1234';
	unEtudiant.LocaliteDom := 'PARIS';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test ETUDIANTS_COMMUNES_FK');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20121: La localite PARIS et / ou le code postal 1234 n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception DUP_VAL_ON_INDEX

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test DUP_VAL_ON_INDEX');
	unEtudiant.Nom := 'GOURDE';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('10/07/09 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '5300';
	unEtudiant.LocaliteDom := 'ANDENNE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test DUP_VAL_ON_INDEX');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20122: Le matricule doit etre unique.

-----------------------------------------------------------------------------------------------------------------------

-- Test insertion correcte

DECLARE
	unEtudiant Etudiants%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Debut test insertion correcte');
	unEtudiant.Nom := 'GUISSART';
	unEtudiant.Prenom := 'Julien';
	unEtudiant.Nationalite := 'BEL';
	unEtudiant.EtatCivil := 'C';
	unEtudiant.Sexe := 'M';
	unEtudiant.Situation := 'D';
	unEtudiant.DateEntree := to_timestamp('20/08/12 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.DateNaissance := to_timestamp('06/05/92 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unEtudiant.LieuNaissance := 'Liege';
	unEtudiant.CodePaysNaissance := 'BEL';
	unEtudiant.DateDeces := NULL;
	unEtudiant.CodePostalDom := '4020';
	unEtudiant.LocaliteDom := 'WANDRE';
	unEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Ajouter(unEtudiant);
	DBMS_OUTPUT.PUT_LINE('Fin test insertion correcte');
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

SELECT *
FROM Etudiants
WHERE Matricule = '1920506GUIJUL';

-- Résultat : Debut test insertion correcte
--Fin test insertion correcte

/* *************************** TEST PROCEDURE MODIFIER *************************** */

-- Test exception E_ResourceBusy

--------------------- Session 1 ---------------------

DECLARE
  V_Etudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO V_Etudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL' FOR UPDATE NOWAIT;
	DBMS_LOCK.SLEEP(10);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--------------------- Session 2 ---------------------

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	unEtudiant.Matricule := '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	unNouvelEtudiant.Nom := 'GUISSART';
	unNouvelEtudiant.Prenom := 'Julien';
	unNouvelEtudiant.Nationalite := 'BEL';
	unNouvelEtudiant.EtatCivil := 'C';
	unNouvelEtudiant.Sexe := 'M';
	unNouvelEtudiant.Situation := 'D';
	unNouvelEtudiant.DateEntree := to_timestamp('20/08/12 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unNouvelEtudiant.DateNaissance := to_timestamp('06/05/92 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');
	unNouvelEtudiant.LieuNaissance := 'Liege';
	unNouvelEtudiant.CodePaysNaissance := 'BEL';
	unNouvelEtudiant.DateDeces := NULL;
	unNouvelEtudiant.CodePostalDom := '4020';
	unNouvelEtudiant.LocaliteDom := 'WANDRE';
	unNouvelEtudiant.CodePaysDom := 'BEL';
	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20130: Un autre utilisateur est entrain de modifier cet etudiant.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_DejaModif

--------------------- Session 1 ---------------------

DECLARE
  V_Etudiant Etudiants%ROWTYPE;
  V_NewEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO V_Etudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO V_NewEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	V_NewEtudiant.Nom := 'GUISSARD';
	GestionEtudiants.Modifier(V_Etudiant, V_NewEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--------------------- Session 2 ---------------------

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20131: Un autre utilisateur vient de modifier cet etudiant.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception NO_DATA_FOUND

--------------------- Session 1 ---------------------

DELETE FROM Etudiants WHERE Matricule = '1920506GUIJUL';
COMMIT;

--------------------- Session 2 ---------------------

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	unNouvelEtudiant.EtatCivil := 'C';
	
	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20134: Cet etudiant vient d'etre supprime.

-----------------------------------------------------------------------------------------------------------------------

-- Test modifier fonctionnel

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	unNouvelEtudiant.EtatCivil := 'M';
	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : /

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_NOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.Nom := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: Le nom de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PRENOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.Prenom := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: Le prenom de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_NATIONALITE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.Nationalite := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: La nationalite de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_DATEENTREE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.DateEntree := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: La date d'entree de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_DATENAISSANCE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.DateNaissance := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: La date de naissance de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_LIEUNAISSANCE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.LieuNaissance := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: Le lieu de naissance de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_CODEPAYSNAISSANCE_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.CodePaysNaissance := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: Le pays de naissance de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_LOCALITEDOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.LocaliteDom := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: La localite de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_CODEPAYSDOM_CK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.CodePaysDom := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: Le pays de l'etudiant est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSAGE (DateNaissance - DateEntrée >= 17)

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.DateEntree := to_timestamp('10/07/04 10:36:09,000000000','DD/MM/RR HH24:MI:SS,FF');
	unNouvelEtudiant.DateNaissance := to_timestamp('19/12/89 00:00:00,000000000','DD/MM/RR HH24:MI:SS,FF');  

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: L'etudiant doit avoir au minimum 17 ans lorsqu'il s'inscrit a l'ecole.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSSEXE

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.Sexe := NULL;

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: Le sexe () de l'etudiant est obligatoire et doit etre soit F soit M.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSETATCIVIL

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.EtatCivil := 'R';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: L'etat civil (R) de l'etudiant doit etre soit C soit M.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception CK_ETUDIANTSSITUATION

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.Situation := 'R';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20132: La situation (R) de l'etudiant doit etre soit I, soit E, soit D.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PAYSNATIONALITE_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.Nationalite := 'XYZ';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20133: La nationalite XYZ n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PAYSNAISSANCE_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.CodePaysNaissance := 'XYZ';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20133: Le code du pays de naissance XYZ n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_PAYSDOM_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.CodePaysDom := 'XYZ';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20133: Le code du pays de domiciliation XYZ n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception ETUDIANTS_COMMUNES_FK

DECLARE
	unEtudiant Etudiants%ROWTYPE;
	unNouvelEtudiant Etudiants%ROWTYPE;
BEGIN
	SELECT * INTO unEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	SELECT * INTO unNouvelEtudiant FROM Etudiants WHERE Matricule = '1920506GUIJUL';
	
	unNouvelEtudiant.LocaliteDom := 'PARIS';
	unNouvelEtudiant.CodePostalDom := '1234';

	GestionEtudiants.Modifier(unEtudiant, unNouvelEtudiant);
EXCEPTION
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat : ORA-20133: La localite PARIS et / ou le code postal 1234 n'existe pas.

-----------------------------------------------------------------------------------------------------------------------

/* *************************** TEST PROCEDURE LISTER *************************** */

-- Test exception E_AnscoInvalid

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister('2016', 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20141: L'annee scolaire passee en parametre (2016) doit etre inferieure a l'annee actuelle (2015).

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_RefformdetInvalide

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister('2007', 'coucou', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20142: La formation passee en parametre (coucou) doit n'est pas valide.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_RefformdetNull

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister('2007', NULL, lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20143: La formation passee en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_AnscoNull

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister(NULL, 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20144: L'annee scolaire passee en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_EtudiantsZero

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister('2008', 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20145: Pas de resultat trouve avec l'annee 2008 et la formation ECO-INF0.

-----------------------------------------------------------------------------------------------------------------------

-- Test fonctionnel

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister('2007', 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/*
	Résultat:

	1840925BLAJUN - Blaney Junien
	1870807ARPKYL - Arpin Kyle
	1861214MARMAT - Marks Mathurin
	1860803BARDAY - Barbin Daylan
	1880203MARVIT - Martial Vittorio
	1860201BARMAZ - Barbeau Mazhe
	1860128BARZIY - Bariteau Ziyad
	1870108MCLGER - McLure Geraldy
	1871208GASLIV - Gaston Livio
	1870310MCNKOR - McNamara Korioun
	1860309LALLAU - Lalonge Laurentino
*/

/* *************************** TEST PROCEDURE LISTER2 *************************** */

-- Test exception E_AnscoInvalid

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister2('2016', 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20150: L'annee scolaire passee en parametre (2016) doit etre inferieure a l'annee actuelle (2015).

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_RefformdetInvalide

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister2('2007', 'coucou', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20151: La formation passee en parametre (coucou) doit n'est pas valide.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_RefformdetNull

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister2('2007', NULL, lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20152: La formation passee en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_AnscoNull

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister2(NULL, 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20153: L'annee scolaire passee en parametre est obligatoire.

-----------------------------------------------------------------------------------------------------------------------

-- Test exception E_EtudiantsZero

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister2('2008', 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Résultat: ORA-20154: Pas de resultat trouve avec l'annee 2008 et la formation ECO-INF0.

-----------------------------------------------------------------------------------------------------------------------

-- Test fonctionnel

DECLARE
	lesEtudiants GestionEtudiants.TabEtudiants;
BEGIN
  GestionEtudiants.Lister2('2007', 'ECO-INF0', lesEtudiants);
  FOR i IN lesEtudiants.FIRST.. lesEtudiants.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(lesEtudiants(i).Matricule || ' - ' || lesEtudiants(i).Nom || ' ' || lesEtudiants(i).Prenom);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/*
	Résultat:

	1840925BLAJUN - Blaney Junien
	1870807ARPKYL - Arpin Kyle
	1861214MARMAT - Marks Mathurin
	1860803BARDAY - Barbin Daylan
	1880203MARVIT - Martial Vittorio
	1860201BARMAZ - Barbeau Mazhe
	1860128BARZIY - Bariteau Ziyad
	1870108MCLGER - McLure Geraldy
	1871208GASLIV - Gaston Livio
	1870310MCNKOR - McNamara Korioun
	1860309LALLAU - Lalonge Laurentino
*/
