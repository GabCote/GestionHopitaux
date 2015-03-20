DROP TABLE TRAVAIL CASCADE CONSTRAINTS;
DROP TABLE PATIENT_ATTENTE CASCADE CONSTRAINTS;
DROP TABLE EVALUATION CASCADE CONSTRAINTS;
DROP TABLE SALLE_ATTENTE CASCADE CONSTRAINTS;
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP TABLE INFIRMIER CASCADE CONSTRAINTS;
DROP TABLE DEPARTEMENT CASCADE CONSTRAINTS;
DROP TABLE HOPITAL CASCADE CONSTRAINTS;
DROP TABLE INDIVIDU CASCADE CONSTRAINTS;

CREATE TABLE INDIVIDU
(id NUMBER(10),
nom VARCHAR2(30),
prenom VARCHAR2(30),
date_naissance DATE, 
no_ass_maladie VARCHAR2(16),
adresse VARCHAR2(80),
no_tel VARCHAR2(20),
CONSTRAINT individu_id_pk PRIMARY KEY (id));

CREATE TABLE HOPITAL
(nom_hopital VARCHAR2(80),
adresse VARCHAR2(80),
CONSTRAINT hopital_nom_adresse_pk 
PRIMARY KEY (nom_hopital)
);
CREATE TABLE DEPARTEMENT
(nom_departement VARCHAR2(30),
nom_hopital VARCHAR2(80),
CONSTRAINT departement_nom_departement_pk PRIMARY KEY (nom_departement, nom_hopital),
CONSTRAINT departement_hopital_fk FOREIGN KEY (nom_hopital) REFERENCES HOPITAL(nom_hopital)
);
CREATE TABLE INFIRMIER
(no_emp NUMBER(10),
date_embauche DATE NOT NULL,
date_fin DATE,
CONSTRAINT infirmier_no_emp_pk PRIMARY KEY(no_emp),
CONSTRAINT infirmier_no_emp_fk FOREIGN KEY (no_emp) REFERENCES INDIVIDU(id));

CREATE TABLE PATIENT
(no_patient NUMBER(10),
type_notif VARCHAR2(30),
nb_notif NUMBER(10),
CONSTRAINT patient_no_patient_pk PRIMARY KEY (no_patient),
CONSTRAINT patient_no_patient_fk FOREIGN KEY (no_patient) REFERENCES INDIVIDU(id));

CREATE TABLE SALLE_ATTENTE
(no_salle NUMBER(10),
departement VARCHAR2(30),
nom_hopital VARCHAR2(80),
CONSTRAINT salle_attente_no_salle_pk PRIMARY KEY(no_salle),
CONSTRAINT salle_attente_departement_fk FOREIGN KEY (departement, nom_hopital) REFERENCES DEPARTEMENT(nom_departement,nom_hopital)
);

CREATE TABLE EVALUATION
(no_patient NUMBER(10),
no_emp NUMBER(10),
date_evaluation DATE,
severite VARCHAR2(30),
CONSTRAINT severite_values
CHECK ( severite in ('Très urgent', 'Urgent', 'Normal', 'Ambulatoire', 'Ambulatoire externe') ),
CONSTRAINT evaluation_pk PRIMARY KEY(no_patient, no_emp, date_evaluation),
CONSTRAINT evaluation_no_patient_fk FOREIGN KEY (no_patient) REFERENCES PATIENT(no_patient),
CONSTRAINT evaluation_no_emp_fk FOREIGN KEY (no_emp) REFERENCES INFIRMIER(no_emp)
);

CREATE TABLE PATIENT_ATTENTE
(no_patient NUMBER(10),
no_salle NUMBER(10),
date_arrivee TIMESTAMP,
date_debut_service TIMESTAMP,
CONSTRAINT patient_attente_no_patient_pk PRIMARY KEY(no_patient, date_arrivee),
CONSTRAINT patient_attente_no_patient_fk FOREIGN KEY(no_patient) REFERENCES PATIENT(no_patient),
CONSTRAINT patient_attente_no_salle_fk FOREIGN KEY(no_salle) REFERENCES SALLE_ATTENTE(no_salle)
);

CREATE TABLE TRAVAIL 
(nom_departement VARCHAR2(30),
nom_hopital VARCHAR2(80),
no_emp NUMBER(10),
CONSTRAINT travail_departement_fk FOREIGN KEY(nom_departement, nom_hopital) REFERENCES DEPARTEMENT(nom_departement, nom_hopital),
CONSTRAINT travail_no_emp_fk FOREIGN KEY(no_emp) REFERENCES INFIRMIER (no_emp)
);
INSERT INTO HOPITAL VALUES ('Pierre-Boucher', '1333 Boulevard Jacque-Cartier E, Longueuil, QC');
INSERT INTO HOPITAL VALUES ('Charles Lemoyne', '3120 Boulevard Taschereau, Greenfield Park, QC');

INSERT INTO DEPARTEMENT VALUES ('Urgence', 'Pierre-Boucher');
INSERT INTO DEPARTEMENT VALUES ('Neurologie', 'Pierre-Boucher');

INSERT INTO SALLE_ATTENTE VALUES (900001, 'Urgence', 'Pierre-Boucher');
INSERT INTO INDIVIDU VALUES (100001, 'Cote', 'Gabriel', TO_DATE('1993/04/26', 'YYYY/MM/DD'), 'COTG93042567', '9825 boul. Leduc, Brossard, QC', '514-817-3393');
INSERT INTO INDIVIDU VALUES (100002,'Hamouda','Nedra', TO_DATE('1991/01/22', 'YYYY/MM/DD'), 'HAMN91042567', '9825 boul. quelquepart, Brossard, QC', '514-555-4444');

INSERT INTO INFIRMIER VALUES (100002,TO_DATE('2014/01/01', 'YYYY/MM/DD'), null);
INSERT INTO TRAVAIL VALUES ('Urgence', 'Pierre-Boucher', 100002);

INSERT INTO PATIENT VALUES (100001, 'SMS', 50);

INSERT INTO EVALUATION VALUES (100001, 100002 , TO_DATE('2015/01/01', 'YYYY/MM/DD'), 'Urgent');

INSERT INTO PATIENT_ATTENTE VALUES (100001, 900001 , TO_TIMESTAMP('2015/02/02 12:00', 'YYYY/MM/DD HH24:MI'), TO_TIMESTAMP('2015/02/02 13:30', 'YYYY/MM/DD HH24:MI'));

/*
SELECT * FROM HOPITAL;
SELECT * FROM INDIVIDU;