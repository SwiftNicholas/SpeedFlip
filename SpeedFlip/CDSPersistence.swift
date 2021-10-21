//
//  CDS-PersistenceController.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/25/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation
import CoreData

class CDPersistenceController:NSObject{

    var completion: ()->Void
    var context: NSManagedObjectContext?
    
    init(completion: @escaping (()->Void)){
    
        self.completion = completion
        super.init()
        
        initializeCoreData(completion: completion)
        
    
    }

    func initializeCoreData(completion:()->Void){
    
        if (self.context != nil) {return}
        
    
    }

    

}
