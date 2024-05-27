import UIKit

protocol PrintOptionsNotesViewControllerDelegate: AnyObject {
    func printOptionsNotesViewController(_ controller: PrintOptionsNotesViewController, didFinishPrinting success: Bool)
}

class PrintOptionsNotesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var formattedText: NSAttributedString?
    var copies: Int = 1
    var pagesPerSheet: Int = 1
    var previews: [UIImage] = []
    weak var delegate: PrintOptionsNotesViewControllerDelegate?
    
    private let topBarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Grabber"))
        imageView.alpha = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let printOptionsTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("PrintOptions.Title", comment: "Print Options")
        label.font = ScreenSize.isIphoneXFamily ? Fonts.SFProDisplay.bold(size: 24.scale) : Fonts.SFProDisplay.bold(size: 20.scale)
        label.textColor = Appearance.black // Use Appearance.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.scale
        layout.minimumInteritemSpacing = 10.scale
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10.scale, bottom: 0, right: 10.scale)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Appearance.white // Use Appearance.white
        collectionView.layer.cornerRadius = 20.scale
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("PrintOptions.Preview", comment: "Preview")
        label.font = ScreenSize.isIphoneXFamily ? Fonts.SFProDisplay.bold(size: 24.scale) : Fonts.SFProDisplay.bold(size: 20.scale)
        label.textColor = Appearance.black // Use Appearance.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewCollectionView: UICollectionView = {
        let layout = CenteredFlowLayoutForPreviewsCollectionView()
        layout.minimumLineSpacing = 10.scale
        layout.minimumInteritemSpacing = 10.scale
        layout.sectionInset = ScreenSize.isIphoneXFamily ? UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 154.scale) / 2, bottom: 0, right: (UIScreen.main.bounds.width - 154.scale) / 2) : UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - (154*0.9).scale) / 2, bottom: 0, right: (UIScreen.main.bounds.width - (154*0.9).scale) / 2)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let printButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("PrintOptions.PrintButton", comment: "Print"), for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale)
        button.backgroundColor = Appearance.signatureBlue // Use Appearance.signatureBlue
        button.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        button.layer.cornerRadius = ScreenSize.isIphoneXFamily ?  24.scale : 18.scale
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrintButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePrintButton() {
        if let printer = PrinterManager.shared.getConnectedPrinter(), let formattedText = self.formattedText {
            if let pdfData = generatePDF(from: formattedText, pagesPerSheet: self.pagesPerSheet, copies: self.copies) {
                PrinterManager.shared.printPDFData(pdfData, from: self, to: printer, copies: 1) { success in
                    self.delegate?.printOptionsNotesViewController(self, didFinishPrinting: success)
                }
            } else {
                print("Failed to generate PDF.")
                self.delegate?.printOptionsNotesViewController(self, didFinishPrinting: false)
            }
        } else {
            print("Printer is not configured or unavailable.")
            self.delegate?.printOptionsNotesViewController(self, didFinishPrinting: false)
        }
    }
    private func generatePDF(from attributedText: NSAttributedString, pagesPerSheet: Int, copies: Int) -> Data? {
        let minimumFontSize: CGFloat = 5.0 // Define the minimum font size

        if pagesPerSheet == 1 {
            let pdfMetaData = [
                kCGPDFContextCreator: "Your App Name",
                kCGPDFContextAuthor: "Your Name"
            ]
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = pdfMetaData as [String: Any]
            
            let pageWidth = 8.5 * 72.0
            let pageHeight = 11.0 * 72.0
            let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
            
            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
            
            let data = renderer.pdfData { (context) in
                for _ in 0..<copies {
                    let textStorage = NSTextStorage(attributedString: attributedText)
                    let textLayout = NSLayoutManager()
                    textStorage.addLayoutManager(textLayout)
                    
                    var textContainers: [NSTextContainer] = []
                    var location = 0
                    
                    while location < textLayout.numberOfGlyphs {
                        let textContainer = NSTextContainer(size: CGSize(width: pageRect.width, height: pageRect.height))
                        textContainer.lineBreakMode = .byWordWrapping
                        textLayout.addTextContainer(textContainer)
                        textContainers.append(textContainer)
                        
                        let range = textLayout.glyphRange(for: textContainer)
                        location += range.length
                    }
                    
                    for textContainer in textContainers {
                        context.beginPage()
                        textLayout.drawBackground(forGlyphRange: textLayout.glyphRange(for: textContainer), at: .zero)
                        textLayout.drawGlyphs(forGlyphRange: textLayout.glyphRange(for: textContainer), at: .zero)
                    }
                }
            }
            
            return data
        } else {
            let pdfMetaData = [
                kCGPDFContextCreator: "Your App Name",
                kCGPDFContextAuthor: "Your Name"
            ]
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = pdfMetaData as [String: Any]
            
            let pageWidth = 8.5 * 72.0
            let pageHeight = 11.0 * 72.0
            let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
            
            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
            
            let data = renderer.pdfData { (context) in
                for _ in 0..<copies {
                    // Calculate the number of rows and columns based on pagesPerSheet
                    let columns = Int(sqrt(Double(pagesPerSheet)))
                    let rows = pagesPerSheet / columns
                    let cellWidth = pageRect.width / CGFloat(columns)
                    let cellHeight = pageRect.height / CGFloat(rows)
                    
                    // Calculate the font size scaling factor
                    let scaleFactor = 1.0 / sqrt(Double(pagesPerSheet))
                    
                    // Create a new attributed string with adjusted font size
                    let scaledAttributedText = NSMutableAttributedString(attributedString: attributedText)
                    scaledAttributedText.beginEditing()
                    scaledAttributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: scaledAttributedText.length)) { value, range, _ in
                        if let font = value as? UIFont {
                            let newFontSize = max(font.pointSize * CGFloat(scaleFactor), minimumFontSize)
                            let scaledFont = font.withSize(newFontSize)
                            scaledAttributedText.addAttribute(.font, value: scaledFont, range: range)
                        }
                    }
                    scaledAttributedText.endEditing()

                    let textStorage = NSTextStorage(attributedString: scaledAttributedText)
                    let textLayout = NSLayoutManager()
                    textStorage.addLayoutManager(textLayout)
                    
                    var textContainers: [NSTextContainer] = []
                    var location = 0
                    
                    while location < textLayout.numberOfGlyphs {
                        let textContainer = NSTextContainer(size: CGSize(width: cellWidth, height: cellHeight))
                        textContainer.lineBreakMode = .byWordWrapping
                        textLayout.addTextContainer(textContainer)
                        textContainers.append(textContainer)
                        
                        let range = textLayout.glyphRange(for: textContainer)
                        location += range.length
                    }
                    
                    var cellIndex = 0
                    for textContainer in textContainers {
                        if cellIndex % pagesPerSheet == 0 {
                            context.beginPage()
                        }
                        let row = cellIndex / columns
                        let column = cellIndex % columns
                        let origin = CGPoint(x: CGFloat(column) * cellWidth, y: CGFloat(row) * cellHeight)
                        
                        context.cgContext.saveGState()
                        context.cgContext.translateBy(x: origin.x, y: origin.y)
                        textLayout.drawBackground(forGlyphRange: textLayout.glyphRange(for: textContainer), at: .zero)
                        textLayout.drawGlyphs(forGlyphRange: textLayout.glyphRange(for: textContainer), at: .zero)
                        context.cgContext.restoreGState()
                        
                        cellIndex += 1
                    }
                }
            }
            
            return data
        }
    }





    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.mainViewBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PrinterOptionCell.self, forCellWithReuseIdentifier: PrinterOptionCell.identifier)
        collectionView.register(CopiesOptionCell.self, forCellWithReuseIdentifier: CopiesOptionCell.identifier)
        collectionView.register(PagesPerSheetOptionCell.self, forCellWithReuseIdentifier: PagesPerSheetOptionCell.identifier)
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        previewCollectionView.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.identifier)
        
        setupUI()
        generatePreviews()
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
            collectionView.topAnchor.constraint(equalTo: printOptionsTitle.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 10.scale),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.scale),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 293.scale)
        ])
        
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 5.scale ),
            previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewLabel.widthAnchor.constraint(equalToConstant: 96.scale),
            previewLabel.heightAnchor.constraint(equalToConstant: 29.scale)
        ])
        
        NSLayoutConstraint.activate([
            previewCollectionView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 5.scale ),
            previewCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewCollectionView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 226.scale : 177.scale)
        ])
        
        NSLayoutConstraint.activate([
            printButton.topAnchor.constraint(equalTo: previewCollectionView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 10.scale),
            printButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            printButton.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 358.scale : 330.scale),
            printButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 66.scale : 56.scale)
        ])
    }
    
    private func generatePreviews() {
        previews.removeAll() // Clear existing previews
        if let formattedText = self.formattedText {
            let textRenderer = CustomPrintTextPageRenderer()
            textRenderer.attributedPrintText = formattedText
            textRenderer.pagesPerSheet = self.pagesPerSheet
            let pdfData = textRenderer.pdfData()
            if let previewImage = textRenderer.createImageFromPDFData(pdfData: pdfData) {
                previews.append(previewImage)
            }
        }
        previewCollectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView ? 3 : previews.count
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
                        cell.configure(with: NSLocalizedString("PrintOptions.Printer", comment: "Printer"), detail: "\(truncatedPrinterName)", showArrow: false)
                        return cell
                    }
                }
                cell.configure(with: NSLocalizedString("PrintOptions.Printer", comment: "Printer"), detail: NSLocalizedString("PrintOptions.PrinterNotSelected", comment: "not selected"), showArrow: true)
                return cell
                
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CopiesOptionCell.identifier, for: indexPath) as? CopiesOptionCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: NSLocalizedString("PrintOptions.Copy", comment: "Copy"), count: self.copies)
                cell.delegate = self
                return cell
                
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagesPerSheetOptionCell.identifier, for: indexPath) as? PagesPerSheetOptionCell else {
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
            cell.configure(with: previews[indexPath.row], pageNumber: indexPath.item + 1, totalPages: previews.count)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 326.scale, height: indexPath.row == 2 ? 136.scale : 64.scale)
        } else if collectionView == self.previewCollectionView {
            return ScreenSize.isIphoneXFamily ? CGSize(width: 154.scale, height: 200.scale) : CGSize(width: 154*0.9.scale, height: 200*0.9.scale)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if indexPath.row == 0 {
                let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
                printerPicker.present(animated: true) { [weak self] (printerPickerController, userDidSelect, error) in
                    if userDidSelect {
                        if let printer = printerPickerController.selectedPrinter {
                            print("Printer name: \(printer.displayName)")
                            print("Printer URL: \(printer.url)")
                            
                            let isFirstTimeSaved = PrinterManager.shared.isFirstTimePrinterSaved(printer.url)
                            PrinterManager.shared.savePrinter(url: printer.url, displayName: printer.displayName)
                            
                            PrinterManager.shared.connectToPrinter(with: printer.url) { printer, error in
                                if let printer = printer {
                                    self?.collectionView.reloadData()
                    
                                }
                                if let error = error {
                                    PrinterManager.shared.showAlertForErrorWithPrinter(printer?.displayName ?? "Unknown", viewController: self!)
                                    
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                    } else {
                        
                    }
                }
            } else {
                //print("Selected Option: \(options[indexPath.row])")
            }
        } else if collectionView == self.previewCollectionView {
            print("Selected Preview: \(previews[indexPath.row])")
        }
    }
}

extension PrintOptionsNotesViewController: CopiesOptionCellDelegate {
    func copiesOptionCell(cell: CopiesOptionCell, didChangeCopiesTo count: Int) {
        self.copies = count
        print("Updated copies to \(count)")
        generatePreviews()
    }
}

extension PrintOptionsNotesViewController: PagesPerSheetOptionCellDelegate {
    func pagesPerSheetOptionCell(cell: PagesPerSheetOptionCell, didChangePagesPerSheetTo pages: Int) {
        self.pagesPerSheet = pages
        print("Updated pages per sheet to \(pages)")
        generatePreviews()
    }
}
