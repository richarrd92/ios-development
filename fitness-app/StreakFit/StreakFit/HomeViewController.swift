//
//  HomeViewController.swift
//  StreakFit
//
//  Created by Richard M on 4/19/25.
//

import UIKit


class HomeViewController: UIViewController, WorkoutViewControllerDelegate {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var defaultStreakFont: UIFont?
    var defaultStreakColor: UIColor?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔥 HomeViewController viewDidLoad called")
        
        // Store original style
        defaultStreakFont = streakLabel.font
        defaultStreakColor = streakLabel.textColor
        
        if let navVCs = self.navigationController?.viewControllers {
            print("👀 Navigation Stack: \(navVCs.map { String(describing: type(of: $0)) })")
        } else {
            print("❌ navigationController is nil")
        }
        
        if let workoutVC = self.navigationController?.viewControllers.first(where: { $0 is WorkoutViewController }) as? WorkoutViewController {
            workoutVC.delegate = self
            print("🤣🤣🤣 Delegate set to HomeViewController")
        } else {
            print("❌ WorkoutViewController not found in navigation stack")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetIfNewDay()
        updateUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let updatedStreak = UserDefaults.standard.integer(forKey: "streak")
        let workoutDoneToday = UserDefaults.standard.bool(forKey: "workoutDoneToday")

        print("Updated streak on viewDidAppear: \(updatedStreak)")  // Debugging
        print("Workout done today: \(workoutDoneToday)")  // Debugging

        updateUI() // Ensure UI gets updated
    }

    
    
    func didCompleteWorkout(workoutDoneToday: Bool) {
        print("Delegate method triggered: Workout completed, workout done today: \(workoutDoneToday)")  // Debugging
        updateStreak()
        updateUI()
    }


    func resetIfNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = UserDefaults.standard.object(forKey: "lastWorkoutDate") as? Date

        print("Checking if a new day has started...")

        if lastDate == nil || Calendar.current.compare(lastDate!, to: today, toGranularity: .day) != .orderedSame {
            let workoutDoneYesterday = UserDefaults.standard.bool(forKey: "workoutDoneToday")
            if !workoutDoneYesterday {
                // Missed yesterday's workout → reset streak
                UserDefaults.standard.set(0, forKey: "streak")
                print("Streak reset to 0 because workout was missed.")
            } else {
                print("Workout was done yesterday, streak preserved.")
            }

            // Set up for the new day
            UserDefaults.standard.set(false, forKey: "workoutDoneToday")
//            UserDefaults.standard.set(today, forKey: "lastWorkoutDate")
        } else {
            print("Same day, no reset.")
        }
    }


    func updateUI() {
        let streak = UserDefaults.standard.integer(forKey: "streak")
        print("Streak saved: \(UserDefaults.standard.integer(forKey: "streak"))")

        let workoutDoneToday = UserDefaults.standard.bool(forKey: "workoutDoneToday")
        print("Workout done today: \(UserDefaults.standard.bool(forKey: "workoutDoneToday"))")

        print("Updating UI: Streak = \(streak), Workout Done Today = \(workoutDoneToday)")
        
        if streak == 0 {
            streakLabel.text = "No streak, start your journey!"
            streakLabel.font = UIFont.italicSystemFont(ofSize: 12)
            streakLabel.textColor = .lightGray
        } else {
            let dayText = streak == 1 ? "day" : "days"
            streakLabel.text = "\(streak) \(dayText)"
            
            if let font = defaultStreakFont {
                streakLabel.font = font
            }
            
            if let color = defaultStreakColor {
                streakLabel.textColor = color
            }
        }


        if workoutDoneToday {
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkImageView.tintColor = .systemGreen
            notificationLabel.text = "Workout completed! Check in another day"
            notificationLabel.textColor = .systemGreen
        } else {
            checkImageView.image = UIImage(systemName: "xmark.circle.fill")
            checkImageView.tintColor = .red
            notificationLabel.text = "Workout not completed"
            notificationLabel.textColor = .red
        }
    }

    func updateStreak() {
        print("🔥 In the UpdateStreak function")  // Debugging
        var streak = UserDefaults.standard.integer(forKey: "streak")
        let workoutDoneToday = UserDefaults.standard.bool(forKey: "workoutDoneToday")
        
        print("🔥 Workout done today: \(workoutDoneToday)")  // Debugging

        // Only increment the streak if the workout hasn't been done today
        if !workoutDoneToday {
            streak += 1
            UserDefaults.standard.set(streak, forKey: "streak")
            UserDefaults.standard.set(true, forKey: "workoutDoneToday")
            UserDefaults.standard.set(Date(), forKey: "lastWorkoutDate")
            print("🔥 Streak updated from UpdateStreak: \(streak)")  // Debugging
        } else {
            print("🔥 Workout already done today, streak not updated.")
        }

        updateUI()  // Make sure the UI reflects the updated streak
    }




    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue called")
        
        if let workoutVC = segue.destination as? WorkoutViewController {
            print("Segue to WorkoutViewController")
            workoutVC.delegate = self // Set HomeViewController as the delegate
        }
    }
}
