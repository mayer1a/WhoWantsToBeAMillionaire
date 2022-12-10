//
//  MainMenuView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 03.12.2022.
//

import UIKit

protocol MainMenuViewDelegate: AnyObject {
    
    func buttonDidTapped(with tag: Int)
    func gameLevelChanged()
}

final class MainMenuView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MainMenuViewDelegate?
    
    // MARK: - Private properties
    
    private var buttonTemplate: UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        button.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    private var labelTemplate: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.textColor = UIColor(named: "helpTextColor")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private var playButton: UIButton
    private var scoreButton: UIButton
    private var scoreLabel: UILabel
    private var levelSwitch: UISwitch
    
    // MARK: - Constructions
    
    required init() {
        scoreLabel = UILabel()
        playButton = UIButton()
        scoreButton = UIButton()
        levelSwitch = UISwitch()
        
        super.init(frame: .zero)
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        levelSwitch.layer.borderColor = UIColor(named: "SwitchBorderColor")?.cgColor
        levelSwitch.layer.cornerRadius = levelSwitch.frame.height / 2
        levelSwitch.layer.masksToBounds = true
        levelSwitch.layer.borderWidth = 1
    }
    
    // MARK: - Functions
    
    func scoreLabelConfigurate(with value: (score: Int, coins: Int)) {
        scoreLabel.text = "Последний результат: \(value.score)% | \(value.coins) монет"
    }
    
    func scoreLabelConfigurate(with text: String = "") {
        scoreLabel.text = text
    }
    
    func levelSwitchConfigurate(with state: Bool) {
        levelSwitch.setOn(state, animated: false)
    }
    
    // MARK: - Private functions
    
    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")
        
        playButton = buttonTemplate
        playButton.setTitle("Играть", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        playButton.tag = 0
        
        scoreButton = buttonTemplate
        scoreButton.setTitle("Результаты", for: .normal)
        scoreButton.setTitleColor(UIColor(named: "helpTextColor"), for: .normal)
        scoreButton.tag = 1
        
        if #available(iOS 15.0, *) {
            scoreButton.configuration = UIButton.Configuration.plain()
            scoreButton.setImage(UIImage(named: "scoreTable"), for: .normal)
            scoreButton.configuration?.imagePlacement = .top
        }
        
        scoreLabel = labelTemplate
        scoreLabel.textAlignment = .center
        
        levelSwitch.setOn(false, animated: false)
        levelSwitch.onTintColor = UIColor(named: "SwitchTintColor")
        levelSwitch.clipsToBounds = true
        levelSwitch.translatesAutoresizingMaskIntoConstraints = false
        levelSwitch.addTarget(self, action: #selector(gameLevelChanged(_:)), for: .valueChanged)
        
        let easyLabel = labelTemplate
        easyLabel.text = "Хардкорный режим:"
        
        addSubview(playButton)
        addSubview(scoreButton)
        addSubview(scoreLabel)
        addSubview(levelSwitch)
        addSubview(easyLabel)
        
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 128.0),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -87),
            playButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 87),
            
            scoreButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            scoreButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 40.0),
            scoreButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 121.0),
            scoreButton.widthAnchor.constraint(equalTo: scoreButton.heightAnchor),
            
            scoreLabel.topAnchor.constraint(greaterThanOrEqualTo: scoreButton.bottomAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scoreLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            scoreLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            levelSwitch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            levelSwitch.leadingAnchor.constraint(equalTo: easyLabel.trailingAnchor, constant: 50),
            
            easyLabel.centerYAnchor.constraint(equalTo: levelSwitch.centerYAnchor),
            easyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    @objc private func buttonDidTapped(_ sender: UIButton) {
        delegate?.buttonDidTapped(with: sender.tag)
    }
    
    @objc private func gameLevelChanged(_ sender: UISwitch) {
        delegate?.gameLevelChanged()
    }
}
