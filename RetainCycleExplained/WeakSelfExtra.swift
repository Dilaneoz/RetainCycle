//
//  WeakSelfExtra.swift
//  RetainCycleExplained
//
//  Created by Atil Samancioglu on 18.02.2023.
//

import Foundation

//
//  WeakSelfClosures.swift
//  RetainCycleExplained
//
//  Created by Atil Samancioglu on 18.02.2023.

// weak e benzer bir de unowned yapısı var. bu pek tavsiye edilmiyor. bi şeyi weak yaptığımızda her şey optional olur, self bile. unowned yaparak bazıları optional larla uğraşmak istemez. ama weak kullanmakta fayda vardır çünkü bi şeyin bi noktada nil olucağını düşünüyosak, o zaman weak kullanabiliriz ve retain cycle(Retain cycle iki nesnenin birbirini strong olarak çağırmasıyla oluşur) olayına girmeyiz. unowned kullanırsak nil olmayacak olsa bile onu temizlemenin yolunu ararız ve bağlantı koptuysa temizleriz. ama bu doğru kullanılmazsa crash lere yol açabilir çünkü bu sefer temizlenmemesi gereken bi şeyi de temizlettirebiliriz. o yuzden ne yaptığımızı bilmiyorsak unowned a girmemeliyiz. 
import Foundation


struct LaunchedCourse2 {
    let title: String
    var isLaunched: Bool = false

    init(title: String) { self.title = title }
}

class WeakCourse3 {
    let name: String
    let url: URL
    weak var instructor: WeakInstructor3?
    
    var launchedCourses: [LaunchedCourse2] = []
    var onLaunched: ((_ launchedCourse2: LaunchedCourse2) -> Void)? // bu değişkeni oluşturarak weak yapısını doğru kullanabilicez. hem "1 "verisi alınacak hem de hafızadan eninde sonunda silindi

    init(name: String, url: URL) {
        self.name = name
        self.url = url
        
        //adding onLaunched with weak self does not cause cycle retain
        // if we remove [weak self] you will the 1 but you won't see deinits
        onLaunched = { [weak self] launchedCourse2 in
            self?.launchedCourses.append(launchedCourse2)
            print("Launched course2 count is now: \(self?.launchedCourses.count)")
        }
        
    }
    
    func launch(launchedCourse2: LaunchedCourse2) { // bu fonksiyon bu şekilde yazılınca launch2 deki gibi olmuyo veri optional olarak da olsa alınabiliyor çünkü bu fonksiyonu değil burada strong referance var, onLaunched ı weak yaptık. onLaunched diye yeni bi closure ekledik. launch ın içinde bu onLaunched çalıştırılıyor. onLaunched da init te weak olarak çalıştırılıyor. bu yuzden aldığımız veriyi diziye ekleyebiliyoruz. "1" değeri bize burada optional olarak gelir. bu şekilde weak doğru şekilde kullanılabilir
        //async after to simulate network request
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.onLaunched?(launchedCourse2)
                
            }
        }
     
    
    deinit {
        print("WeakCourse3 \(name) deinitialized")
    }
}

class WeakInstructor3 {
    let name: String
    var course: WeakCourse3?

    init(name: String) { self.name = name }

    deinit {
        print("WeakInstructor3 \(name) deinitialized")
    }
}
