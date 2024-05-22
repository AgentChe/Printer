import UIKit

protocol NotesViewControllerDelegate: AnyObject {
    func notesViewController(_ controller: NotesCellContent, didSaveFormattedText text: NSAttributedString)
}

class NotesCellContent: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let textView = UITextView()
    private let fontCollectionView: UICollectionView
    private let alignCollectionView: UICollectionView
    private let printButton = UIButton()

    private let fonts = ["Arial", "Times New Roman", "SF Pro"]
    private let alignments: [NSTextAlignment] = [.left, .center, .right]

    weak var delegate: NotesViewControllerDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let fontLayout = UICollectionViewFlowLayout()
        fontLayout.scrollDirection = .horizontal
        fontLayout.minimumLineSpacing = 10.scale
        fontLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        fontCollectionView = UICollectionView(frame: .zero, collectionViewLayout: fontLayout)

        let alignLayout = UICollectionViewFlowLayout()
        alignLayout.scrollDirection = .horizontal
        alignLayout.minimumLineSpacing = 10.scale

        alignCollectionView = UICollectionView(frame: .zero, collectionViewLayout: alignLayout)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        view.backgroundColor = Appearance.mainViewBackground

        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("NotesViewController.Title", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.scale)
        titleLabel.textColor = Appearance.black // Set the title color to Appearance.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let dismissButton = UIButton(type: .system)
        let closeImage = UIImage(named: "Paygate.Close")?.withRenderingMode(.alwaysOriginal)
        dismissButton.setImage(closeImage, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)

        // Invisible view to increase tap area of the dismiss button
        let dismissButtonHitArea = UIView()
        dismissButtonHitArea.translatesAutoresizingMaskIntoConstraints = false
        dismissButtonHitArea.backgroundColor = .clear
        view.addSubview(dismissButtonHitArea)

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Appearance.white // Use Appearance.white
        textView.layer.cornerRadius = 20.scale
        textView.layer.borderWidth = 0
        textView.layer.opacity = 1
        textView.textColor = Appearance.subtitleLabelColor // Use Appearance.subtitleLabelColor
        textView.textContainerInset = UIEdgeInsets(top: 16.scale, left: 16.scale, bottom: 16.scale, right: 16.scale)
        view.addSubview(textView)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.scale

        let attributedText = NSMutableAttributedString(
            string: "AA\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 24.scale),
                .paragraphStyle: paragraphStyle
            ]
        )
        let userText = NSAttributedString(
            string: NSLocalizedString("NotesViewController.SampleText", comment: ""),
            attributes: [
                .font: UIFont.systemFont(ofSize: 17.scale, weight: .medium),
                .paragraphStyle: paragraphStyle
            ]
        )
        attributedText.append(userText)
        textView.attributedText = attributedText

        let fontLabel = UILabel()
        fontLabel.text = NSLocalizedString("NotesViewController.Font", comment: "")
        fontLabel.font = Fonts.SFProDisplay.bold(size: 17.scale)
        fontLabel.textColor = Appearance.black // Set the title color to Appearance.black
        fontLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fontLabel)

        fontCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fontCollectionView.backgroundColor = .clear
        fontCollectionView.dataSource = self
        fontCollectionView.delegate = self
        fontCollectionView.register(FontCell.self, forCellWithReuseIdentifier: FontCell.identifier)
        view.addSubview(fontCollectionView)

        let alignLabel = UILabel()
        alignLabel.text = NSLocalizedString("NotesViewController.Align", comment: "")
        alignLabel.font = Fonts.SFProDisplay.bold(size: 17.scale)
        alignLabel.translatesAutoresizingMaskIntoConstraints = false
        alignLabel.textColor = Appearance.black // Set the title color to Appearance.black
        view.addSubview(alignLabel)

        alignCollectionView.translatesAutoresizingMaskIntoConstraints = false
        alignCollectionView.backgroundColor = .clear
        alignCollectionView.dataSource = self
        alignCollectionView.delegate = self
        alignCollectionView.register(AlignCell.self, forCellWithReuseIdentifier: AlignCell.identifier)
        view.addSubview(alignCollectionView)

        printButton.setTitle(NSLocalizedString("NotesViewController.Print", comment: ""), for: .normal)
        printButton.backgroundColor = Appearance.signatureBlue // Use Appearance.signatureBlue
        printButton.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        printButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.scale)
        printButton.layer.cornerRadius = 24.scale
        printButton.translatesAutoresizingMaskIntoConstraints = false
        printButton.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
        view.addSubview(printButton)

        setupConstraints(titleLabel: titleLabel, dismissButton: dismissButton, dismissButtonHitArea: dismissButtonHitArea, fontLabel: fontLabel, alignLabel: alignLabel, printButton: printButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideTextView(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupConstraints(titleLabel: UILabel, dismissButton: UIButton, dismissButtonHitArea: UIView, fontLabel: UILabel, alignLabel: UILabel, printButton: UIButton) {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            dismissButton.widthAnchor.constraint(equalToConstant: 18.scale),
            dismissButton.heightAnchor.constraint(equalToConstant: 20.scale),

            dismissButtonHitArea.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            dismissButtonHitArea.centerXAnchor.constraint(equalTo: dismissButton.centerXAnchor),
            dismissButtonHitArea.widthAnchor.constraint(equalToConstant: 72.scale), // Four times the width of the button
            dismissButtonHitArea.heightAnchor.constraint(equalToConstant: 80.scale), // Four times the height of the button

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            textView.widthAnchor.constraint(equalToConstant: 361.scale),
            textView.heightAnchor.constraint(equalToConstant: 312.scale),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            fontLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10.scale),
            fontLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            fontLabel.widthAnchor.constraint(equalToConstant: 38.scale),
            fontLabel.heightAnchor.constraint(equalToConstant: 20.scale),

            fontCollectionView.topAnchor.constraint(equalTo: fontLabel.bottomAnchor, constant: 16.scale),
            fontCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            fontCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            fontCollectionView.heightAnchor.constraint(equalToConstant: 50.scale),

            alignLabel.topAnchor.constraint(equalTo: fontCollectionView.bottomAnchor, constant: 16.scale),
            alignLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            alignLabel.widthAnchor.constraint(equalToConstant: 42.scale),
            alignLabel.heightAnchor.constraint(equalToConstant: 20.scale),

            alignCollectionView.topAnchor.constraint(equalTo: alignLabel.bottomAnchor, constant: 10.scale),
            alignCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            alignCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            alignCollectionView.heightAnchor.constraint(equalToConstant: 50.scale),

            printButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            printButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            printButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24.scale),
            printButton.heightAnchor.constraint(equalToConstant: 68.scale)
        ])

        // Add tap gesture recognizer to the hit area
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        dismissButtonHitArea.addGestureRecognizer(tapGesture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delay(0.1) { [self] in
            let defaultFontIndexPath = IndexPath(item: 0, section: 0)
            fontCollectionView.selectItem(at: defaultFontIndexPath, animated: false, scrollPosition: [])
            collectionView(fontCollectionView, didSelectItemAt: defaultFontIndexPath)

            let defaultAlignIndexPath = IndexPath(item: 0, section: 0)
            alignCollectionView.selectItem(at: defaultAlignIndexPath, animated: false, scrollPosition: [])
            collectionView(alignCollectionView, didSelectItemAt: defaultAlignIndexPath)
        }
    }

    @objc private func dismissViewController() {
        delegate?.notesViewController(self, didSaveFormattedText: textView.attributedText)
        view.superview?.parentViewController?.dismiss(animated: true, completion: nil)
    }

    @objc private func handleTapOutsideTextView(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !textView.frame.contains(location) {
            textView.resignFirstResponder()
        }
    }

    @objc private func printButtonTapped() {
        delegate?.notesViewController(self, didSaveFormattedText: textView.attributedText)
    }
}

extension NotesCellContent: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fontCollectionView {
            return fonts.count
        } else {
            return alignments.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fontCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FontCell.identifier, for: indexPath) as! FontCell
            let fontName = fonts[indexPath.item]
            cell.configure(with: fontName)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlignCell.identifier, for: indexPath) as! AlignCell
            let alignment = alignments[indexPath.item]
            cell.configure(with: alignment)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == fontCollectionView {
            let selectedFont = fonts[indexPath.item]
            let largeFontSize: CGFloat = 24.scale
            let smallFontSize: CGFloat = 17.scale

            let largeFont: UIFont
            let smallFont: UIFont

            if let customFontLarge = UIFont(name: selectedFont, size: largeFontSize) {
                largeFont = customFontLarge
            } else {
                largeFont = UIFont.boldSystemFont(ofSize: largeFontSize)
            }

            if let customFontSmall = UIFont(name: selectedFont, size: smallFontSize) {
                smallFont = customFontSmall
            } else {
                smallFont = UIFont.systemFont(ofSize: smallFontSize, weight: .medium)
            }

            // Preserve existing attributes
            let originalAttributedText = textView.attributedText
            let mutableAttributedText = NSMutableAttributedString(attributedString: originalAttributedText!)

            // Iterate through each range of the attributed text and update the font attribute
            mutableAttributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: mutableAttributedText.length), options: []) { value, range, _ in
                let currentFont = value as! UIFont
                let newFont = currentFont.pointSize == largeFontSize ? largeFont : smallFont
                mutableAttributedText.addAttribute(.font, value: newFont, range: range)
            }

            textView.attributedText = mutableAttributedText
        } else if collectionView == alignCollectionView {
            let selectedAlignment = alignments[indexPath.item]
            textView.textAlignment = selectedAlignment
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == fontCollectionView {
            let fontName = fonts[indexPath.item]
            let size = (fontName as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16.scale)])
            return CGSize(width: size.width + 20.scale, height: 40.scale)
        } else {
            return CGSize(width: 62.scale, height: 44.scale)
        }
    }
}
