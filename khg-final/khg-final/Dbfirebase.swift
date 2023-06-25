import Foundation
import UIKit
import Firebase

class DbFirebase: Database {
    var reference: CollectionReference
    var parentNotification: ((Record?, DbAction?) -> Void)?
    var existQuery: ListenerRegistration?

    required init(parentNotification: ((Record?, DbAction?) -> Void)?) {
        self.parentNotification = parentNotification
        reference = Firestore.firestore().collection("records")
    }
}

extension DbFirebase{
    func saveChange(record: Record, action: DbAction){
        if action == .Delete{
            reference.document(record.key).delete()
            return
        }
    
        let data = record.toDict()
        let storeDate: [String : Any] = ["date": record.date, "data": data]
        reference.document(record.key).setData(storeDate)
    }
}

extension DbFirebase{
    func queryRecord(fromDate: Date, toDate: Date) {
        if let existQuery = existQuery{
            existQuery.remove()
        }
        
        let queryReference = reference.whereField("date", isGreaterThanOrEqualTo: fromDate).whereField("date", isLessThanOrEqualTo: toDate)

        existQuery = queryReference.addSnapshotListener(onChangingData)
    }
}

extension DbFirebase {
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?) {
        guard let querySnapshot = querySnapshot else { return }
        
        if querySnapshot.documentChanges.isEmpty {
            if let parentNotification = parentNotification {
                parentNotification(nil, nil)
            }
        }
        
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data()
            
            if let recordData = data["data"] as? [String: Any] {
                let record = Record()
                record.fromDict(dict: recordData)
                
                var action: DbAction?
                switch documentChange.type {
                case .added: action = .Add
                case .modified: action = .Modify
                case .removed: action = .Delete
                }
                
                if let parentNotification = parentNotification {
                    parentNotification(record, action)
                }
            }
        }
    }
}
