//
//  WeakSelfClosures.swift
//  RetainCycleExplained
//
//  Created by Atil Samancioglu on 18.02.2023.
//

import Foundation

// structlar valuetype classlar referance type o yuzden structlarda güçlü ya da zayıf referanslarla/bağlantılarla uğraşmamıza gerek yok, uğraşamayız zaten. referanse yok burada. ayrı instance oluşturuyo her seferinde o yuzden structlarla çalışmanın bi avantajı da bu
struct LaunchedCourse {
    let title: String
    var isLaunched: Bool = false

    init(title: String) { self.title = title }
}

class WeakCourse2 {
    let name: String
    let url: URL
    weak var instructor: WeakInstructor2?
    
    var launchedCourses: [LaunchedCourse] = [] // bu diziye eklemeler yapıcaz

    init(name: String, url: URL) { self.name = name; self.url = url }
    /*
    //if you do not add weak self, it will show 1 course
    func launch(launchedCourse: LaunchedCourse) {
        //async after to simulate network request
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.launchedCourses.append(launchedCourse)
                print("Launched course count is now: \(self.launchedCourses.count)")
            }
        }
     */
    
    //if you update the function with [weak self] it will be nil
    
    func launch2(launchedCourse: LaunchedCourse)  { // bu fonksiyon internete bi istek atıyor ve o istek atıldıktan sonra launch edilmiş oluyo. bunu alıp üstteki diziye ekliycez
        //async after to simulate network request
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in // asyncAfter(deadline: .now() + 1) bu bir deadline dan 1 saniye sonra bunu işleme alıyor. bu bir sn sonra çalışsın ki şeyi simüle edelim yani internete istek attığımızda 0.0001 sn de cevap bize dönmüyor gecikme olabiliyor. o yuzden main.async yapmadık asyncAfter yaptık çünkü cevap bi sn sonra gelsin istiyoruz. burayı weak yaptığımızda bu closure un  kendisini de weak hale getirebiliyoruz
                self?.launchedCourses.append(launchedCourse) // self de weak oldu o yüzden optional a çevirmek zorunda kaldık çünkü deinit edildiyse bu ulaşılamıyor weak iken. bu fonksiyon weak değilken self optional değildi. o yüzden bu fonksiyonda weak kullanımı doğru değil çünkü launchedCourse nil gelicektir ama bi tane eklemiştik. biz o cevabı alıp bu objeye onu verene kadar deinit olduğu için sıkıntı çıktı. kullanıcıya veri ulaşmadı. launch fonksiyonunda weak in doğru şekilde nasıl kullanılacağı anlatılıyor
                print("Launched course count is now: \(self?.launchedCourses.count)") // kaç tane olduğunu yazdırıcaz. bi tane eklediğimizde yani bu fonksiyonu bi defa çalıştırdığımzıda 1 yazması lazım
            }
        }
    
    deinit {
        print("WeakCourse2 \(name) deinitialized")
    }
}

class WeakInstructor2 {
    let name: String
    var course: WeakCourse2?

    init(name: String) { self.name = name }

    deinit {
        print("WeakInstructor2 \(name) deinitialized")
    }
}
