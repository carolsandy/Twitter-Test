
import UIKit

class MovieListViewController: UIViewController {
    
    var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
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
        setupNavigationBar()
        movieListViewModel.movieListUI = self
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    private func setupNavigationBar() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "twitterLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func prepareResultsView() {
        if let tableView = tableView {
            tableView.removeFromSuperview()
        }
        tableView = UITableView(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: "MovieTableViewCell")
    }
}

extension MovieListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text, !search.isEmpty {
            movieListViewModel.getMovies(title: search) { error in
                if let _ = error {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "errorLogo")
                        self.label.text = "Oops, try again later!"
                    }
                } else{
                    DispatchQueue.main.async {
                        self.prepareResultsView()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension MovieListViewController: MovieListUI {
    
    func updateCell(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        guard let movie = movieListViewModel.movie(at: indexPath.row) else { return MovieTableViewCell() }
        cell.configCell(with: movie)
        cell.configCell(with: movieListViewModel.getImage(path: movie.posterPath, for: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
