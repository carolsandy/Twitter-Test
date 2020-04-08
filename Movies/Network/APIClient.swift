
import Foundation

class APIClient {
    lazy var session: SessionProtocol = URLSession.shared
    let API_KEY = "2a61185ef6a27f400fd92820ad9e8537"
    let BASE_URL = "https://api.themoviedb.org/3/search/movie?"
    
    func getMovies(with search: String, completion: @escaping(Movies?, Error?) -> Void) {
        let query = "api_key=\(API_KEY)&query=\(search.percentEncoded)"
        guard let url = URL(string: "\(BASE_URL)\(query)") else { fatalError() }
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, WebServiceError.ResponseError)
                return
            }
            guard let jsonData = data else {
                completion(nil, WebServiceError.DataEmptyError)
                return
            }
            do {
                let movies = try JSONDecoder().decode(Movies.self, from: jsonData)
                completion(movies, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension String {
    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^! ").inverted
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        return encoded
    }
}

extension URLSession: SessionProtocol { }

enum WebServiceError: Error {
    case DataEmptyError
    case ResponseError
}
