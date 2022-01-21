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
    var height = 196
    var weight = 89
    var age = 18
    var genderType: Gender = .male
    
    var minAge: Int { 5 }
    var maxAge: Int { 100 }
    
    var minWeight: Int { 5 }
    var maxWeight: Int { 420 }
}
