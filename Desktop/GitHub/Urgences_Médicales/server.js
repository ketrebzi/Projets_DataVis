const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const app = express();
const port = 3000;

// Configurer la connexion à la base de données PostgreSQL
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'URGENCES',
    password: '11041993',
    port: 5432,
});

// Middleware pour servir les fichiers statiques (HTML, CSS, JS)
app.use(express.static(path.join(__dirname, 'frontend')));

// Middleware pour parser les requêtes JSON
app.use(express.json());

// Route pour obtenir les questions d'un questionnaire donné
app.get('/questionnaire/:id/questions', async (req, res) => {
    const questionnaireId = req.params.id;
    try {
        // Récupérer les questions
        const questionsResult = await pool.query(`
            SELECT q.id, q.question_text, q.question_type 
            FROM "UR_OPE".questions q 
            WHERE q.questionnaire_id = $1
        `, [questionnaireId]);
        const questions = questionsResult.rows;

        // Récupérer les choix pour les questions à choix multiples
        const choicesResult = await pool.query(`
            SELECT c.id, c.question_id, c.choice_text 
            FROM "UR_OPE".choices c
            WHERE c.question_id IN (
                SELECT id FROM "UR_OPE".questions WHERE questionnaire_id = $1 AND question_type = 'multiple_choice'
            )
        `, [questionnaireId]);
        const choices = choicesResult.rows;

        // Ajouter les choix aux questions correspondantes
        const questionsWithChoices = questions.map(question => {
            if (question.question_type === 'multiple_choice') {
                question.choices = choices.filter(choice => choice.question_id === question.id).map(choice => choice.choice_text);
            }
            return question;
        });

        res.json(questionsWithChoices);
    } catch (err) {
        console.error('Error fetching questions:', err);
        res.status(500).send('Error fetching questions');
    }
});

// Route pour soumettre les réponses du questionnaire
app.post('/submit-responses', async (req, res) => {
    try {
        const { userId, questionnaireId, responses } = req.body;
        console.log('Received responses:', { userId, questionnaireId, responses });

        const client = await pool.connect();

        try {
            await client.query('BEGIN');

            // Insérer ou mettre à jour les réponses dans la base de données
            for (const questionId in responses) {
                const responseText = responses[questionId];
                await client.query(
                    `INSERT INTO "UR_OPE".responses (user_id, questionnaire_id, question_id, response) 
                     VALUES ($1, $2, $3, $4)
                     ON CONFLICT (user_id, questionnaire_id, question_id) 
                     DO UPDATE SET response = EXCLUDED.response`,
                    [userId, questionnaireId, questionId, responseText]
                );
            }

            await client.query('COMMIT');
            res.status(200).send('Responses submitted successfully');
        } catch (err) {
            await client.query('ROLLBACK');
            console.error('Error submitting responses:', err);
            res.status(500).send('Error submitting responses');
        } finally {
            client.release();
        }
    } catch (err) {
        console.error('Error submitting responses:', err);
        res.status(500).send('Error submitting responses');
    }
});

// Route pour générer un ID utilisateur unique
app.get('/get-user-id', (req, res) => {
    const userId = uuidv4();
    res.json({ userId });
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
