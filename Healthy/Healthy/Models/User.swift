//
//  User.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 03.01.2022.
//

enum Gender: String {
    case male = "Man"
    case female = "Woman"
}

struct User {
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

//extension UserHealth {
//    mutating func setGender(gender: Gender) {
//        self.gender = gender
//    }
//
//    mutating func changeHeightTo(_ height: Int) {
//        self.height = height
//    }
//
//    mutating func changeWeightTo(_ weight: Int) {
//        self.weight = weight
//    }
//
//    mutating func changeAgeTo(_ age: Int) {
//        self.age = age
//    }
//
//}

