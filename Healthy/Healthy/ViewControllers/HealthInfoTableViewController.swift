//
//  HealthInfoTableViewController.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 09.01.2022.
//

import UIKit

class HealthInfoTableViewController: UITableViewController {

    //MARK: -Properties
    private var healthParameters: [HealthParametersType : Double] = [:]
    private var healthParametersType: [HealthParametersType] = [
        .bodyMassIndex,
        .calories,
        .liquid
    ]
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Результаты"
    }
    
    //MARK: Methods
    func loadParameters(of user: User) {
        var healthInfo = HealthInfo(user: user)
        healthParameters = healthInfo.getParameters()
    }
}

// MARK: - Table view data source
extension HealthInfoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return healthParametersType.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthInfoCell", for: indexPath) as! HealthInfoCell
        
        let currentHealthType = healthParametersType[indexPath.section]
        
        switch currentHealthType {
        case .bodyMassIndex:
            if let bodyMassIndexValue = healthParameters[currentHealthType] {
                cell.updateContent(with: currentHealthType, and: bodyMassIndexValue)
            }
        case .calories:
            if let caloriesValue = healthParameters[currentHealthType] {
                cell.updateContent(with: currentHealthType, and: caloriesValue)
            }
        case .liquid:
            if let liquidAmount = healthParameters[currentHealthType] {
                cell.updateContent(with: currentHealthType, and: liquidAmount)
            }
        }
        
        return cell
    }
}

//MARK: -Table view delegate
extension HealthInfoTableViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let currentType = self.healthParametersType[section]
        
        switch currentType {
        case .bodyMassIndex:
            return "Индекс Массы Тела (ИМТ)"
        case .calories:
            return "Рекомендуемое количество калорий"
        case .liquid:
            return "Рекомендуемое количество жидкости"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}
