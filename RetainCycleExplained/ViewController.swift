//
//  ViewController.swift
//  RetainCycleExplained
//
//  Created by Atil Samancioglu on 18.02.2023.
//

import UIKit
// arc(automatic reference counting) uygulamamızın hafızasının yönetilmesi için geliştirilmiş bir sistem. örneğin hafızada bi obje oluşturuyoruz bi sınıftan, o obje bi yerden sonra nil oluyo diyelim, nil olunca o objenin artık hafızada yer kaplaması gereksizdir. bi sistem olmalı ve onu temizlemeli. buna garbage collection denir. bu temizlik işlemini yapan sistem swiffte arc. arc önemli çünkü bu temizleme işlemini manuel yapmamıza gerek kalmıyor. biz bi değeri nil yaptıysak geliyo temizliyo. bazı durumlarda bi şeyi nil yapsak bile hafızadan silinemiyor(güçlü bir bağ varsa). bunu çözmenin yolları var. mesela weak referances. hafızada boşuna tutulmasını istemediğimiz ya da bazı yerlerde delegate mantığında çalışırken output vb yapılarda kullandığımız, zamanı geldiğinde initialize eden zamanı geldiğinde deinitialize eden bir yapı. fakat bunu her yerde kullanmamak gerekiyor. yanlış kullanırsak yanlış sonuçlara sebep verebilir. özellikle bazı yapılarda -bi tarafın strong bağlı bi tarafın weak bağlı olduğu durumlarda nil olduğunda deinitialize edilebildiğini görücez
// güçlü bağlantı her zaman kötü bişi değildir. bazı yazılımcılar bazen her şeye weak koyma eğilimine girebiliyor. launch2 fonksiyonundaki örnekte bunu görüyoruz
// struct larda weak yapısıyla işimiz yok, class larda var
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //strong reference can cause retain cycle
        //https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/

        var course: Course? = Course(name: "iOS Course", url: URL(string: "www.atilsamancioglu.com")!)
        var instructor: Instructor? = Instructor(name: "Atil Samancioglu")

        // burada güçlü bağlantı var
        course!.instructor = instructor
        instructor!.course = course

        //nothing prints, because of retain cycle
        course = nil // normalde course u nil yapınca bunu deinit edebilir yani silme çalışır ama yukarıdaki kodlarda güçlü bağlantı olduğu için retain cycle(hafızada bunu tutmak için döngüye sokuyor) yapabiliyor. bi tane değişken olsa önemli olmazdı ama internetten yüzbin satırlık veri indirdiğimizde ya da çok daha karmaşık bi işlem yaptığımızda önemli hale gelebiliyor. o yüzden strong yerine weak bağlantı kurulabilir
        instructor = nil


        //weak version

        var weakCourse: WeakCourse? = WeakCourse(name: "iOS Course", url: URL(string: "www.atilsamancioglu.com")!) // weak yaptığımız için deinit oldu yani silme işlemi tamam. weak i genelde internetten büyük veriler indirirken, closure larda ya da dispath.queue.async yapılırken kullanırlar
        var weakInstructor: WeakInstructor? = WeakInstructor(name: "Atil Samancioglu")

        weakCourse!.instructor = weakInstructor
        weakInstructor!.course = weakCourse

        //now it prints
        weakCourse = nil
        weakInstructor = nil



        //weak self examples

        var weakCourse2: WeakCourse2? = WeakCourse2(name: "iOS Course", url: URL(string: "www.atilsamancioglu.com")!)
        var weakInstructor2: WeakInstructor2? = WeakInstructor2(name: "Atil Samancioglu")

        weakCourse2!.instructor = weakInstructor2
        weakInstructor2!.course = weakCourse2

        //launched course count is now 1 printed
        //weakCourse2!.launch(launchedCourse: LaunchedCourse(title: "iOS"))
        
        //launched course count is now nil printed. now this is not good because weakcourse2 is not deinitialized and we are not going to be able to update launched courses since we are waiting for network to response. so we should use weak self wisely
        weakCourse2!.launch2(launchedCourse: LaunchedCourse(title: "iOS")) // bunu alıp LaunchedCourse array ine ekleyecek ve bize her seferinde "1" print ettiricek. weakselfclosures taki launch2 fonksiyonuyla bağlantılı

        weakCourse2 = nil
        weakInstructor2 = nil
        
        
        //Weak self right usage examples
        
        var weakCourse3: WeakCourse3? = WeakCourse3(name: "iOS Course", url: URL(string: "www.atilsamancioglu.com")!)
        var weakInstructor3: WeakInstructor3? = WeakInstructor3(name: "Atil Samancioglu")

        weakCourse3!.instructor = weakInstructor3
        weakInstructor3!.course = weakCourse3

        
        weakCourse3!.launch(launchedCourse2: LaunchedCourse2(title: "iOS"))

        weakCourse3 = nil
        weakInstructor3 = nil
 

    }


}

