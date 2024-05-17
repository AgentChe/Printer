//
//  NotesCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/17/24.
//
import UIKit

class NotesCell: UICollectionViewCell {
    
    var notesViewController: NotesCellContent?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNotesViewController()
        backgroundColor = Appearance.mainViewBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNotesViewController() {
        notesViewController = NotesCellContent()
        guard let notesVC = notesViewController else { return }
        
        notesVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesVC.view)
        NSLayoutConstraint.activate([
            notesVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            notesVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            notesVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            notesVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
