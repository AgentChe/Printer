// PrintOptionsViewController.swift
// Printer

import UIKit

protocol CopiesOptionCellDelegate: AnyObject {
    func copiesOptionCell(cell: CopiesOptionCell, didChangeCopiesTo count: Int)
}

class PrintOptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var textRenderers: [CustomPrintTextPageRenderer] = []
    var imageRenderers: [CustomPrintImagePageRenderer] = []
    var options = ["Option 1", "Option 2", "Option 3"]
    var previews: [UIImage] = []
    var copies: Int = 1
    var pagesPerSheet: Int = 1
    
    var formattedText: NSAttributedString?

    private let topBarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Grabber"))
        imageView.alpha = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let printOptionsTitle: UILabel = {
        let label = UILabel()
        label.text = "Print Options"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = Appearance.black // Use Appearance.black
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
        collectionView.backgroundColor = Appearance.white // Use Appearance.white
        collectionView.layer.cornerRadius = 20
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Preview"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = Appearance.black // Use Appearance.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewCollectionView: UICollectionView = {
        let layout = CenteredFlowLayoutForPreviewsCollectionView()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 154) / 2, bottom: 0, right: (UIScreen.main.bounds.width - 154) / 2)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let printButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Print", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = Appearance.signatureBlue // Use Appearance.signatureBlue
        button.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrintButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePrintButton() {
        if let printer = PrinterManager.shared.getConnectedPrinter() {
            for textRenderer in textRenderers {
                PrinterManager.shared.directPrintTextUsingRenderer(from: self, printer: printer, copies: self.copies, pagesPerSheet: self.pagesPerSheet, renderer: textRenderer)
            }
            for imageRenderer in imageRenderers {
                imageRenderer.pagesPerSheet = self.pagesPerSheet
                imageRenderer.copies = self.copies
                PrinterManager.shared.directPrintImageUsingRenderer(from: self, printer: printer, copies: self.copies, pagesPerSheet: self.pagesPerSheet, images: imageRenderer.printImages, renderer: imageRenderer)
            }
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
        generatePreviews()
        handleFormattedText(formattedText) // Generate previews when the view loads
    }
    
    private func setupUI() {
        view.addSubview(printOptionsTitle)
        view.addSubview(collectionView)
        view.addSubview(previewLabel)
        view.addSubview(previewCollectionView)
        view.addSubview(printButton)
        view.addSubview(topBarImageView)
        
        NSLayoutConstraint.activate([
            topBarImageView.widthAnchor.constraint(equalToConstant: 36),
            topBarImageView.heightAnchor.constraint(equalToConstant: 5),
            topBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            topBarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            printOptionsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            printOptionsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            printOptionsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            printOptionsTitle.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: printOptionsTitle.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 293)
        ])
        
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewLabel.widthAnchor.constraint(equalToConstant: 96),
            previewLabel.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        NSLayoutConstraint.activate([
            previewCollectionView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 20),
            previewCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewCollectionView.heightAnchor.constraint(equalToConstant: 226)
        ])
        
        NSLayoutConstraint.activate([
            printButton.topAnchor.constraint(equalTo: previewCollectionView.bottomAnchor, constant: 5),
            printButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            printButton.widthAnchor.constraint(equalToConstant: 358),
            printButton.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    private func handleFormattedText(_ text: NSAttributedString?) {
        guard let text = text else { return }
        let renderer = CustomPrintTextPageRenderer()
        renderer.attributedPrintText = text // Set attributed text
        textRenderers.append(renderer)
        generatePreviews()
    }
    
    private func generatePreviews() {
        previews.removeAll() // Clear existing previews
        for textRenderer in textRenderers {
            textRenderer.pagesPerSheet = self.pagesPerSheet
            let pdfData = textRenderer.pdfData()
            if let previewImage = textRenderer.createImageFromPDFData(pdfData: pdfData) {
                previews.append(previewImage)
            }
        }
        for imageRenderer in imageRenderers {
            imageRenderer.pagesPerSheet = self.pagesPerSheet
            imageRenderer.copies = self.copies
            for image in imageRenderer.printImages {
                let individualImageRenderer = CustomPrintImagePageRenderer()
                individualImageRenderer.pagesPerSheet = imageRenderer.pagesPerSheet
                individualImageRenderer.copies = imageRenderer.copies
                individualImageRenderer.printImages = [image]
                let pdfData = individualImageRenderer.pdfData()
                if let previewImage = individualImageRenderer.createImageFromPDFData(pdfData: pdfData) {
                    previews.append(previewImage)
                }
            }
        }
        previewCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return options.count
        } else if collectionView == self.previewCollectionView {
            return previews.count
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
                if let currentlyConnectedPrinterURL = PrinterManager.shared.currentlyConnectedPrinterURL {
                    if let printerName = PrinterManager.shared.getPrinterName(for: currentlyConnectedPrinterURL) {
                        let cleanedPrinterName = printerName.filter { $0 != "\"" }
                        let truncatedPrinterName = String(cleanedPrinterName.prefix(10))
                        cell.configure(with: "Printer", detail: "\(truncatedPrinterName)")
                        return cell
                    }
                } else {
                    cell.configure(with: "Printer", detail: "not selected")
                }
                return cell
                
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CopiesOptionCell.identifier, for: indexPath) as? CopiesOptionCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: "Copy", count: 1)
                cell.delegate = self
                return cell
                
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PegesPerSheetOptionCell.identifier, for: indexPath) as? PegesPerSheetOptionCell else {
                    return UICollectionViewCell()
                }
                cell.delegate = self
                return cell
                
            default:
                return UICollectionViewCell()
            }
        } else if collectionView == self.previewCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.identifier, for: indexPath) as? PreviewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: previews[indexPath.row], description: "page \(indexPath.item + 1) of \(previews.count)")
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            print("Selected Option: \(options[indexPath.row])")
        } else if collectionView == self.previewCollectionView {
            print("Selected Preview: \(previews[indexPath.row])")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 326, height: indexPath.row == 2 ? 136 : 64)
        } else if collectionView == self.previewCollectionView {
            return CGSize(width: 154, height: 200)
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
        generatePreviews() // Regenerate previews when pages per sheet option changes
    }
}
