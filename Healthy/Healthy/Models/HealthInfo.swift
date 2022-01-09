//
//  HealthInfo.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 09.01.2022.
//
import Foundation

enum BMIClassification: String {
    case deficit = "Недостаток веса"
    case normal = "Нормальный вес"
    case excess = "Избыточный вес"
    case obesityFirstDegree = "Ожирение 1 степени"
    case obesitySecondDegree = "Ожирение 2 степени"
    case obesityThirdDegree = "Ожирение 3 степени"
}

enum HealthParametersType {
    case bodyMassIndex
    case calories
    case liquid
}

//MARK: -Health Data
struct HealthInfo {
    private let user: User
    private lazy var bodyMassIndex: Double = calculateBMI()
    private lazy var requiredCalorieAllowance: Double = calculateCalories()
    private lazy var requiredLiquidAmount: Double = calculateLiquid()
    
    init(user: User) {
        self.user = user
    }
    
    mutating func getParameters() -> [HealthParametersType : Double] {
        let healthParameters: [HealthParametersType : Double] = [
            .bodyMassIndex : bodyMassIndex,
            .calories : requiredCalorieAllowance,
            .liquid : requiredLiquidAmount
        ]
        return healthParameters
    }
}

//MARK: -Private methods
extension HealthInfo {
    private func calculateBMI() -> Double {
        let weightValue = Double(user.weight)
        let height = Double(user.height) / 100
        let BMI = weightValue / (height * height)
        return BMI
    }
    
    private func calculateCalories() -> Double {
        let weightParam = 9.99 * Double(user.weight)
        let heightParam = 6.25 * Double(user.height)
        let ageParam = 4.92 * Double(user.age)
        let additionalValue = user.genderType == .male ? 5 : -161
        let BMR = weightParam + heightParam - ageParam + Double(additionalValue)
        return BMR
    }
    
    private func calculateLiquid() -> Double {
        let bodyShareValue: Double!
        switch user.genderType {
        case .male:
            bodyShareValue = 0.04
        case .female:
            bodyShareValue = 0.03
        }
        return Double(user.weight) * bodyShareValue
    }
}

func discoverBMIType(_ bmi: Double) -> BMIClassification {
    if bmi < 18.5 {
        return .deficit
    } else if (18.5...24.9).contains(bmi) {
        return .normal
    } else if (25.0...29.9).contains(bmi) {
        return .excess
    } else if (30.0...34.9).contains(bmi) {
        return .obesityFirstDegree
    } else if (35.0...39.9).contains(bmi) {
        return .obesitySecondDegree
    } else {
        return .obesityThirdDegree
    }
}
