import Foundation

struct Movie: Decodable, Equatable {
    let title: String
    let overview: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case overview
        case posterPath = "poster_path"
    }
}

func == (lhs: Movie, rhs: Movie) -> Bool {
    if lhs.title != rhs.title {
        return false
    }
    if lhs.overview != rhs.overview {
        return false
    }
    if lhs.posterPath != rhs.posterPath {
        return false
    }
    return true
}

struct Movies: Decodable {
    var count: Int
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case count = "total_results"
        case movies = "results"
    }
}
