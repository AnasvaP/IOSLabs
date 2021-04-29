//
//  ParseJSON.swift
//  mobileDevelopmentLab1.1
//
//  Created by Anastasiia Poliukovych on 15.02.2021.
//

import Foundation

class ParseBooksListJSON {
    
    var onCompletion : ( (currentData) -> Void )?
    
    func getData(forResource resource : String){
        if let path = Bundle.main.path(forResource: resource, ofType: "txt")  {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                if let currentData = self.parseJSON(withData: data) {
                    self.onCompletion?(currentData)
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    
    func parseJSON(withData data: Data) -> currentData? {
        do {
            let fileData = try JSONDecoder().decode(Github.self, from: data)
            if let currentData = currentData(model: fileData) {
                return currentData
            } else {
                return nil
            }
            
        } catch let error as NSError {
            print("error = ", error)
        }
        return nil
    }
}

