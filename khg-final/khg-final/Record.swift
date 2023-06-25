import Foundation
import FirebaseFirestore

// 운동 종류를 열거형으로 정의
class Record: NSObject, Codable {
    enum Exercise: Int, Codable {
        case e1 = 0, e2, e3, e4, e5
        
        // 각 경우에 대한 문자열을 반환하는 메서드
        func toString() -> String {
            switch self {
            case .e1: return "등"
            case .e2: return "이두"
            case .e3: return "삼두"
            case .e4: return "가슴"
            case .e5: return "하체"
            }
        }
        
        // 모든 경우를 배열로 반환
        static var allCases: [Exercise] {
            return [.e1, .e2, .e3, .e4, .e5]
        }
        
        // 경우의 수를 반환
        static var count: Int { return Exercise.e5.rawValue + 1 }
    }
    
    enum Back: Int, Codable {
        case b1 = 0, b2, b3, b4, b5
        
        func toString() -> String {
            switch self {
            case .b1: return "풀 업"
            case .b2: return "랫 풀 다운"
            case .b3: return "데드 리프트"
            case .b4: return "시티드 로우"
            case .b5: return "덤벨 로우"
            }
        }
        
        static var allCases: [Back] {
            return [.b1, .b2, .b3, .b4, .b5]
        }
        
        static var count: Int { return Back.b5.rawValue + 1 }
    }
    
    enum Biceps: Int, Codable {
        case b1 = 0, b2, b3, b4, b5
        
        func toString() -> String {
            switch self {
            case .b1: return "바벨 컬"
            case .b2: return "덤벨 컬"
            case .b3: return "해머 컬"
            case .b4: return "케이블 컬"
            case .b5: return "머신 컬"
            }
        }
        
        static var allCases: [Biceps] {
            return [.b1, .b2, .b3, .b4, .b5]
        }
        
        static var count: Int { return Biceps.b5.rawValue + 1 }
    }
    
    enum Triceps: Int, Codable {
        case t1 = 0, t2, t3, t4, t5
        
        func toString() -> String {
            switch self {
            case .t1: return "오버헤드 익스텐션"
            case .t2: return "트라이셉스 익스텐션"
            case .t3: return "트라이셉스 킥 백"
            case .t4: return "푸시 다운"
            case .t5: return "클로즈 그립 벤치 프레스"
            }
        }
        
        static var allCases: [Triceps] {
            return [.t1, .t2, .t3, .t4, .t5]
        }
        
        static var count: Int { return Triceps.t5.rawValue + 1 }
    }
    
    enum Chest: Int, Codable {
        case c1 = 0, c2, c3, c4, c5
        
        func toString() -> String {
            switch self {
            case .c1: return "벤치 프레스"
            case .c2: return "덤벨 프레스"
            case .c3: return "체스트 프레스"
            case .c4: return "푸시 업"
            case .c5: return "딥스"
            }
        }
        
        static var allCases: [Chest] {
            return [.c1, .c2, .c3, .c4, .c5]
        }
        
        static var count: Int { return Chest.c5.rawValue + 1 }
    }
    
    enum Leg: Int, Codable {
        case l1 = 0, l2, l3, l4, l5
        
        func toString() -> String {
            switch self {
            case .l1: return "스쿼트"
            case .l2: return "런지"
            case .l3: return "레그 프레스"
            case .l4: return "레그 익스텐션"
            case .l5: return "카프 레이즈"
            }
        }
        
        static var allCases: [Leg] {
            return [.l1, .l2, .l3, .l4, .l5]
        }
        
        static var count: Int { return Leg.l5.rawValue + 1 }
    }
    
    var key: String // 운동 기록의 고유 식별자
    var date: Date // 운동 기록 날짜
    var exercise: Exercise // 운동 종류
    var content: String // 기록 내용
    var weight: String // 중량
    var repetitions: String // 반복 횟수
    var sets: String // 세트 수
    
    init(date: Date, exercise: Exercise, content: String, weight: String, repetitions: String, sets: String) {
        self.key = UUID().uuidString // 고유 식별자 생성
        self.date = date
        self.exercise = exercise
        self.content = content
        self.weight = weight
        self.repetitions = repetitions
        self.sets = sets
        super.init()
    }
    
    // JSON 인코딩 및 디코딩을 위한 CodingKeys
    private enum CodingKeys: String, CodingKey {
        case key, date, exercise, content, weight, repetitions, sets
    }
}

// Record 클래스의 확장으로, 편의 이니셜라이저와 복제, 사전 변환 관련 메서드를 추가로 구현
extension Record {
    // 특정 날짜에 대한 랜덤 기록을 생성하는 편의 이니셜라이저
    convenience init(date: Date? = nil, withData: Bool = false) {
        if withData == true {
            let index = Int.random(in: 0..<Exercise.count)
            let exercise = Exercise(rawValue: index)!
            let content = ""
            let weight = ""
            let repetitions = ""
            let sets = ""
            
            self.init(date: date ?? Date(), exercise: exercise, content: content, weight: weight, repetitions: repetitions, sets: sets)
        } else {
            self.init(date: date ?? Date(), exercise: .e1, content: "", weight: "", repetitions: "", sets: "")
        }
    }
}

// Record 클래스의 확장으로, 복제 메서드를 구현
extension Record {
    // 현재 인스턴스를 복제하는 메서드
    func clone() -> Record {
        let clonee = Record(date: date, exercise: exercise, content: content, weight: weight, repetitions: repetitions, sets: sets)
        clonee.key = self.key
        clonee.date = self.date
        clonee.exercise = self.exercise
        clonee.content = self.content
        clonee.weight = self.weight
        clonee.repetitions = self.repetitions
        clonee.sets = self.sets
        return clonee
    }
}

// Record 클래스의 확장으로, 사전 변환 관련 메서드를 구현
extension Record {
    // 현재 인스턴스를 사전 형태로 변환하는 메서드
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["key"] = key
        dict["date"] = date
        dict["exercise"] = exercise.toString()
        dict["content"] = content
        dict["weight"] = weight
        dict["repetitions"] = repetitions
        dict["sets"] = sets
        return dict
    }
    
    // 사전을 기반으로 현재 인스턴스를 초기화하는 메서드
    func fromDict(dict: [String: Any]) {
        //key = dict["key"] as! String
        if let key = dict["key"] as? String {
              self.key = key
          } else {
              self.key = ""
          }
        
        if let timestamp = dict["date"] as? FirebaseFirestore.Timestamp {
            date = timestamp.dateValue() // Timestamp를 Date로 변환
        }
        
        exercise = {
            if let exerciseString = dict["exercise"] as? String {
                switch exerciseString {
                case Exercise.e1.toString():
                    return .e1
                case Exercise.e2.toString():
                    return .e2
                case Exercise.e3.toString():
                    return .e3
                case Exercise.e4.toString():
                    return .e4
                case Exercise.e5.toString():
                    return .e5
                default:
                    return .e1
                }
            }
            
            else if let exerciseRawValue = dict["exercise"] as? Int {
                return Exercise(rawValue: exerciseRawValue) ?? .e1
            } else {
                return .e1
            }
        }()
        content = dict["content"] as? String ?? ""
        weight = dict["weight"] as? String ?? ""
        repetitions = dict["repetitions"] as? String ?? ""
        sets = dict["sets"] as? String ?? ""
    }
}
