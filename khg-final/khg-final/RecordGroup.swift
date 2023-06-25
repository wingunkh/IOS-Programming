import Foundation

class RecordGroup: NSObject {
    var records = [Record]() // 운동 기록 배열
    var fromDate, toDate: Date? // 데이터 조회 범위
    var database: Database! // 데이터베이스 객체
    var parentNotification: ((Record?, DbAction?) -> Void)? // 데이터 변경 알림 콜백

    init(parentNotification: ((Record?, DbAction?) -> Void)?) {
        super.init()
        self.parentNotification = parentNotification
        database = DbFirebase(parentNotification: receivingNotification) // 데이터베이스 생성
    }

    // 데이터베이스에서 데이터 쿼리
    func receivingNotification(record: Record?, action: DbAction?) {
        if let record = record {
            switch(action) {
            case .Add: addRecord(record: record) // 기록 추가
            case .Modify: modifyRecord(modifiedRecord: record) // 기록 수정
            case .Delete: removeRecord(removedRecord: record) // 기록 삭제
            default: break
            }
        }

        if let parentNotification = parentNotification {
            parentNotification(record, action) // 알림 콜백 실행
        }
    }
}

// RecordGroup 클래스의 확장으로, 데이터 조회 및 변경 관련 메서드를 추가로 구현
extension RecordGroup {
    // 지정된 날짜의 데이터 조회
    func queryData(date: Date) {
        records.removeAll() // 기존 데이터 삭제

        fromDate = date.firstOfMonth().firstOfWeek() // 조회 범위 설정
        toDate = date.lastOfMonth().lastOfWeek()
        database.queryRecord(fromDate: fromDate!, toDate: toDate!) // 데이터베이스에서 기록 조회
    }

    // 변경 내용 저장
    func saveChange(record: Record, action: DbAction) {
        database.saveChange(record: record, action: action) // 데이터베이스에 변경 내용 저장
    }
}

// RecordGroup 클래스의 확장으로, 데이터 조회 메서드를 추가로 구현
extension RecordGroup {
    // 특정 날짜에 대한 기록 조회
    func getRecords(date: Date? = nil) -> [Record] {
        if let date = date {
            var recordForDate: [Record] = []
            let start = date.firstOfDay() // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay() // yyyy:mm”dd 23:59:59
            for record in records {
                if record.date >= start && record.date <= end {
                    recordForDate.append(record)
                }
            }
            return recordForDate
        }
        return records // 전체 기록 반환
    }
}

// RecordGroup 클래스의 확장으로, 데이터 관리 메서드를 추가로 구현
extension RecordGroup {
    private func count() -> Int { return records.count } // 기록 수를 반환하는 메서드

    // 특정 날짜가 조회 범위에 속하는지 확인하는 메서드
    func isIn(date: Date) -> Bool {
        if let from = fromDate, let to = toDate {
            return (date >= from && date <= to) ? true: false
        }
        return false
    }

    // 특정 운동 기록의 인덱스를 반환하는 메서드
    private func find(_ key: String) -> Int? {
        for i in 0..<records.count {
            if key == records[i].key {
                return i
            }
        }
        return nil
    }
}

// RecordGroup 클래스의 확장으로, 운동 기록 관리 메서드를 추가로 구현
extension RecordGroup {
    // 기록 추가
    private func addRecord(record:Record) { records.append(record) }

    // 기록 수정
    private func modifyRecord(modifiedRecord: Record) {
        if let index = find(modifiedRecord.key) {
            records[index] = modifiedRecord
        }
    }

    // 기록 삭제
    private func removeRecord(removedRecord: Record) {
        if let index = find(removedRecord.key) {
            records.remove(at: index)
        }
    }

    // 두 개의 운동 기록을 교환하는 메서드
    func changeRecord(from: Record, to: Record) {
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
            records[fromIndex] = to
            records[toIndex] = from
        }
    }
}
