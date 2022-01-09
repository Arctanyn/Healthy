//
//  HealthInfoCell.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 09.01.2022.
//

import UIKit
import Foundation

class HealthInfoCell: UITableViewCell {

    @IBOutlet weak var healthParamImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptiobLabel: UILabel!
    
    func updateContent(with healthType: HealthParametersType, and healthParamValue: Double) {
        
        switch healthType {
        case .bodyMassIndex:
            titleLabel.text = "ИМТ - \(round(Double(healthParamValue) * 100) / 100)"
            healthParamImageView.image = UIImage(named: "weighing-scale.icon")
            descriptiobLabel.text = discoverBMIType(healthParamValue).rawValue
        case .calories:
            titleLabel.text = "\(Int(healthParamValue)) Ккал"
            healthParamImageView.image = UIImage(named: "food.icon")
            descriptiobLabel.text = "Рекомендуемая суточная норма калорий"
        case .liquid:
            titleLabel.text = "\(round(Double(healthParamValue) * 100) / 100) л"
            healthParamImageView.image = UIImage(named: "water-bottle.icon")
            descriptiobLabel.text = "Около \(Int(round(healthParamValue * 1000 / 250))) кружек"
        }
    }

}


