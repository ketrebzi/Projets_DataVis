-- Sélectionner la base de données 'URGENCES'
SET SEARCH_PATH="UR_OPE";

-- Supprimer les tables existantes avec CASCADE
DROP TABLE IF EXISTS responses CASCADE;
DROP TABLE IF EXISTS scores CASCADE;
DROP TABLE IF EXISTS choices CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS questionnaires CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Créer la table 'users'
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Créer la table 'questionnaires'
CREATE TABLE questionnaires (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Créer la table 'questions'
CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    questionnaire_id INT NOT NULL REFERENCES questionnaires(id),
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL -- e.g., 'text', 'multiple_choice', 'number', etc.
);

-- Créer la table 'choices'
CREATE TABLE choices (
    id SERIAL PRIMARY KEY,
    question_id INT NOT NULL REFERENCES questions(id),
    choice_text TEXT NOT NULL
);


CREATE TABLE "UR_OPE".responses (
    user_id UUID NOT NULL,
    questionnaire_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, questionnaire_id, question_id)
);





-- Créer la table 'scores'
CREATE TABLE scores (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    questionnaire_id INT NOT NULL REFERENCES questionnaires(id),
    score INT NOT NULL,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insérer les questionnaires
INSERT INTO questionnaires (name, description) VALUES
('Informations Generales', 'Informations générales pour une première prise en charge aux urgences'),
('Douleurs Thoraciques', 'Évaluer les symptômes et les facteurs de risque associés aux douleurs thoraciques'),
('Embolie Pulmonaire', 'Évaluation des antécédents, symptômes cliniques, signes vitaux et examens paracliniques'),
('Depistage des Douleurs Abdominales', 'Évaluer la localisation, l''intensité et les symptômes associés'),
('Depistage des Cephalees', 'Dépistage des Céphalées'),
('Depistage des Difficultes Respiratoires', 'Dépistage des Difficultés Respiratoires'),
('Depistage de la Pancreatite', 'Dépistage de la Pancréatite'),
('Depistage de la Meningite', 'Dépistage de la Méningite'),
('Depistage de l''Exacerbation de BPCO', 'Dépistage de l''Exacerbation de BPCO');

-- Insérer les questions pour le questionnaire sur les urgences générales
INSERT INTO questions (questionnaire_id, question_text, question_type) VALUES
(1, 'Nom :', 'text'),
(1, 'Prénom :', 'text'),
(1, 'Date de naissance :', 'date'),
(1, 'Sexe :', 'multiple_choice'),
(1, 'Adresse :', 'text'),
(1, 'Numéro de téléphone :', 'text'),
(1, 'Personne à contacter en cas d''urgence (nom et relation) :', 'text'),
(1, 'Numéro de téléphone de la personne à contacter :', 'text'),
(1, 'Avez-vous des antécédents de maladies chroniques ?', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Avez-vous déjà été hospitalisé(e) ?', 'multiple_choice'),
(1, 'Si oui, précisez la raison et la date :', 'text'),
(1, 'Avez-vous des antécédents chirurgicaux ?', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Prenez-vous des médicaments actuellement ?', 'multiple_choice'),
(1, 'Si oui, listez les médicaments et les doses :', 'text'),
(1, 'Avez-vous des allergies ?', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Avez-vous des antécédents familiaux de maladies graves (ex. : maladies cardiaques, diabète, cancer) ?', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Fumez-vous ?', 'multiple_choice'),
(1, 'Si oui, combien de cigarettes par jour et depuis combien de temps ?', 'text'),
(1, 'Consommez-vous de l''alcool ?', 'multiple_choice'),
(1, 'Si oui, quelle quantité et à quelle fréquence ?', 'text'),
(1, 'Consommez-vous des drogues ?', 'multiple_choice'),
(1, 'Si oui, précisez le type et la fréquence :', 'text'),
(1, 'Faites-vous régulièrement de l''exercice physique ?', 'multiple_choice'),
(1, 'Si oui, précisez d''exercice et la fréquence :', 'text'),
(1, 'Quel est votre régime alimentaire habituel ?', 'multiple_choice'),
(1, 'Si déséquilibré, précisez :', 'text'),
(1, 'Quel est le motif principal de votre venue aux urgences aujourd''hui ? ', 'text'),
(1, 'Depuis combien de temps ressentez-vous ces symptômes ? :', 'text'),
(1, 'Décrivez vos symptômes en détail :', 'text'),
(1, 'Avez-vous ressenti une douleur intense ?', 'multiple_choice'),
(1, 'Si oui, sur une échelle de 1 à 10, comment évalueriez-vous cette douleur ?', 'text'),
(1, 'Avez-vous ressenti des symptômes associés ? :', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Quelle est votre profession ?', 'text'),
(1, 'Avez-vous des conditions de travail spécifiques pouvant impacter votre santé ? :', 'multiple_choice'),
(1, 'Vivez-vous seul(e) ou avec quelqu''un ?:', 'multiple_choice'),
(1, 'Si avec quelqu''un, précisez la relation : :', 'text'),
(1, 'Avez-vous des enfants ? :', 'multiple_choice'),
(1, 'Si oui, combien et quel âge ont-ils ?:', 'text'),
(1, 'Avez-vous une couverture sociale/mutuelle ?:', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Avez-vous des troubles du sommeil ? :', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Avez-vous des troubles de l''humeur ou des antécédents de problèmes psychiatriques ? :', 'multiple_choice'),
(1, 'Si oui, précisez :', 'text'),
(1, 'Avez-vous consulté un médecin récemment pour ces symptômes ou d''autres problèmes de santé ? :', 'multiple_choice'),
(1, 'Si oui, précisez la raison et la date :', 'text'),
(1, 'Y a-t-il des informations supplémentaires que vous souhaitez partager avec nous concernant votre santé ou votre situation actuelle ? :', 'text');




-- Insérer les choix pour les questions du questionnaire sur les urgences générales
INSERT INTO choices (question_id, choice_text) VALUES
(4, 'Masculin'),
(4, 'Féminin'),
(4, 'Autre'),
(9, 'Oui'),
(9, 'Non'),
(11, 'Oui'),
(11, 'Non'),
(13, 'Oui'),
(13, 'Non'),
(15, 'Oui'),
(15, 'Non'),
(17, 'Oui'),
(17, 'Non'),
(19, 'Oui'),
(19, 'Non'),
(21, 'Oui'),
(21, 'Non'),
(23, 'Oui'),
(23, 'Non'),
(25, 'Oui'),
(25, 'Non'),
(27, 'Oui'),
(27, 'Non'),
(29, 'Équilibré'),
(29, 'Déséquilibré'),
(34, 'Oui'),
(34, 'Non'),
(36, 'Oui'),
(36, 'Non'),
(39, 'Oui'),
(39, 'Non'),
(40,'Seul(e)'),
(40,'Avec quelqu''un'),
(42, 'Oui'),
(42, 'Non'),
(44, 'Oui'),
(44, 'Non'),
(46, 'Oui'),
(46, 'Non'),
(48, 'Oui'),
(48, 'Non'),
(50, 'Oui'),
(50, 'Non');



-- Insérer les questions pour le questionnaire sur les douleurs thoraciques
INSERT INTO questions (questionnaire_id, question_text, question_type) VALUES
(2, 'Depuis combien de temps ressentez-vous ces symptômes ?', 'multiple_choice'),
(2, 'Décrivez la nature de vos symptômes principaux :', 'multiple_choice'),
(2, 'Où localisez-vous principalement la douleur ou l''inconfort ?', 'multiple_choice'),
(2, 'Avez-vous des antécédents médicaux de maladies cardiaques ?', 'multiple_choice'),
(2, 'Avez-vous des antécédents de maladies respiratoires, telles que la pneumonie ?', 'multiple_choice'),
(2, 'Avez-vous des antécédents d''anxiété ou de stress ?', 'multiple_choice'),
(2, 'Avez-vous des symptômes associés à vos douleurs thoraciques ? Cochez toutes les réponses qui s''appliquent :', 'multiple_choice'),
(2, 'Quels sont vos principaux facteurs de risque actuels ? Cochez toutes les réponses qui s''appliquent :', 'multiple_choice'),
(2, 'Quel est votre âge ?', 'multiple_choice'),
(2, 'Avez-vous eu récemment une chirurgie ou une blessure grave ?', 'multiple_choice'),
(2, 'Avez-vous des antécédents familiaux de maladies cardiaques ?', 'multiple_choice');

-- Insérer les choix pour les questions du questionnaire sur les douleurs thoraciques
INSERT INTO choices (question_id, choice_text) VALUES
(53, 'Moins de 24 heures'),
(53, '24 heures à 1 semaine'),
(53, 'Plus d''une semaine'),
(54, 'Douleur thoracique intense, sensation d''écrasement'),
(54, 'Douleur thoracique légère à modérée, exacerbée par l''effort'),
(54, 'Essoufflement soudain, douleur thoracique, toux'),
(54, 'Fièvre, toux, douleur thoracique sourde'),
(54, 'Douleur thoracique aggravée par la toux ou la respiration profonde'),
(54, 'Anxiété intense, palpitations, sensation d''oppression thoracique'),
(55, 'Centre de la poitrine, irradiant vers le bras gauche ou la mâchoire'),
(55, 'Centre de la poitrine, exacerbée par l''effort'),
(55, 'Dyspnée soudaine, douleur thoracique'),
(55, 'Douleur thoracique diffuse, aggravée par la respiration profonde'),
(55, 'Douleur thoracique diffuse, aggravée par la position couchée'),
(55, 'Sensation de serrement ou de pression sur la poitrin'),
(56, 'Oui, avec antécédents d''infarctus du myocarde ou d''angine de poitrine'),
(56, 'Oui, avec antécédents d''embolie pulmonaire'),
(56, 'Non, pas d''antécédents médicaux connus'),
(57, 'Oui, récemment diagnostiqué'),
(57, 'Non, pas d''antécédents médicaux connus '),
(58, 'Oui, antécédents d''anxiété ou de trouble panique'),
(58, 'Non, pas d''antécédents connus '),
(59, 'Essoufflement ou difficulté à respirer'),
(59, 'Transpiration excessive'),
(59, 'Nausées ou vomissements'),
(59, 'Fièvre ou frissons'),
(59, 'Palpitations cardiaques'),
(59, 'Douleur irradiant vers le bras gauche ou la mâchoire'),
(60, 'Hypertension artérielle'),
(60, 'Diabète'),
(60, 'Tabagisme'),
(60, 'Hypercholestérolémie'),
(60, 'Sédentarité'),
(60, 'Obésité'),
(61, 'Moins de 40 ans'),
(61, '40-60 ans'),
(61, 'Plus de 60 ans'),
(62, 'Oui'),
(62, 'Non'),
(63, 'Oui'),
(63, 'Non');

-- Insérer les questions pour le questionnaire sur l'embolie pulmonaire
INSERT INTO questions (questionnaire_id, question_text, question_type) VALUES
(3, 'Avez-vous récemment voyagé en avion ou fait un long trajet en voiture (plus de 4 heures)?', 'multiple_choice'),
(3, 'Avez-vous des antécédents de thrombose veineuse profonde (TVP) ou d''embolie pulmonaire ?', 'multiple_choice'),
(3, 'Avez-vous des antécédents familiaux de thrombose veineuse profonde ou d''embolie pulmonaire ?', 'multiple_choice'),
(3, 'Avez-vous un cancer actif ou recevez-vous actuellement un traitement pour le cancer ?', 'multiple_choice'),
(3, 'Avez-vous pris des contraceptifs oraux ou êtes-vous en traitement hormonal substitutif ?', 'multiple_choice'),
(3, 'Êtes-vous enceinte ou avez-vous accouché dans les six dernières semaines ?', 'multiple_choice'),
(3, 'Avez-vous ressenti une douleur thoracique soudaine', 'multiple_choice'),
(3, 'Avez-vous ressenti un essoufflement soudain et inexpliqué ?', 'multiple_choice'),
(3, 'Avez-vous observé un gonflement ou une douleur dans une jambe, particulièrement au niveau du mollet ?', 'multiple_choice'),
(3, 'Avez-vous ressenti une douleur lors de la respiration profonde (pleurésie) ?', 'multiple_choice'),
(3, 'Avez-vous craché du sang (hémoptysie) ?', 'multiple_choice'),
(3, 'Avez-vous observé une accélération du rythme cardiaque (tachycardie)', 'multiple_choice'),
(3, 'Avez-vous une respiration rapide (tachypnée) ?', 'multiple_choice'),
(3, 'Avez-vous une pression artérielle basse (hypotension) sans autre cause apparente ?', 'multiple_choice'),
(3, 'Avez-vous une saturation en oxygène (SpO2) inférieure à 95% sans autre cause apparente ?', 'multiple_choice'),
(3, 'Avez-vous une augmentation des D-dimères ?', 'multiple_choice'),
(3, 'L''échographie Doppler des membres inférieurs montre-t-elle une thrombose veineuse ?', 'multiple_choice'),
(3, 'Le scanner thoracique montre-t-il des signes d''embolie pulmonaire ?', 'multiple_choice');
-- Insérer les choix pour les questions du questionnaire sur l'embolie pulmonaire
INSERT INTO choices (question_id, choice_text) VALUES
(64, 'Oui'),
(64, 'Non'),
(65, 'Oui'),
(65, 'Non'),
(66, 'Oui'),
(66, 'Non'),
(67, 'Oui'),
(67, 'Non'),
(68, 'Oui'),
(68, 'Non'),
(69, 'Oui'),
(69, 'Non'),
(70, 'Oui'),
(70, 'Non'),
(71, 'Oui'),
(71, 'Non'),
(72, 'Oui'),
(72, 'Non'),
(73, 'Oui'),
(73, 'Non'),
(74, 'Oui'),
(74, 'Non'),
(75, 'Oui'),
(75, 'Non'),
(76, 'Oui'),
(76, 'Non'),
(77, 'Oui'),
(77, 'Non'),
(78, 'Oui'),
(78, 'Non'),
(79, 'Oui'),
(79, 'Non'),
(80, 'Oui'),
(80, 'Non'),
(81, 'Oui'),
(81, 'Non');


