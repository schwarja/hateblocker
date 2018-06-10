//
//  FirebaseExtension.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import Firebase
import FirebaseDatabase

extension DataSnapshot {
    var data: Data? {
        guard let value = self.value else {
            return nil
        }
        
        return try? JSONSerialization.data(withJSONObject: value, options: [])
    }
}
