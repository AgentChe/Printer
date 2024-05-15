import UIKit

protocol NotesViewControllerDelegate: AnyObject {
    func notesViewController(_ controller: NotesViewController, didSaveFormattedText text: NSAttributedString)
}

class NotesViewController: UIViewController {

    private let textView = UITextView()
    private let fontCollectionView: UICollectionView
    private let alignCollectionView: UICollectionView
    private let printButton = UIButton()

    private let fonts = ["Arial", "Times New Roman", "Sf Pro"]
    private let alignments: [NSTextAlignment] = [.left, .center, .right, .justified]

    weak var delegate: NotesViewControllerDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let fontLayout = UICollectionViewFlowLayout()
        fontLayout.scrollDirection = .horizontal
        fontLayout.minimumLineSpacing = 10
        fontLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        fontCollectionView = UICollectionView(frame: .zero, collectionViewLayout: fontLayout)

        let alignLayout = UICollectionViewFlowLayout()
        alignLayout.scrollDirection = .horizontal
        alignLayout.minimumLineSpacing = 10

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
        titleLabel.text = "Note"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let dismissButton = UIButton(type: .system)
        let closeImage = UIImage(named: "Paygate.Close")?.withRenderingMode(.alwaysOriginal)
        dismissButton.setImage(closeImage, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 0
        textView.layer.opacity = 1
        textView.textColor = .gray
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        view.addSubview(textView)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4

        let attributedText = NSMutableAttributedString(
            string: "AA\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle
            ]
        )
        let userText = NSAttributedString(
            string: "User's text",
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .medium),
                .paragraphStyle: paragraphStyle
            ]
        )
        attributedText.append(userText)
        textView.attributedText = attributedText

        let fontLabel = UILabel()
        fontLabel.text = "Font"
        fontLabel.font = Fonts.SFProDisplay.bold(size: 17)
        fontLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fontLabel)

        fontCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fontCollectionView.backgroundColor = .clear
        fontCollectionView.dataSource = self
        fontCollectionView.delegate = self
        fontCollectionView.register(FontCell.self, forCellWithReuseIdentifier: FontCell.identifier)
        view.addSubview(fontCollectionView)

        let alignLabel = UILabel()
        alignLabel.text = "Align"
        alignLabel.font = Fonts.SFProDisplay.bold(size: 17)
        alignLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alignLabel)

        alignCollectionView.translatesAutoresizingMaskIntoConstraints = false
        alignCollectionView.backgroundColor = .clear
        alignCollectionView.dataSource = self
        alignCollectionView.delegate = self
        alignCollectionView.register(AlignCell.self, forCellWithReuseIdentifier: AlignCell.identifier)
        view.addSubview(alignCollectionView)

        printButton.setTitle("Print", for: .normal)
        printButton.backgroundColor = UIColor(red: 0.18, green: 0.36, blue: 1.00, alpha: 1.00)
        printButton.setTitleColor(.white, for: .normal)
        printButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        printButton.layer.cornerRadius = 24
        printButton.translatesAutoresizingMaskIntoConstraints = false
        printButton.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
        view.addSubview(printButton)

        setupConstraints(titleLabel: titleLabel, dismissButton: dismissButton, fontLabel: fontLabel, alignLabel: alignLabel, printButton: printButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideTextView(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupConstraints(titleLabel: UILabel, dismissButton: UIButton, fontLabel: UILabel, alignLabel: UILabel, printButton: UIButton) {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalToConstant: 18),
            dismissButton.heightAnchor.constraint(equalToConstant: 20),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textView.widthAnchor.constraint(equalToConstant: 361),
            textView.heightAnchor.constraint(equalToConstant: 312),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            fontLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            fontLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fontLabel.widthAnchor.constraint(equalToConstant: 38),
            fontLabel.heightAnchor.constraint(equalToConstant: 20),

            fontCollectionView.topAnchor.constraint(equalTo: fontLabel.bottomAnchor, constant: 16),
            fontCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fontCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fontCollectionView.heightAnchor.constraint(equalToConstant: 50),

            alignLabel.topAnchor.constraint(equalTo: fontCollectionView.bottomAnchor, constant: 16),
            alignLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            alignLabel.widthAnchor.constraint(equalToConstant: 42),
            alignLabel.heightAnchor.constraint(equalToConstant: 20),

            alignCollectionView.topAnchor.constraint(equalTo: alignLabel.bottomAnchor, constant: 10),
            alignCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            alignCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            alignCollectionView.heightAnchor.constraint(equalToConstant: 50),

            printButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            printButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            printButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            printButton.heightAnchor.constraint(equalToConstant: 68)
        ])
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
        dismiss(animated: true, completion: nil)
    }

    @objc private func handleTapOutsideTextView(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !textView.frame.contains(location) {
            textView.resignFirstResponder()
        }
    }

    @objc private func printButtonTapped() {
        let printOptionsVC = PrintOptionsViewController()
        printOptionsVC.formattedText = textView.attributedText
        present(printOptionsVC, animated: true, completion: nil)
    }
}

extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            let largeFontSize: CGFloat = 24
            let smallFontSize: CGFloat = 17

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

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4

            let attributedText = NSMutableAttributedString(
                string: "AA\n",
                attributes: [
                    .font: largeFont,
                    .paragraphStyle: paragraphStyle
                ]
            )
            let userText = NSAttributedString(
                string: "User's text",
                attributes: [
                    .font: smallFont,
                    .paragraphStyle: paragraphStyle
                ]
            )
            attributedText.append(userText)
            textView.attributedText = attributedText
        } else if collectionView == alignCollectionView {
            let selectedAlignment = alignments[indexPath.item]
            textView.textAlignment = selectedAlignment
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == fontCollectionView {
            let fontName = fonts[indexPath.item]
            let size = (fontName as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)])
            return CGSize(width: size.width + 20, height: 40)
        } else {
            return CGSize(width: 62, height: 44)
        }
    }
}
