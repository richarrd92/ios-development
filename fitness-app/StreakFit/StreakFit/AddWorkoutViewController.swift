//
//  AddWorkoutViewController.swift
//  StreakFit
//
//  Created by Richard M on 4/19/25.
//

import UIKit

class AddWorkoutViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var setsField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    @IBOutlet weak var timerField: UITextField!

    // This closure sends the workout back
    var onAddWorkout: ((String, Int, Int, Int?) -> Void)?

    @IBAction func addWorkoutTapped(_ sender: UIButton) {
        guard let name = nameField.text,
              let setsText = setsField.text, let sets = Int(setsText),
              let repsText = repsField.text, let reps = Int(repsText),
              !name.isEmpty else { return }
        let timer = Int(timerField.text ?? "")
        
        onAddWorkout?(name, sets, reps, timer)
        navigationController?.popViewController(animated: true)
    }
}
