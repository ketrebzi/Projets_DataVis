document.addEventListener('DOMContentLoaded', async () => {
    const questionsContainer = document.getElementById('questions-container');
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    const submitBtn = document.getElementById('submit-btn');
    let currentPage = 0;
    const questionsPerPage = 1;//Précisez le nombre de questions par page
    let allResponses = {};
    let userId = null;
    let currentQuestionnaireId = 1; // Start with questionnaire 1

    if (!questionsContainer || !submitBtn || !prevBtn || !nextBtn) {
        console.error('Required elements not found');
        return;
    }

    // Function to fetch user ID
    const fetchUserId = async () => {
        try {
            const response = await fetch('/get-user-id');
            if (!response.ok) throw new Error('Network response was not ok');
            const data = await response.json();
            userId = data.userId;
        } catch (error) {
            console.error('Error fetching user ID:', error);
            alert('Erreur lors de la génération de l\'ID utilisateur.');
        }
    };

    await fetchUserId();

    // Function to fetch questions for a given questionnaire
    const fetchQuestions = async (questionnaireId) => {
        try {
            const response = await fetch(`/questionnaire/${questionnaireId}/questions`);
            if (!response.ok) throw new Error('Network response was not ok');
            return await response.json();
        } catch (error) {
            console.error('Error fetching questions:', error);
            questionsContainer.innerHTML = '<p>Erreur lors de la récupération des questions.</p>';
            return [];
        }
    };

    // Function to render questions on the page
    const renderQuestions = (questions, page) => {
        if (!questions || questions.length === 0) {
            questionsContainer.innerHTML = '<p>Aucune question à afficher.</p>';
            return;
        }

        const startIndex = page * questionsPerPage;
        const endIndex = startIndex + questionsPerPage;
        const questionsToRender = questions.slice(startIndex, endIndex);

        questionsContainer.innerHTML = questionsToRender.map(question => {
            switch (question.question_type) {
                case 'text':
                    return `
                        <div class="question">
                            <label>${question.question_text}</label>
                            <input type="text" name="question-${question.id}" value="${allResponses[question.id] || ''}" />
                        </div>
                    `;
                case 'date':
                    return `
                        <div class="question">
                            <label>${question.question_text}</label>
                            <input type="date" name="question-${question.id}" value="${allResponses[question.id] || ''}" />
                        </div>
                    `;
                case 'multiple_choice':
                    return `
                        <div class="question">
                            <label>${question.question_text}</label>
                            <select name="question-${question.id}">
                                <option value="">Choisissez...</option>
                                ${question.choices.map(choice => `<option value="${choice}" ${allResponses[question.id] === choice ? 'selected' : ''}>${choice}</option>`).join('')}
                            </select>
                        </div>
                    `;
                default:
                    return `
                        <div class="question">
                            <p>${question.question_text}</p>
                        </div>
                    `;
            }
        }).join('');

        prevBtn.style.display = page === 0 ? 'none' : 'block';
        nextBtn.style.display = page === Math.ceil(questions.length / questionsPerPage) - 1 ? 'none' : 'block';
        submitBtn.style.display = page === Math.ceil(questions.length / questionsPerPage) - 1 ? 'block' : 'none';
    };

    // Function to save current responses
    const saveCurrentResponses = (questions) => {
        questions.slice(currentPage * questionsPerPage, (currentPage + 1) * questionsPerPage).forEach(question => {
            const answer = document.querySelector(`[name="question-${question.id}"]`);
            if (answer) {
                allResponses[question.id] = answer.value;
            }
        });
    };

    // Load and render questions
    const loadQuestions = async () => {
        const questions = await fetchQuestions(currentQuestionnaireId);
        renderQuestions(questions, currentPage);
    };

    await loadQuestions();

    // Event listener for "Précédent" button
    prevBtn.addEventListener('click', async () => {
        saveCurrentResponses(await fetchQuestions(currentQuestionnaireId));
        if (currentPage > 0) {
            currentPage--;
            renderQuestions(await fetchQuestions(currentQuestionnaireId), currentPage);
        }
    });

    // Event listener for "Suivant" button
    nextBtn.addEventListener('click', async () => {
        saveCurrentResponses(await fetchQuestions(currentQuestionnaireId));
        const questions = await fetchQuestions(currentQuestionnaireId);
        if ((currentPage + 1) * questionsPerPage < questions.length) {
            currentPage++;
            renderQuestions(questions, currentPage);
        } else {
            await submitResponses();
            if (currentQuestionnaireId === 1) {
                // Move to the next questionnaire
                currentQuestionnaireId = 2;
                currentPage = 0;  // Reset to the first page of the new questionnaire
                allResponses = {}; // Reset responses for the new questionnaire
                await loadQuestions();
            } else if (currentQuestionnaireId === 2) {
                // Move to the next questionnaire
                currentQuestionnaireId = 3;
                currentPage = 0;  // Reset to the first page of the new questionnaire
                allResponses = {}; // Reset responses for the new questionnaire
                await loadQuestions();
            } else {
                alert('Vous avez complété tous les questionnaires.');
            }
        }
    });

    // Function to submit responses
    const submitResponses = async () => {
        try {
            const response = await fetch('/submit-responses', {
                method: 'POST',
                body: JSON.stringify({ userId, questionnaireId: currentQuestionnaireId, responses: allResponses }),
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            if (!response.ok) throw new Error('Network response was not ok');
            alert('Réponses soumises avec succès!');
        } catch (error) {
            console.error('Error submitting responses:', error);
            alert('Erreur lors de la soumission des réponses.');
        }
    };

    // Event listener for "Valider" button
    submitBtn.addEventListener('click', async () => {
        saveCurrentResponses(await fetchQuestions(currentQuestionnaireId));
        await submitResponses();
        if (currentQuestionnaireId === 1) {
            currentQuestionnaireId = 2;
        } else if (currentQuestionnaireId === 2) {
            currentQuestionnaireId = 3;
        } else {
            alert('Vous avez complété tous les questionnaires.');
        }
        currentPage = 0;
        allResponses = {};
        await loadQuestions();
    });
});
