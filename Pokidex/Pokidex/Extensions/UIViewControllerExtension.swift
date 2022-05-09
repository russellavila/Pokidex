//
//  UIViewControllerExtension.swift
//  Pokidex
//
//  Created by Consultant on 5/4/22.
//

import UIKit

extension UIViewController {
    
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: This is an example function for a throwing function, not actually used in this project. Provided example error input. Provided example way for calling it.
    
    /*
     do {
         let value = try exampleFunction(arr: [1,2,3,4], index: 10)
     } catch {
         print(error)
     }
     */

    // arr = [1,2,3,4], index = 10
    func exampleFunction(arr: [Int], index: Int) throws -> Int {
        guard (0..<arr.count).contains(index) else {
            throw SampleError.IndexOutofBounds
        }
        return arr[index]
    }
    
    
}

// MARK: Sample Error for the above throw example
enum SampleError: Error {
    case IndexOutofBounds
}
