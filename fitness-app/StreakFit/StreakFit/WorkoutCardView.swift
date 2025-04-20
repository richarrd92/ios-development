//
//  WorkoutCardView.swift
//  StreakFit
//
//  Created by Richard M on 4/20/25.
//

import UIKit

class WorkoutCardView: UIView {
    
    private let nameLabel = UILabel()
    private let checkButton = UIButton(type: .system)
    
    var isCompleted: Bool = false {
        didSet {
            let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
            checkButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    var onToggle: (() -> Void)?
    
    init(workout: WorkoutItem) {
        super.init(frame: .zero)
        setupUI()
        configure(with: workout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        checkButton.tintColor = .systemBlue
        checkButton.addTarget(self, action: #selector(toggleCompleted), for: .touchUpInside)
        
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        
        let hStack = UIStackView(arrangedSubviews: [checkButton, nameLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 47)
        ])
    }
    
    func configure(with workout: WorkoutItem) {
        var text = "\(workout.name): \(workout.sets) sets x \(workout.reps) reps"
        if let time = workout.time {
            text += " – \(time)s rest"
        }
        nameLabel.text = text
        isCompleted = workout.isCompleted
    }

    @objc private func toggleCompleted() {
        isCompleted.toggle()
        onToggle?()
    }
}

