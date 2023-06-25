//import Foundation
//
//class DbMemory: Database{
//    private var storage: [Plan] // 데이터 저장소
//
//    // storage 내의 데이터 변화가 있으면 이 함수를 호출해야 한다.
//    var parentNotification: ((Plan?, DbAction?) -> Void)?
//
//    // required 라는 것은 이 클래스가 Database를 만족하여야 하기 때문이다.
//    required init(parentNotification: ((Plan?, DbAction?) -> Void)?) {
//
//        self.parentNotification = parentNotification
//
//        storage = []
//        // 100개의 가상 데이터를 만든다. (현재 기준으로 -50일 ~ +50일 사이에 랜덤)
//        let amount = 10
//        for _ in 0..<amount{
//            let delta = Int(arc4random_uniform(UInt32(amount))) - amount/2
//            let date = Date(timeInterval: TimeInterval(delta*24*60*60), since: Date())
//            storage.append(Plan(date: date, withData: true))
//        }
//    }
//}
//
//extension DbMemory{
//    func queryPlan(fromDate: Date, toDate: Date) {
//
//        for i in 0..<storage.count{
//            if storage[i].date >= fromDate && storage[i].date <= toDate{
//                if let parentNotification = parentNotification{
//        parentNotification(storage[i], .Add) // 한개씩 여러번 전달한다
//                }
//            }
//        }
//    }
//}
//
//extension DbMemory{
//    func saveChange(plan: Plan, action: DbAction){
//        if action == .Add{
//            storage.append(plan)
//        }else{
//            for i in 0..<storage.count{
//                if plan.key == storage[i].key{
//                    if action == .Delete{ storage.remove(at: i) }
//                    if action == .Modify{ storage[i] = plan }
//                    break
//                }
//            }
//        }
//        if let parentNotification = parentNotification{
//            parentNotification(plan, action)
//        }
//    }
//}
