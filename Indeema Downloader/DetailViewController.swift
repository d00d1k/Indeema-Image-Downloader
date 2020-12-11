//
//  DetailViewController.swift
//  iuiui
//
//  Created by Nikita Kalyuzhnyy on 11.12.2020.
//

import UIKit

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailImageView: UIImageView!
    
    
    var detailImageFromSegue : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if detailImageFromSegue != nil {
            detailImageView.image = detailImageFromSegue
        }
    }
}
