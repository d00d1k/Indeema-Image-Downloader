//
//  Model.swift
//  iuiui
//
//  Created by Nikita Kalyuzhnyy on 11.12.2020.
//

import Foundation
import UIKit

class Model {
        
    var name : String
    var link : String?
    var image : UIImage?
     
    init(name: String?, link: String){
        self.name = name ?? "err"
        self.link = link
    }
}
