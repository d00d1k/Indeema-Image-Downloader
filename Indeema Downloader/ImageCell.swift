//
//  ImageCell.swift
//  Indeema Image Downloader
//
//  Created by Nikita Kalyuzhnyy on 09.12.2020.
//

import Foundation
import UIKit



protocol DelegateProtocolCell {
    func downloadImage(cell: ImageCell)
    func cancelDownloadImage(cell: ImageCell)
}

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadingProgressLabel: UILabel!
    
    var imageURL: String?
    
    var cellDelegate: DelegateProtocolCell? = nil
    
    @IBAction func pressButton(sender: AnyObject) {
        
        if downloadButton.titleLabel!.text == "CANCEL" {
            cellDelegate?.cancelDownloadImage(cell: self)
        } else {
            cellDelegate?.downloadImage(cell: self)
        }
    }
}
