//
//  Instructor.swift
//  RetainCycleExplained
//
//  Created by Atil Samancioglu on 18.02.2023.
//

import Foundation

class Course {
    let name: String // bu sınıfın bi adı olsun
    let url: URL // bi url si olsun
    var instructor: Instructor? // bi de instructoru olsun

    init(name: String, url: URL) { self.name = name; self.url = url }

    deinit { // gerçekten hafızadan siliniyor mu. silindiğinde bu çalışıyor
        print("Course \(name) deinitialized")
    }
}

class Instructor {
    let name: String
    var course: Course?

    init(name: String) { self.name = name }

    deinit {
        print("Instructor \(name) deinitialized")
    }
}
