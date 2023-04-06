// [상수, 변수]
var myVariable = 42 // var를 사용하면 변수
myVariable += 42
let yourVariable = 42 // let을 사용하면 상수
// yourVariable += 42 // error

// [타입 지정]
let implicitInteger = 70 // r-value에 의한 타입 추론
let implicitDouble = 70.5
let explicitDouble: Double = 70 // 자동 형변환 된다.
// 실습: 명시적으로 Float 타입인 상수를 만들고 4라는 값을 할당해보자.
let explicitFloat: Float = 4

// [형 변환]
let label = "The width is "
let width = 94
let widthLabel = label + String(width)
// 실습: 위의 코드에서 String 타입 변환 부분을 제거시 어떤 에러가 발생하는가?
// Binary operator '+' cannot be applied to operands of type 'String' and 'Int'

// [문자열 안에 변수 값 적용]
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."
// 실습: \() 를 이용해 인삿말 안에 누군가의 이름을 넣어보자.
let name = "Hyungeun"
let Greet = "Hello my name is \(name)."

// [배열, 딕셔너리]
var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1] = "bottle of water"
var occupations = ["Malcolm":"Captain", "Kaylee":"Mechanic"]
occupations["Jayne"] = "Public Relations" // 딕셔너리에 추가

// [빈 배열과 딕셔너리 선언]
let emptyArray = [String]()
let emptyArray2: [String] = []
let emptyDictionary = Dictionary<String, Float>()
let emptyDictionary2: [String: Float] = [:]

// [옵셔널 변수]
var optionalString: String? = "Hello"
optionalString == nil // false
var optionalName: String? = nil // 옵셔녈 변수는 nil 값을 저장할 수 있는 변수이다.
var greeting = "Hello!"
if let name = optionalName { // non-optional 상수인 name에 optional 변수인 optionalName에 들어있는 값을 할당할 수 있다면 { } 안의 내용을 실행한다.
    greeting = "Hello, \(name)"
}
greeting // 그러므로 변수 greeting에는 "Hello!"가 저장된다.

// [흐름제어]
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 { // 조건식은 반드시 Boolean 표현이여야 한다.
        teamScore += 3
    } else {
        teamScore += 1
    }
}
teamScore

// [Swtich 문]
let vegetable = "red pepper"
switch vegetable {
    case "celery":
        let vegetableComment = "Add some raisins and make ants on a log."
    case "cucumber", "watercress":
        let vegetableComment = "That would make a good tea sandwich."
    case let x where x.hasSuffix("pepper"):
        let vegetableComment = "Is it a spicy \(x)?"
    default:
        let vegetableComment = "Everything tastes good in soup."
}
// 실습: default 문을 제거시 어떤 에러가 발생하는가?
// Switch must be exhaustive

// [for in]
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var type = ""
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            type = kind
        }
    }
}
largest
type

// [for .. < 또는 for ...]
var firstForLoop = 0
for i in 1..<4 { // 1, 2, 3
    firstForLoop += i
}
firstForLoop

var secondLoop = 0
for _ in 1...4 { // 1, 2, 3, 4
    secondLoop += 1
}
secondLoop

// [while]
var n = 2
while n < 100 {
    n = n * 2
}
n

var m = 2
repeat {
    m = m * 2
} while m < 100
m

// [함수]
func greet(name: String, day: String) -> String {
    return "Hello \(name), today is \(day)."
}
greet(name: "Bob", day: "Tuesday")

// [튜플로 반환]
func getGasPrices() -> (Double, Double, Double) {
    return (3.59, 3.69, 3.79)
}
getGasPrices()

// [배열 인자]
func avgOf(numbers: Int...) -> Double { // 배열을 이용하여 여러 개의 값을 함수의 인자로 받을 수 있다.
    var sum = 0
    for number in numbers {
        sum += number
    }
    return Double(sum) / Double(numbers.count)
}
avgOf(numbers: 33, 44, 55, 66)

// [중첩 함수]
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

// [함수도 최상위 타입]
// 함수는 최상위 타입이기 때문에 다른 객체들에 일반적으로 적용 가능한 모든 연산이 가능하다.
// (ex: 다른 함수에 매개변수로 넘기기, 수정하기, 변수에 대입하기 등)
func makeIncrementer() -> (Int) -> Int { // Int 타입의 함수를 리턴하며, 해당 함수는 Int 타입의 값을 리턴한다.
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne // 함수가 다른 함수를 반환할 수 있다.
}
var increment = makeIncrementer() // 함수를 변수에 대입할 수 있다.
increment(7)

func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool { // 함수를 매개변수로 받을 수 있다.
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}

func lessThanTen(number: Int) -> Bool {
    return number < 10
}

var array = [20, 19, 7, 12]
hasAnyMatches(list: array, condition: lessThanTen)

// [클로저]
// 클로저란 이름 없는 함수를 의미한다.
// 중괄호를 묶어서 이름을 지정하지 않고 사용하며 in 키워드를 사용해 인자와 리턴 타입을 분리해 사용한다.
let numbers = [10, 20, 30]
var y = numbers.map(
    {
        (number: Int) -> Int in // (매개변수) -> 반환값
 
        let result = 3 * number
        return result
    }
)
y = numbers.map({ number in 3 * number }) // 추론될 수 있는 모든 것을 생략하여 클로저를 간결화할 수 있다.
y = numbers.map({ 3 * $0 }) // 매개변수 번호를 이용하여 더욱 간결화할 수 있다.
y
// 실습: 모든 홀수 값에 대해 0을 반환하도록 클로저를 수정하라.
y = numbers.map({ if $0 % 2 != 0 { return 0 } else { return $0 } })
y

// [클래스]
class Shape {
    var numberOfSides = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

var shape = Shape(name: "Hyungeun")
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()

class Square: Shape { // 상속
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    var getter_and_setter: Double { // getter와 setter
        get {
            return sideLength
        }
        set {
            sideLength = newValue
        }
    }

    func area() ->  Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String { // 오버라이드
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.getter_and_setter // getter 호출
test.getter_and_setter = 10 // setter 호출
test.area()
test.simpleDescription()

// [열거형]
enum Rank: Int {
    case Ace = 1 // 실제 값이 의미 있는 경우가 아니라면 굳이 제공할 필요가 없다.
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
    //실습: 두개의 Rank 값의 원본 값을 비교하는 함수를 구현하라.
    func compare(other: Rank) -> String {
        if self.rawValue == other.rawValue {
            return "same"
        }
        else {
            return "different"
        }
    }
}
let ace = Rank.Ace
let aceRawValue = ace.rawValue
ace.compare(other: .Jack)

// [구조체]
// 클래스와 구조체의 가장 중요한 차이점 중 하나는 클래스는 참조 복사 형태로 전달되지만 구조체는 값 복사 형태로 전달된다는 것이다.
struct Card {
    var rank: Rank
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .Three)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

// [protocol]
protocol ExampleProtocol { // 자바에서의 인터페이스와 같다.
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += " Now 100% adjusted."
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() { // 구조체의 메서드가 구조체 내부에서 데이터를 수정할 때는 Mutating 키워드를 사용한다.
        simpleDescription += " (adjusted)"
    }
}
var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription

// [Extensiton]
// 기존의 타입에 새로운 속성, 메서드 등을 추가하는 기능이다.
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating public func adjust() {
        self += 42
    }
}
var number = 7
number.adjust()
number.simpleDescription
