//
//  Task.swift
//  ToDoListFire
//
//  Created by Buba on 01.04.2023.
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let reference: DatabaseReference?
    var comleted = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.reference = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as? String ?? ""
        userId = snapshotValue["userId"] as? String ?? ""
        reference = snapshot.ref
        comleted = snapshotValue["comleted"] as? Bool ?? false
    }
    
    func convertToDictionary() -> [String: Any] {
        ["title": title, "userId": userId, "comleted": comleted]
    }
}
