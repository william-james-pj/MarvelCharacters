//
//  SeeCharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 26/06/22.
//

import UIKit

class SeeCharacterCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    fileprivate let resuseIdentifierCell = "ContentCollectionViewCell"
    
    // MARK: - Variables
    fileprivate var contentData: [ContentModel] = []
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let collectionViewSeeDetails: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        return collectionView
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
        buildHierarchy()
        buildConstraints()
        setupCollection()
    }
    
    fileprivate func setupCollection() {
        collectionViewSeeDetails.dataSource = self
        collectionViewSeeDetails.delegate = self
        
        collectionViewSeeDetails.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: resuseIdentifierCell)
    }
    
    // MARK: - Methods
    func settingView(_ data: AllContentModel) {
        self.labelTitle.text = data.title
        self.contentData = data.content
    }
    
    fileprivate func buildHierarchy() {
        self.addSubview(stackBase)
        stackBase.addArrangedSubview(labelTitle)
        stackBase.addArrangedSubview(collectionViewSeeDetails)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: self.topAnchor),
            stackBase.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackBase.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackBase.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            collectionViewSeeDetails.heightAnchor.constraint(equalToConstant: 130),
        ])
    }
}

// MARK: - extension UICollectionViewDelegate
extension SeeCharacterCollectionViewCell: UICollectionViewDelegate {
}

// MARK: - extension CollectionViewDataSource
extension SeeCharacterCollectionViewCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifierCell, for: indexPath) as! ContentCollectionViewCell
        cell.settingView(self.contentData[indexPath.row])
        return cell
    }
}

// MARK: - extension CollectionViewDelegateFlowLayout
extension SeeCharacterCollectionViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: 100, height: height)
    }
}

