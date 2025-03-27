//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Richard M on 3/10/25.
//

import UIKit

// Structure representing a single question
//struct Question {
//    let text: String // The question text
//    let choices: [String] // Available answer choices
//    let correctAnswer: String // The correct answer
//}


// Structure representing a single question
struct Question: Decodable {
    let text: String
    let choices: [String]
    let correctAnswer: String
    
    enum CodingKeys: String, CodingKey {
        case text = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        let incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        
        // shuffle for randomness
        self.choices = (incorrectAnswers + [correctAnswer]).shuffled()
    }
}

// Struct to match API response format
struct TriviaResponse: Decodable {
    let results: [Question]
}

// ViewController for handling trivia game logic and UI
class TriviaViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel! // Label to display the current question
    @IBOutlet var answerButtons: [UIButton]! // Collection of buttons for answer choices
    @IBOutlet weak var countLabel: UILabel! // Label to display the question count
    
//    // Array of questions used in the quiz
//    var questions: [Question] = [
//        Question(
//            text: "What is the capital of France?",
//            choices: ["Berlin", "Paris", "Rome", "Madrid"],
//            correctAnswer: "Paris"),
//        Question(
//            text: "What is 2 + 2?",
//            choices: ["3", "4", "5", "6"],
//            correctAnswer: "4"),
//        Question(
//            text: "What is 20 + 12?",
//            choices: ["44", "31", "32", "62"],
//            correctAnswer: "32")
//    ]
    
    // Array of questions used in the quiz
    var questions: [Question] = []
    
    var currentQuestionIndex = 0 // Index to track the current question
    var score = 0 // Score to track correct answers
    var originalButtonColor: UIColor? // Store original custom button background color

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Store the original background color of buttons
        if let firstButton = answerButtons.first {
            originalButtonColor = firstButton.backgroundColor
        }
        
//        loadQuestion() // Load the first question when the view is loaded
        fetchQuestions() // Fetch questions from API when view is loaded
    }
    
    func fetchQuestions() {
        let urlString = "https://opentdb.com/api.php?amount=10&category=21&difficulty=easy&type=multiple"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    self.questions = decodedData.results
                    self.loadQuestion()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    
    // function to load the question
    func loadQuestion() {
        // ensure questions loaded
        guard !questions.isEmpty else { return }
        
        countLabel.layer.cornerRadius = 10
        countLabel.layer.borderWidth = 2
        countLabel.layer.borderColor = UIColor.darkGray.cgColor
        countLabel.clipsToBounds = true

        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.borderWidth = 2
        questionLabel.layer.borderColor = UIColor.darkGray.cgColor
        questionLabel.clipsToBounds = true

        // Loop through each button to apply the border styling
        for button in answerButtons {
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.clipsToBounds = true
        }
        
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text // Set the question text
        countLabel.text = "Question: \(currentQuestionIndex + 1)/\(questions.count)" // Question count

        
        
        // Assign choices to buttons and reset their colors
        for (index, button) in answerButtons.enumerated() {
            button.setTitle(currentQuestion.choices[index], for: .normal)
            button.backgroundColor = originalButtonColor // Reset to original background
        }
    }

    // Function triggered when an answer is selected
    @IBAction func answerSelected(_ sender: UIButton) {
        let selectedAnswer = sender.currentTitle // Get the text of the selected button
        let correctAnswer = questions[currentQuestionIndex].correctAnswer // Get the correct answer
        
        // Check if the selected answer is correct
        if selectedAnswer == correctAnswer {
            score += 1 // Increment score if correct
            // Dark Green -> correct
            sender.backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
        } else {
            // Dark Red -> incorrect
            sender.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        
        // Reset button color and load next question after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = self.originalButtonColor // Reset button color
            self.nextQuestion() // Load next question
        }
    }
    
    // Function to move to the next question or display the final score
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1 // Move to the next question
            loadQuestion() // Load the new question
        } else {
            showFinalScore() // Show the final score if all questions are answered
        }
    }
    
    // Function to display final score in an alert
    func showFinalScore() {
        let alert = UIAlertController(title: "Quiz Completed", message: "Your score: \(score)/\(questions.count)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.resetQuiz() // Restart the quiz when the user clicks "Restart"
        }))
        present(alert, animated: true)
    }
    
    // Function to reset the quiz to the initial state
    func resetQuiz() {
        currentQuestionIndex = 0 // Reset question index
        score = 0 // Reset score
//        loadQuestion() // Load the first question again
        fetchQuestions() // Load the first question again
    }
}
