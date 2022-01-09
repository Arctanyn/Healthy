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
        return healthParameters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthInfoCell", for: indexPath) as! HealthInfoCell
        switch indexPath.section {
        case 0:
            if let bodyMassIndexValue = healthParameters[.bodyMassIndex] {
                cell.updateContent(with: .bodyMassIndex, and: bodyMassIndexValue)
            }
        case 1:
            if let caloriesValue = healthParameters[.calories] {
                cell.updateContent(with: .calories, and: caloriesValue)
            }
        case 2:
            if let liquidAmount = healthParameters[.liquid] {
                cell.updateContent(with: .liquid, and: liquidAmount)
            }
        default:
            break
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
        switch section {
        case 0:
            return "Индекс Массы Тела (ИМТ)"
        case 1:
            return "Рекомендуемое количество калорий"
        case 2:
            return "Рекомендуемое оличество жидкости"
        default:
            return nil
        }
    }
}
