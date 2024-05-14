//
//  PrintOptionsViewController_v1.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//


import UIKit
protocol CopiesOptionCellDelegate: AnyObject {
    func copiesOptionCell(cell: CopiesOptionCell, didChangeCopiesTo count: Int)
}
class PrintOptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var textRenderer : CustomPrintTextPageRenderer!
    var options = ["Option 1", "Option 2", "Option 3"] // Example data
    var previews: [UIImage] = [UIImage(named:"PreviewExample")!]
    var copies: Int = 1
    var pagesPerSheet: Int = 1
    private let topBarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"Grabber"))
        // imageView.backgroundColor = .gray // Assuming you want a gray bar
        imageView.alpha = 1.0  // Set opacity to 0 as specified
        //imageView.layer.cornerRadius = 2.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // imageView.clipsToBounds = true
        return imageView
    }()
    
    private let printOptionsTitle: UILabel = {
        let label = UILabel()
        label.text = "Print Options"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 20
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Preview"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let previewCollectionView: UICollectionView = {
        let layout = CenteredFlowLayoutForPreviewsCollectionView()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: (ScreenSize.width - 154)/2, bottom: 0, right:  (ScreenSize.width - 154)/2)
        layout.scrollDirection = .horizontal // Set the scroll direction to horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false // Optional: Hide the horizontal scroll indicator
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let printButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Print", for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale)
        button.backgroundColor = Appearance.signatureBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24.scale
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrintButton), for: .touchUpInside)
        return button
    }()
    @objc func handlePrintButton() {
        if let printer = PrinterManager.shared.getConnectedPrinter() {
           // PrinterManager.shared.directPrintTextUsingRenderer(from: self, printer: printer, copies: self.copies, pagesPerSheet: self.pagesPerSheet, text: "Для исправления проблемы наложения текста при печати 16 копий на одном листе, когда текст оказывается слишком большим для выделенных областей, можно использовать более адаптивный подход к определению размера шрифта. В этом случае нам нужно обеспечить, что текст полностью умещается в заданной области, и если необходимо, уменьшить размер шрифта даже ниже предыдущего минимального порога в 6 пунктов, или же изменить методику расчёта размера шрифта, чтобы он динамически адаптировался к размеру области.")
            
           // PrinterManager.shared.directPrintImageUsingRenderer(from: self, printer: printer, copies:self.copies, pagesPerSheet: self.pagesPerSheet, image: UIImage(named: "Printer.Access")!)
            PrinterManager.shared.directPrintTextUsingRenderer(from: self, printer: printer, copies: 1, pagesPerSheet: 1, renderer: textRenderer)
        } else {
              print("Printer is not configured or unavailable.")
          }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.mainViewBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PrinterOptionCell.self, forCellWithReuseIdentifier: PrinterOptionCell.identifier)
        collectionView.register(CopiesOptionCell.self, forCellWithReuseIdentifier: CopiesOptionCell.identifier)
        collectionView.register(PegesPerSheetOptionCell.self, forCellWithReuseIdentifier: PegesPerSheetOptionCell.identifier)
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        previewCollectionView.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.identifier)
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(printOptionsTitle)
        view.addSubview(collectionView)
        view.addSubview(previewLabel)
        view.addSubview(previewCollectionView)
        view.addSubview(printButton)
        view.addSubview(topBarImageView)
        
        NSLayoutConstraint.activate([
            topBarImageView.widthAnchor.constraint(equalToConstant: 36.scale),
            topBarImageView.heightAnchor.constraint(equalToConstant: 5.scale),
            topBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.scale),
            topBarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            printOptionsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.scale),
            printOptionsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            printOptionsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            printOptionsTitle.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: printOptionsTitle.bottomAnchor, constant: 20.scale),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10.scale),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 293.scale)
        ])
        
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20.scale),
            previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewLabel.widthAnchor.constraint(equalToConstant: 96.scale),
            previewLabel.heightAnchor.constraint(equalToConstant: 29.scale)
        ])
        
        NSLayoutConstraint.activate([
            previewCollectionView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 20.scale),
            previewCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewCollectionView.heightAnchor.constraint(equalToConstant: 226.scale) // Height for the preview collection view
        ])
        NSLayoutConstraint.activate([
            printButton.topAnchor.constraint(equalTo: previewCollectionView.bottomAnchor, constant: 20.scale),
            printButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            printButton.widthAnchor.constraint(equalToConstant: 358.scale),
            printButton.heightAnchor.constraint(equalToConstant: 66.scale)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return options.count
        } else if collectionView == self.previewCollectionView {
            // Return the count for the preview items
            return previews.count // Assume you have a similar array for previews
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            switch indexPath.row {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrinterOptionCell.identifier, for: indexPath) as? PrinterOptionCell else {
                    return UICollectionViewCell()
                }
                if PrinterManager.shared.currentlyConnectedPrinterURL != nil {
                    let currentlyConnectedPrinterURL = PrinterManager.shared.currentlyConnectedPrinterURL!
                    let printerName = PrinterManager.shared.getPrinterName(for: currentlyConnectedPrinterURL)!
                    let cleanedPrinterName = printerName.filter { $0 != "\"" }  // Remove all " characters
                    let truncatedPrinterName = String(cleanedPrinterName.prefix(10))  // Keep only the first 10 characters
                    print(truncatedPrinterName)
                    cell.configure(with: "Printer", detail: "\(truncatedPrinterName)")
                    return cell
                } else {
                    cell.configure(with: "Printer", detail: "not selected")
                }
                return cell
                
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CopiesOptionCell.identifier, for: indexPath) as? CopiesOptionCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: "Copy",count: 1)
                cell.delegate = self
                return cell
                
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PegesPerSheetOptionCell.identifier, for: indexPath) as? PegesPerSheetOptionCell else {
                    return UICollectionViewCell()
                }
                cell.delegate = self
                return cell
                
            default:
                return UICollectionViewCell()  // Return an empty cell if none of the cases match
            }
        } else if collectionView == self.previewCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.identifier, for: indexPath) as? PreviewCell else {
                return UICollectionViewCell()
            }
            // Configure the cell with preview-specific data
            cell.configure(with: previews[indexPath.row], description: "page \(indexPath.item+1) of \(previews.count)") // Assume configuration method
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            print("Selected Option: \(options[indexPath.row])")
        } else if collectionView == self.previewCollectionView {
            print("Selected Preview: \(previews[indexPath.row])") // Log preview selection
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 326, height: indexPath.row == 2 ? 136 : 64) // Sizes for the main options
        } else if collectionView == self.previewCollectionView {
            // Define sizes for the preview collection view items
            return CGSize(width: 154, height: 200) // Example size for all preview cells
        }
        return CGSize.zero
    }
}
extension PrintOptionsViewController: CopiesOptionCellDelegate {
    func copiesOptionCell(cell: CopiesOptionCell, didChangeCopiesTo count: Int) {
        self.copies = count
        print("Updated copies to \(count)")
    }
}
extension PrintOptionsViewController: PegesPerSheetOptionCellDelegate {
    func pagesPerSheetOptionCell(cell: PegesPerSheetOptionCell, didChangePagesPerSheetTo pages: Int) {
        self.pagesPerSheet = pages
        print("Updated pages per sheet to \(pages)")
    }
}
