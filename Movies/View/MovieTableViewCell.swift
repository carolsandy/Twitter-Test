import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    @IBOutlet private var thumbnailImage: UIImageView!
    @IBOutlet private var indicator: UIActivityIndicatorView!
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
    
    func configCell(with result: Result<Data?, Error>) {
        switch result {
        case .failure(_):
            thumbnailImage.image = UIImage(named: "twitterLogo")
        case .success(let imageData):
            if let data = imageData {
                thumbnailImage.image = UIImage(data: data)
            } else {
                thumbnailImage.image = nil
                
            }
        }
        return (thumbnailImage.image == nil) ? indicator.startAnimating() : indicator.stopAnimating()
    }
}
