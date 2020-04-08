
import Foundation

class ImageLoader {
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var IMAGE_BASE = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    var imageData: Data!
    var error: Error?
    
    init() {
        session = URLSession.shared
    }
    
    func getImageWithPath(path: String?, completionHandler: @escaping ()->()) {
        guard let imgPath = path else {
            error = NSError(domain: "Empty path", code: 123, userInfo: nil)
            completionHandler()
            return
        }
        guard let url = URL(string: "\(IMAGE_BASE)\(imgPath)") else { fatalError() }
        task = session.downloadTask(with: url, completionHandler: { (urlResponse, response, error) in
            if let error = error {
                self.error = error
            } else if let data = try? Data(contentsOf: url) {
                self.imageData = data
            }
            DispatchQueue.main.async {
                completionHandler()
            }
        })
        task.resume()
    }
}
