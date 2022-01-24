//
//  User.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 09.01.2022.
//

enum Gender: String, Codable {
    case male = "Man"
    case female = "Woman"
}

struct User: Codable {
    var gender: Gender = .male
    var height = 180
    var weight = 78
    var age = 29
    var genderType: Gender = .male
    
    var minAge: Int { 5 }
    var maxAge: Int { 100 }
    
    var minWeight: Int { 5 }
    var maxWeight: Int { 420 }
}
