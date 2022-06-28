//
//  HeaderCollectionReusableView.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 26/06/22.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    // MARK: - Components
    fileprivate let viewImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let imageViewCharacter: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let viewBackgroud: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Text")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
        if !(viewGradient.layer.sublayers?.first is CAGradientLayer ) {
            setGradientBackground()
        }
     }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        buildHierarchy()
        buildConstraints()
    }
    
    // MARK: - Methods
    func settingView(_ character: CharacterModel?) {
        guard let character = character else {
            return
        }
        
        self.labelTitle.text = character.name
        self.labelText.text = character.description
        
        let imgUrl = extractImage(data: character.thumbnail)
        loadImage(url: imgUrl)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let colorBottom = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom, colorTop, colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.5, 0.9, 1.0]
        gradientLayer.frame = self.viewGradient.bounds
                
        self.viewGradient.layer.insertSublayer(gradientLayer, at:0)
    }
    
    fileprivate func buildHierarchy() {
        self.addSubview(viewImageContainer)
            viewImageContainer.addSubview(imageViewCharacter)

        self.addSubview(viewBackgroud)
        self.addSubview(labelTitle)
        self.addSubview(labelDescription)
        self.addSubview(labelText)
        self.addSubview(viewGradient)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            viewImageContainer.topAnchor.constraint(equalTo: self.topAnchor),
            viewImageContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewImageContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewImageContainer.heightAnchor.constraint(equalToConstant: 250),

            imageViewCharacter.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewCharacter.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewCharacter.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewCharacter.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            viewGradient.topAnchor.constraint(equalTo: self.topAnchor),
            viewGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewGradient.heightAnchor.constraint(equalToConstant: 250),
            
            viewBackgroud.topAnchor.constraint(equalTo: viewImageContainer.bottomAnchor),
            viewBackgroud.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewBackgroud.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewBackgroud.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            labelTitle.topAnchor.constraint(equalTo: viewImageContainer.bottomAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 24),
            labelDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            labelText.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 8),
            labelText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
}

extension HeaderCollectionReusableView {
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
}

