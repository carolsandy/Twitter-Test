
import UIKit

class MovieListViewController: UIViewController {
    
    var tableView: UITableView!
    
    private var searchController: UISearchController!
    private var movieListViewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        movieListViewModel = viewModel
        super.init(nibName: "MovieListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()

    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
}

extension MovieListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("here")
    }
}
