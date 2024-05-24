import UIKit

protocol PagesPerSheetOptionCellDelegate: AnyObject {
    func pagesPerSheetOptionCell(cell: PagesPerSheetOptionCell, didChangePagesPerSheetTo pages: Int)
}

class PagesPerSheetOptionCell: UICollectionViewCell {
    static let identifier = "PagesPerSheetOptionCell"
    weak var delegate: PagesPerSheetOptionCellDelegate?
    
    // UI Components
    let layout = UICollectionViewFlowLayout()
    let pagesPerSheetLabel = UILabel()
    var pagesPerSheetCollectionView: UICollectionView!
    
    // Data Source for Collection View
    let pagesOptions = [1, 2, 4, 6, 9, 16]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLabels()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabels() {
        // Set up the 'Pages per sheet' label
        pagesPerSheetLabel.text = NSLocalizedString("PegesPerSheetOptionCell.Title", comment: "Pages per sheet")
        pagesPerSheetLabel.font = Fonts.SFProDisplay.medium(size: 17.scale) // Custom font with .scale
        pagesPerSheetLabel.textAlignment = .left
        pagesPerSheetLabel.textColor = Appearance.black // Set text color to Appearance.black
        pagesPerSheetLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pagesPerSheetLabel)
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 44.scale, height: 68.scale)
        layout.minimumInteritemSpacing = 12.scale
        layout.minimumLineSpacing = 12.scale
        
        pagesPerSheetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pagesPerSheetCollectionView.backgroundColor = .clear
        pagesPerSheetCollectionView.allowsMultipleSelection = false
        pagesPerSheetCollectionView.register(PagesPerSheetCell.self, forCellWithReuseIdentifier: "PagesPerSheetCell")
        pagesPerSheetCollectionView.delegate = self
        pagesPerSheetCollectionView.dataSource = self
        
        pagesPerSheetCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        addSubview(pagesPerSheetCollectionView)
    }
    
    func layoutUI() {
        // Disabling autoresizing mask translation and setting up constraints
        pagesPerSheetLabel.translatesAutoresizingMaskIntoConstraints = false
        pagesPerSheetCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Pages per sheet label constraints
            pagesPerSheetLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            pagesPerSheetLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pagesPerSheetLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            pagesPerSheetLabel.heightAnchor.constraint(equalToConstant: 20.scale),
            
            // Collection view constraints updated to be below the label
            pagesPerSheetCollectionView.topAnchor.constraint(equalTo: pagesPerSheetLabel.bottomAnchor, constant: 20.scale),
            pagesPerSheetCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pagesPerSheetCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pagesPerSheetCollectionView.heightAnchor.constraint(equalToConstant: 70.scale)
        ])
    }
}

extension PagesPerSheetOptionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            if let customCell = cell as? PagesPerSheetCell {
                customCell.isSelected = false
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? PagesPerSheetCell {
            cell.isSelected = true
            let selectedPages = pagesOptions[indexPath.item]
            delegate?.pagesPerSheetOptionCell(cell: self, didChangePagesPerSheetTo: selectedPages)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PagesPerSheetCell {
            cell.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagesPerSheetCell", for: indexPath) as? PagesPerSheetCell else {
            return UICollectionViewCell()
        }
        
        switch indexPath.item {
        case 0:
            cell.label.text = "1"
            cell.imageView.image = UIImage(named: "PagesPerSheet.1")
        case 1:
            cell.label.text = "2"
            cell.imageView.image = UIImage(named: "PagesPerSheet.2")
        case 2:
            cell.label.text = "4"
            cell.imageView.image = UIImage(named: "PagesPerSheet.4")
        case 3:
            cell.label.text = "6"
            cell.imageView.image = UIImage(named: "PagesPerSheet.6")
        case 4:
            cell.label.text = "9"
            cell.imageView.image = UIImage(named: "PagesPerSheet.9")
        case 5:
            cell.label.text = "16"
            cell.imageView.image = UIImage(named: "PagesPerSheet.16")
        default:
            fatalError()
        }
        
        return cell
    }
}
