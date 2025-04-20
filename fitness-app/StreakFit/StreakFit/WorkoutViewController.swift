//
//  WorkoutViewController.swift
//  StreakFit
//
//  Created by Richard M on 4/19/25.
//

import UIKit

struct WorkoutItem {
    var name: String
    var sets: Int
    var reps: Int
    var time: Int?
    var isCompleted: Bool
}

protocol WorkoutViewControllerDelegate: AnyObject {
    func didCompleteWorkout(workoutDoneToday: Bool)
}

class WorkoutViewController: UIViewController {
    weak var delegate: WorkoutViewControllerDelegate?

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    var workouts: [WorkoutItem] = []
    var onWorkoutComplete: (() -> Void)? // callback to HomeViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // If using Storyboard, make sure these are connected
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let scrollViewWidth: CGFloat = 380  // Set your desired width here
        let scrollViewHeight: CGFloat = 700 // Set your desired height here
        
        // Set gap between exercises
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            // Position scrollView just below the pageTitleLabel
            scrollView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 10), // 20 is the spacing
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),  // Optional padding
            scrollView.widthAnchor.constraint(equalToConstant: scrollViewWidth),
            scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight),
            
            // StackView inside ScrollView
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Crucial: Make stackView match scrollView width
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        
//        if workouts.isEmpty {
//            resetWorkoutUI()
//        } else {
//            for workout in workouts {
//                addWorkoutCard(for: workout, index: workouts.firstIndex(of: workout)!)
//            }
//        }
//        
        
        addWorkout(name: "Squat", sets: 3, reps: 10)
        addWorkout(name: "Lunges", sets: 3, reps: 12)
        addWorkout(name: "curls", sets: 3, reps: 12)

    }

    func addWorkout(name: String, sets: Int, reps: Int, time: Int? = nil) {
        let item = WorkoutItem(name: name, sets: sets, reps: reps, time: time, isCompleted: false)
        workouts.append(item)
        addWorkoutCard(for: item, index: workouts.count - 1)
    }

    func addWorkoutCard(for workout: WorkoutItem, index: Int) {
        let card = WorkoutCardView(workout: workout)
        card.onToggle = { [weak self] in
            guard let self = self else { return }
            self.workouts[index].isCompleted.toggle()
            self.checkWorkoutCompletion()
        }
        
        // Set a fixed height for each WorkoutCardView
        card.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        stackView.addArrangedSubview(card)
    }

    
    func updateScrollViewContentSize() {
        // Calculate content height based on the number of workout items
        let contentHeight = CGFloat(workouts.count * 50)  // 80 is the fixed height for each workout card
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }

    @objc func toggleExerciseCompleted(_ sender: UIButton) {
        let index = sender.tag
        guard index < workouts.count else { return }

        workouts[index].isCompleted.toggle()
        let imageName = workouts[index].isCompleted ? "checkmark.circle.fill" : "circle"
        sender.setImage(UIImage(systemName: imageName), for: .normal)

        checkWorkoutCompletion()
    }

    func checkWorkoutCompletion() {
        print("Checking workout completion...")
        print("Workout states: \(workouts.map { $0.isCompleted })")

        if workouts.allSatisfy({ $0.isCompleted }) {
            print("All workouts completed! Updating streak...")

            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let lastDate = UserDefaults.standard.object(forKey: "lastWorkoutDate") as? Date

            // Only increment streak if workout wasn't already done today
            if lastDate == nil || calendar.compare(lastDate!, to: today, toGranularity: .day) != .orderedSame {
                var streak = UserDefaults.standard.integer(forKey: "streak")
                streak += 1
                UserDefaults.standard.set(streak, forKey: "streak")
                print("🏋️‍♂️ Streak incremented to \(streak)")

                // Set last workout date AFTER increment
                UserDefaults.standard.set(today, forKey: "lastWorkoutDate")
            } else {
                print("Workout already logged today, not incrementing streak again.")
            }

            UserDefaults.standard.set(true, forKey: "workoutDoneToday")
            
            delegate?.didCompleteWorkout(workoutDoneToday: true)
            showCompletionAlert()
        }
    }




    func showCompletionAlert() {
        let alert = UIAlertController(title: "Great job!", message: "You completed your workout for today 🎉", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.resetWorkoutUI()
        })
        present(alert, animated: true)
    }
    
    
    func resetWorkoutUI() {
        // Clear all workout data
        workouts.removeAll()
        
        // Remove all arranged subviews from the stackView
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Show default message
        let label = UILabel()
        label.text = "No workout. Go to Exercise page and add exercises to begin workout."
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        // Add padding/margin
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])

        stackView.addArrangedSubview(container)
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddWorkoutViewController {
            addVC.onAddWorkout = { [weak self] name, sets, reps, timer in
                self?.addWorkout(name: name, sets: sets, reps: reps, time: timer)
            }
        }
    }
}

