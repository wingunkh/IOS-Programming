import Foundation

enum DbAction{
    case Add, Delete, Modify // 데이터베이스 변경의 유형
}

protocol Database{
    // 생성자, 데이터베이스에 변경이 생기면 parentNotification를 호출하여 부모에게 알림
    init(parentNotification: ((Record?, DbAction?) -> Void)? )

    // fromDate ~ toDate 사이의 Record을 읽어 parentNotification를 호출하여 부모에게 알림
    func queryRecord(fromDate: Date, toDate: Date)

    // 데이터베이스에 record을 변경하고 parentNotification를 호출하여 부모에게 알림
    func saveChange(record: Record, action: DbAction)
}
