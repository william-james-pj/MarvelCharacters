//
//  CharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let viewStackAux: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewImageAux: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let imageViewCharacter: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let stackContent: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let stackText: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "Text")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Text")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let stackFooter: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let labelMore: UILabel = {
        let label = UILabel()
        label.text = "More info"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(named: "Text")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let imageViewArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.tintColor = UIColor(named: "Text")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        self.backgroundColor = UIColor(named: "Card")
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    
        buildHierarchy()
        buildConstraints()
    }
    
    // MARK: - Methods
    func configCell(character: MavelCharacter) {
        self.labelTitle.text = character.name
        self.labelDescription.text = character.description
        
        let imgUrl = extractImage(data: character.thumbnail)
        loadImage(url: imgUrl)
    }
    
    fileprivate func extractImage(data: [String: String]) -> URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        
        return URL(string: "\(path).\(ext)")!
    }
    
    fileprivate func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageViewCharacter.image = image
                    }
                }
            }
        }
    }
    
    fileprivate func buildHierarchy() {
        self.addSubview(stackBase)
        self.addSubview(imageViewArrow)
        
        stackBase.addArrangedSubview(viewImageAux)
        viewImageAux.addSubview(imageViewCharacter)

        stackBase.addArrangedSubview(stackContent)
        stackContent.addArrangedSubview(stackText)
        stackText.addArrangedSubview(labelTitle)
        stackText.addArrangedSubview(labelDescription)
        
        stackContent.addArrangedSubview(stackFooter)
        stackFooter.addArrangedSubview(labelMore)
        stackFooter.addArrangedSubview(imageViewArrow)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackBase.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackBase.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackBase.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            viewImageAux.widthAnchor.constraint(equalToConstant: 100),
            imageViewCharacter.widthAnchor.constraint(equalToConstant: 100),
            imageViewCharacter.heightAnchor.constraint(equalToConstant: 130),
            imageViewCharacter.centerXAnchor.constraint(equalTo: viewImageAux.centerXAnchor),
            imageViewCharacter.centerYAnchor.constraint(equalTo: viewImageAux.centerYAnchor),
            
            imageViewArrow.widthAnchor.constraint(equalToConstant: 20),
            imageViewArrow.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
