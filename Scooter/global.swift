//
//  global.swift
//  Scooter
//
//  Created by Sherif on 10/13/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import Foundation

class Global {
    var isBta3:Bool?
    var pUid : String?
    var dUid : String?
    
    private static let _instance = Global()
    
    public init() {
        
    }
    
    static var Instance: Global {
        return _instance
    }

    var isRider: Bool {
        get{
            return self.isRider
        }
        set(v){
            self.isRider = v;
        }
    }
    
    func setPUID (pUID : String ) -> Void {
        self.pUid = pUID
    }
    
    func getPUID () -> String {
        return self.pUid!
    }
    
    func setDUID (dUID : String ) -> Void {
        print(dUID)
        self.dUid = dUID
        print(self.dUid ?? "Not Read")
    }
    
    func getDUID () -> String {
        //print(self.dUid)
        if self.dUid != nil{
            return self.dUid!
        }
        print ("Cant Be Returned")
        return "Cant Be Returned"
    }

    

}


