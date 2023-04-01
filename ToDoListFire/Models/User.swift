//
//  User.swift
//  ToDoListFire
//
//  Created by Buba on 01.04.2023.
//

import Foundation
import Firebase

struct UserFire {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
