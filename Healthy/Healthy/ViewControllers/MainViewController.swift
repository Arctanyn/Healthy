//
//  ViewController.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 09.01.2022.
//

import UIKit
import TinyConstraints

class MainViewController: UIViewController {

    //MARK: -Properties
    private var user: User!
    private lazy var genderType = user.genderType {
        didSet {
            user.genderType = genderType
        }
    }
    
    //MARK: -View
    private let mainColor = UIColor(red: 16 / 255, green: 12 / 255, blue: 34 / 255, alpha: 1)
    private let valueChangingViewColor = UIColor(red: 84 / 255, green: 87 / 255, blue: 157 / 255, alpha: 1)
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    private lazy var maleGenderButton = UIButton(type: .system)
    private lazy var femaleGenderButton = UIButton(type: .system)
    private lazy var genderStackView = UIStackView()
    
    private var heightView = UIView()
    
    private lazy var heightSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 120
        slider.maximumValue = 220
        slider.minimumTrackTintColor = valueChangingViewColor
        slider.maximumTrackTintColor = .darkGray
        return slider
    }()
    
    private lazy var heightLabel = setupHeaderForViews(title: "Рост")
    private lazy var heightValueLabel = setupValueLabel()
    
    private lazy var weightLabel = setupHeaderForViews(title: "Вес")
    private lazy var weightValueLabel = setupValueLabel()
    
    private lazy var ageLabel = setupHeaderForViews(title: "Возраст")
    private lazy var ageValueLabel = setupValueLabel()
    
    private lazy var steppingChangeableStackView = UIStackView()
    
    private lazy var goToResultsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подсчитать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemPink
        return button
    }()
    
    private lazy var weightStepper = setupStepper(
        minValue: Double(user.minWeight),
        maxValue: Double(user.maxWeight),
        step: 1
    )
    
    private lazy var ageStepper = setupStepper(
        minValue: Double(user.minAge),
        maxValue: Double(user.maxAge),
        step: 1
    )
    
    //MARK: -View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Healthy"
        
        loadUserData()
        
        setScrollViewConstraints()
        configureContainerView()
        
        scrollView.contentSize = CGSize(width: containerView.frame.width, height: containerView.frame.height)
        scrollView.showsHorizontalScrollIndicator = false

        addViewTargets()
        updateUI(user.height, user.weight, user.age)
    }
}

//MARK: -Actions
extension MainViewController {
    @objc func selectMaleGender(_ sender: UIButton) {
        genderType = .male
        maleGenderButton.dentAnimation()
        maleGenderButton.addSelectedEffect()
        femaleGenderButton.layer.shadowOpacity = 0
        print("Male button did tapped")
    }
    
    @objc func selectFemaleGender(_ sender: UIButton) {
        genderType = .female
        femaleGenderButton.dentAnimation()
        femaleGenderButton.addSelectedEffect()
        maleGenderButton.layer.shadowOpacity = 0
        print("Female button did tapped")
    }
    
    @objc func changeHeightSliderValue(_ sender: UISlider) {
        guard sender == heightSlider else { return }
        let currentValue = Int(heightSlider.value)
        user.height = Int(currentValue)
        heightValueLabel.text = "\(currentValue)"
    }
    
    @objc func changeWeightValue(_ sender: UIStepper) {
        guard sender == weightStepper else { return }
        let currentWeight = weightStepper.value
        user.weight = Int(currentWeight)
        weightValueLabel.text = "\(Int(sender.value))"
    }
    
    @objc func changeAgeValue(_ sender: UIStepper) {
        guard sender == ageStepper else { return }
        let currenAge = ageStepper.value
        user.age = Int(currenAge)
        ageValueLabel.text = "\(Int(sender.value))"
    }
    
    @objc func goToResults(_ sender: UIButton) {
        guard sender == goToResultsButton else { return }
        StorageManager.shared.save(with: user)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let healthInfoTableVC = storyboard.instantiateViewController(withIdentifier: "healthResults") as? HealthInfoTableViewController else { return }
        healthInfoTableVC.loadParameters(of: user)
        navigationController?.pushViewController(healthInfoTableVC, animated: true)
    }
}

//MARK: Private methods
extension MainViewController {
    
    private func loadUserData() {
        self.user = StorageManager.shared.fetchUserParameters()
    }
    
    fileprivate func addViewTargets() {
        heightSlider.addTarget(self, action: #selector(changeHeightSliderValue(_:)), for: .valueChanged)
        
        weightStepper.addTarget(self, action: #selector(changeWeightValue(_:)), for: .valueChanged)
        ageStepper.addTarget(self, action: #selector(changeAgeValue(_:)), for: .valueChanged)

        goToResultsButton.addTarget(self, action: #selector(goToResults(_:)), for: .touchUpInside)
    }
    
    private func updateUI(_ height: Int, _ weight: Int, _ age: Int) {
        
        heightValueLabel.text = "\(height)"
        heightSlider.value = Float(height)
        
        weightValueLabel.text = "\(weight)"
        weightStepper.value = Double(weight)
        
        ageValueLabel.text = "\(age)"
        ageStepper.value = Double(age)
        
        switch genderType {
        case .male:
            maleGenderButton.addSelectedEffect()
        case .female:
            femaleGenderButton.addSelectedEffect()
        }
    }
}

//MARK: -View Configuration
extension MainViewController {
    private func configureContainerView() {
        scrollView.addSubview(containerView)
        configureGenderStackView()
        configureHeightView()
        configureSteppingChangeableStackView()
        configureGoToResultsButton()
        
        setContainerViewConstraints()
    }
    
    //MARK: Informing Labels
    private func setupHeaderForViews(title: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.text = title
        label.textAlignment = .center
        return label
    }
    
    private func setupValueLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 35, weight: .heavy)
        label.textAlignment = .center
        label.text = "\(0)"
        return label
    }
    
    //MARK: Gender Stack View
    private func configureGenderStackView() {
        containerView.addSubview(genderStackView)
        
        //Set stackView content parameters
        genderStackView.axis = .horizontal
        genderStackView.distribution = .fillEqually
        genderStackView.spacing = 10
        
        //Add subviews
        addViewsToGenderStackView()
        
        //Set constraints
        setGenderStackViewConstraints()
    }
    
    private func addViewsToGenderStackView() {
        for (index, button) in [maleGenderButton, femaleGenderButton].enumerated() {
            button.configuration = .tinted()
            button.configuration?.baseBackgroundColor = .systemIndigo
            button.configuration?.baseForegroundColor = .white
            button.configuration?.imagePlacement = .top
            if index == 0 {
                button.configuration?.image = UIImage(named: "male.gender.icon")
                button.configuration?.title = "Мужской"
                button.addTarget(self, action: #selector(selectMaleGender(_:)), for: .touchUpInside)
            } else if index == 1 {
                button.configuration?.image = UIImage(named: "female.gender.icon")
                button.configuration?.title = "Женский"
                button.addTarget(self, action: #selector(selectFemaleGender(_:)), for: .touchUpInside)
            }
            button.height(160)
            genderStackView.addArrangedSubview(button)
        }
    }
    
    //MARK: Height View
    private func configureHeightView() {
        containerView.addSubview(heightView)
        
        //Set heightView parameters
        heightView.layer.cornerRadius = 12
        heightView.backgroundColor = mainColor
        
        //Add subviews
        heightView.addSubview(heightLabel)
        heightView.addSubview(heightValueLabel)
        heightView.addSubview(heightSlider)
        
        //Set constraints for subviews
        setHeightLabelConstraints()
        setHeightValueLabelConstraints()
        setHeightSliderConstraints()
        
        //Constraints
        setHeightViewConstraints()
    }
    
    //MARK: Imposed Stack View
    private func configureSteppingChangeableStackView() {
        containerView.addSubview(steppingChangeableStackView)
        
        //Set stackView parameters
        steppingChangeableStackView.axis = .horizontal
        steppingChangeableStackView.distribution = .fillEqually
        steppingChangeableStackView.spacing = 10
        
        //Add subviews
        addSubviewsSteppingChangeableStackView()
        
        //Constraints
        setSteppingChangeableStackViewConstraints()
    }

    private func addSubviewsSteppingChangeableStackView() {
        let countOfView = 2
        var userParamView: UIView!
        for i in 1...countOfView {
            switch i {
            case 1:
                userParamView = setupSteppingChangeableView(
                    header: weightLabel,
                    valueLabel: weightValueLabel,
                    stepper: weightStepper
                )
            case 2:
                userParamView = setupSteppingChangeableView(
                    header: ageLabel,
                    valueLabel: ageValueLabel,
                    stepper: ageStepper
                )
            default:
                break
            }
            steppingChangeableStackView.addArrangedSubview(userParamView)
        }
    }
    
    //MARK: Stepping changeable parameters view
    private func setupSteppingChangeableView(header: UILabel, valueLabel: UILabel, stepper: UIStepper) -> UIView {
        let userParamView = UIView()
        userParamView.layer.cornerRadius = 12
        userParamView.backgroundColor = mainColor
        userParamView.height(160)
        
        //Add subviews
        userParamView.addSubview(header)
        userParamView.addSubview(valueLabel)
        userParamView.addSubview(stepper)
        
        //Subviews constraints
        header.topToSuperview(offset: 10)
        header.leadingToSuperview(offset: 10)
        header.trailingToSuperview(offset: 10)
        header.height(25)
        header.centerXToSuperview()
        
        valueLabel.topToBottom(of: header, offset: 10)
        valueLabel.leadingToSuperview(offset: 10)
        valueLabel.trailingToSuperview(offset: 10)
        
        stepper.topToBottom(of: valueLabel, offset: 10)
        stepper.centerXToSuperview()
        stepper.bottomToSuperview(offset: -20)
        
        return userParamView
    }
    
    //MARK: Stepper
    private func setupStepper(minValue: Double, maxValue: Double, step: Double) -> UIStepper {
        let stepper = UIStepper()
        stepper.minimumValue = minValue
        stepper.maximumValue = maxValue
        stepper.stepValue = step
        stepper.backgroundColor = valueChangingViewColor
        stepper.layer.cornerRadius = 12
        return stepper
    }
    
    //MARK: Results Button
    private func configureGoToResultsButton() {
        containerView.addSubview(goToResultsButton)
        setGoToResultsButtonConstraints()
    }
}

//MARK: -Constraints
extension MainViewController {
    private func setScrollViewConstraints() {
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func setContainerViewConstraints() {
        containerView.edgesToSuperview()
        containerView.widthToSuperview()
    }
    
    private func setGenderStackViewConstraints() {
        genderStackView.edgesToSuperview(excluding: .bottom,
                                         insets: TinyEdgeInsets(top: 30, left: 16, bottom: 0, right: 16),
                                         usingSafeArea: true)
    }
    
    private func setHeightViewConstraints() {
        heightView.height(160)
        heightView.topToBottom(of: genderStackView, offset: 15)
        heightView.trailingToSuperview(offset: 16, usingSafeArea: true)
        heightView.leadingToSuperview(offset: 16, usingSafeArea: true)
    }
    
    private func setHeightLabelConstraints() {
        heightLabel.height(25)
        heightLabel.topToSuperview(offset: 5)
        heightLabel.centerXToSuperview()
    }
    
    private func setHeightValueLabelConstraints() {
        heightValueLabel.topToBottom(of: heightLabel, offset: 10)
        heightValueLabel.leadingToSuperview(offset: 10)
        heightValueLabel.trailingToSuperview(offset: 10)
        heightValueLabel.centerXToSuperview()
    }
    
    private func setHeightSliderConstraints() {
        heightSlider.topToBottom(of: heightValueLabel, offset: 10)
        heightSlider.leadingToSuperview(offset: 16)
        heightSlider.trailingToSuperview(offset: 16)
        heightSlider.bottomToSuperview(offset: -20, relation: .equalOrGreater)
    }
    
    private func setSteppingChangeableStackViewConstraints() {
        steppingChangeableStackView.topToBottom(of: heightView, offset: 15)
        steppingChangeableStackView.leadingToSuperview(offset: 20, usingSafeArea: true)
        steppingChangeableStackView.trailingToSuperview(offset: 20, usingSafeArea: true)
    }
    
    private func setGoToResultsButtonConstraints() {
        goToResultsButton.centerXToSuperview()
        goToResultsButton.width(150)
        goToResultsButton.height(45)
        goToResultsButton.topToBottom(of: steppingChangeableStackView, offset: 40, relation: .equalOrGreater)
        goToResultsButton.bottomToSuperview(offset: -20)
    }
}
