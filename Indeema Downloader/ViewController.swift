//
//  ViewController.swift
//  Indeema Image Downloader
//
//  Created by Nikita Kalyuzhnyy on 09.12.2020.
//

import UIKit



class ViewController:  UITableViewController, DelegateProtocolCell {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    var activeDownloads = [String : DownloadManager]()
    
    var model = [Model]()
    
    var imagesDictionary = [String: String]()
    
    let imagesLinksAndNames = ["Eiffel Tower" : "http://worth1000.s3.amazonaws.com/submissions/555000/555068_fc7b.jpg",
                               "Coliseum" : "http://www.worldfortravel.com/wp-content/uploads/2012/06/The-Colosseum-Airiel-View.jpg",
                               "Moon" : "https://theyoungastronomer.files.wordpress.com/2012/08/img_2340.jpg",
                               "Mustang" : "http://cervinis.com.p8.hostingprod.com/cusphotos/files/Cfakepath00205-09mustang-concept-ram-air-hood01356552182.jpg",
                       "Pyramids of Giza" : "http://moritzdressel.com/wp-content/uploads/2015/08/pyramid-1202350.jpg",
                       "Steve Wozniak" : "http://dao27ppzr58tl.cloudfront.net/wp-content/uploads/2014/05/Steve-Wozniak.jpg",
                       "Running" : "https://stefanhorrer.files.wordpress.com/2012/06/dscf1776.jpg",
                       "Apple" : "https://illmakeitmyself.files.wordpress.com/2011/10/img_9257.jpg",
                       "Uzhhorod" : "http://static.panoramio.com/photos/original/61127236.jpg",
                       "Pikachu Car" : "http://howibecametexan.com/wp-content/uploads/2013/10/IMG_9416.jpg",
                       "Steve Jobs" : "http://static.businessinsider.com/image/560a92f1dd089545578b4684/image.jpg",
                       "Stonehenge" : "http://www.hybridwriter.com/wp-content/uploads/2013/09/IMG_0162.jpg",
                       "Sahara" : "http://nosade.com/wp-content/uploads/Sunrise-Sea-of-sands-Erg-Chebbi-Merzouga-Sahara-desert_Source-NOSADE1.jpg",
                       "Japan" : "https://trinitraveller.files.wordpress.com/2011/03/golden.jpg",
                       "Istanbul" : "http://holidaying.in/wp-content/uploads/2013/12/istanbul.jpg",
                       "Horses" : "https://whoassite.files.wordpress.com/2012/01/namibia-2011-046.jpg",
                       "Lviv" : "https://upload.wikimedia.org/wikipedia/commons/1/1c/Lw%C3%B3w_-_Rynek_01.JPG",
                       "Football" : "https://upload.wikimedia.org/wikipedia/commons/b/b4/StanfordUniversityFootballOffense2007.jpg",
                       "El Capitan" : "https://stargzrblog.files.wordpress.com/2013/04/dscn0817.jpg",
                       "Victoria Falls" : "http://pureafrica.com.au/wp-content/uploads/victoria-falls-canyon-view.jpg",
                       "Great Wall" : "http://dorian.derobert.free.fr/blog/images/TDM_chine/IMG_3766.JPG"]
    
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        model = setModel(imagesLinksAndNames)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let segueIdentifier = "ShowDetails"

        if segue.identifier == segueIdentifier {
            if let destination = segue.destination as? DetailViewController {
                if let cellIndex = tableView.indexPathForSelectedRow?.row {
                    if model[cellIndex].image != nil {
                        destination.detailImageFromSegue = model[cellIndex].image
                    }
                }
            }
        }
    }
    
    func setModel(_ dictionary: [String: String]) -> [Model] {
        
        for (key, value) in dictionary{
            model.append(Model(name: key, link: value))
        }
        return model
    }
    
    //warniing
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue: nil)
        return session
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Image Cell") as? ImageCell else { return UITableViewCell()}
        cell.cellDelegate = self
        let modelItem = model[indexPath.row]
        
        cell.imageLabel.text = modelItem.name
        cell.imageURL = modelItem.link ?? "err"
        
        if let download = activeDownloads[cell.imageURL!] {
            //downloadprogress
            
            let title = download.isDownloading ? "Cancel" : "Start"
            cell.downloadButton.setTitle(title, for: .normal)
        }
        
        if modelItem.image != nil {
            cell.pictureView.image = modelItem.image
        } else {
            cell.pictureView.image = UIImage(named: "no-image.jpeg")
        }
        
        return cell
    }
    
    func startDownload(model: Model) {
        
        if let urlString = model.link, let url =  URL(string: urlString) {

            let download = DownloadManager(url: urlString)

            download.downloadTask = downloadsSession.downloadTask(with: url)
   
            download.downloadTask!.resume()

            download.isDownloading = true

            activeDownloads[download.url] = download
            
        }
    }
    
    func downloadImage(cell: ImageCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let image = model[indexPath.row]
            
            startDownload(model: image)
            
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    func cancelDownloadImage(cell: ImageCell) {
        if let urlString = cell.imageURL,
            let download = activeDownloads[urlString] {
            download.downloadTask?.cancel()
            activeDownloads[urlString] = nil
        }
    }
    
    func localFilePathForUrl(previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), let lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    func localFileExistsForTrack(model: Model) -> Bool {
        if let urlString = model.link, let localUrl = localFilePathForUrl(previewUrl: urlString) {
            var isDir : ObjCBool = false
            let path = localUrl.path
            return FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        }
        return false
    }
    
    func trackIndexForDownloadTask(downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, image) in model.enumerated() {
                if url == image.link {
                    return index
                }
            }
        }
        return nil
    }
}

//extension ViewController {
//    func getRandomImages() {
//        
//        let request = AF.request("https://picsum.photos/v2/list?&limit=20")
//        
//        request.responseJSON { (json) in
//            if let data = json.data {
//                if let json = try? JSON(data: data) {
//                    
//                    for data in json.arrayValue {
//                        
//                        self.imagesDictionary[data["author"].stringValue] = data["download_url"].stringValue
//                        
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                    
//                    
//                }
//            }
//        }
//    }
//}

extension ViewController: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = NSData(contentsOf: location)
        let image = UIImage(data: data! as Data)
        
        if let trackIndex = trackIndexForDownloadTask(downloadTask: downloadTask) {
            
            DispatchQueue.main.async {
                self.model[trackIndex].image = image
                self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        // 1
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl] {

            download.downloadProgresss = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)

            if let trackIndex = trackIndexForDownloadTask(downloadTask: downloadTask), let trackCell = tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? ImageCell {

                DispatchQueue.main.async {
                    trackCell.downloadingProgressLabel.text = String(format: "%.1f%% ",  download.downloadProgresss * 100)
                }
            }
        }
    }
}
