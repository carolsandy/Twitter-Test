
import Foundation

protocol MovieListViewModel {
    var count: Int { get }
    var movieListUI: MovieListUI? { get set }
    func movie(at index: Int) -> Movie?
    func getMovies(title: String, completion: @escaping (Error?) -> Void)
    func getImage(path: String?, for index: Int) -> Result<Data?, Error>
}

protocol MovieListUI: AnyObject {
    func updateCell(at index: Int)
}

class MovieListViewModelConcrete: MovieListViewModel {
    
    weak var movieListUI: MovieListUI?
    var count: Int { return movies?.movies.count ?? 0}
    
    private var movies: Movies?
    private var apiClient: APIClient
    private var downloadingImages = [ImageLoader]()
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func movie(at index: Int) -> Movie? {
        return movies?.movies[index]
    }
    
    func getMovies(title: String, completion: @escaping (Error?) -> Void) {
        movies = nil
        cleanDownloadingImages()
    }
    
    func getImage(path: String?, for index: Int) -> Result<Data?, Error> {
        if index >= downloadingImages.count {
            let imageLoader = ImageLoader()
            downloadingImages.append(imageLoader)
            imageLoader.getImageWithPath(path: path) {
                self.completionHandler(index: index)
            }
        } else if let error = downloadingImages[index].error {
            return .failure(error)
        } else if let imageData = downloadingImages[index].imageData {
            return .success(imageData)
        }
        return .success(nil)
    }
    
    private func cleanDownloadingImages() {
        for imageLoader in downloadingImages { imageLoader.session.invalidateAndCancel() }
        downloadingImages = []
    }
    
    private func completionHandler(index: Int) {
        movieListUI?.updateCell(at: index)
    }
}
