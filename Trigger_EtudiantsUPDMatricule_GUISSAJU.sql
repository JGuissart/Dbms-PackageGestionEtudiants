CREATE OR REPLACE TRIGGER EtudiantsUPDMatricule BEFORE INSERT OR DELETE OR UPDATE OF Nom, Prenom, Sexe, DateNaissance ON ETUDIANTS 
FOR EACH ROW 
BEGIN
	IF INSERTING THEN
		IF (:NEW.Sexe = 'M') THEN
			:NEW.Matricule := :NEW.Matricule || '1';
		ELSE
			:NEW.Matricule := :NEW.Matricule || '2';
		END IF;
		IF (LENGTH(:NEW.Nom) < 3) THEN
			:NEW.Nom := RPAD(:NEW.Nom, 3);
		END IF;
		IF (LENGTH(:NEW.Prenom) < 3) THEN
			:NEW.Prenom := RPAD(:NEW.Prenom, 3);
		END IF;
		:NEW.Matricule := :NEW.Matricule || TO_CHAR(:NEW.DateNaissance, 'YYMMDD') || UPPER(SUBSTR(:NEW.Nom, 1, 3) || SUBSTR(:NEW.Prenom, 1, 3));
	END IF;
	IF UPDATING THEN
		IF(:NEW.Nom <> :OLD.Nom OR :NEW.Prenom <> :OLD.Prenom OR :NEW.Sexe <> :OLD.Sexe OR :NEW.DateNaissance <> :OLD.DateNaissance) THEN
			:NEW.Matricule := '';
			IF (:NEW.Sexe = 'M') THEN
				:NEW.Matricule := :NEW.Matricule || '1';
			ELSE
				:NEW.Matricule := :NEW.Matricule || '2';
			END IF;
			IF (LENGTH(:NEW.Nom) < 3) THEN
				:NEW.Nom := RPAD(:NEW.Nom, 3);
			END IF;
			IF (LENGTH(:NEW.Prenom) < 3) THEN
				:NEW.Prenom := RPAD(:NEW.Prenom, 3);
			END IF;
			:NEW.Matricule := :NEW.Matricule || TO_CHAR(:NEW.DateNaissance, 'YYMMDD') || UPPER(SUBSTR(:NEW.Nom, 1, 3) || SUBSTR(:NEW.Prenom, 1, 3));
			UPDATE Parcours_he SET Matricule = :NEW.Matricule WHERE Matricule = :OLD.Matricule;
		END IF;
	END IF;
	IF DELETING THEN
		DELETE FROM Parcours_he_sess WHERE Matricule = :OLD.Matricule;
		DELETE FROM Parcours_he WHERE Matricule = :OLD.Matricule;
	END IF;
END;


CREATE OR REPLACE TRIGGER EtudiantsUPDMatricule2 BEFORE UPDATE OF Matricule ON Parcours_he
FOR EACH ROW
	BEGIN
		UPDATE Parcours_he_sess SET Matricule = :NEW.Matricule WHERE Matricule = :OLD.Matricule;
	END;