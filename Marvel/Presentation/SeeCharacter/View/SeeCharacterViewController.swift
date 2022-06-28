//
//  SeeCharacterViewController.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 24/06/22.
//

import UIKit

protocol SeeCharacterViewInterface: ViewInterface {
    var presenter: SeeCharacterPresenterInterface? { get set }
    
    func updateHeader(_ character: CharacterModel)
    func updateContent(_ content: AllContentModel)
}

class SeeCharacterViewController: UIViewController, SeeCharacterViewInterface {
    // MARK: - Constants
    fileprivate let resuseIdentifierHeader = "CollectionSeeCharacterHeader"
    fileprivate let resuseIdentifierCell = "SeeCharacterCollectionViewCell"
    fileprivate let resuseIdentifierFooter = "CollectionFooter"
    
    // MARK: - Variables
    var presenter: SeeCharacterPresenterInterface?
    var headerData: CharacterModel?
    var contentData: [AllContentModel] = []
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let buttonArrowBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonBackAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let buttonHeart: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let collectionViewSeeCharacter: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        view.backgroundColor = UIColor(named: "Text")
    
        buildHierarchy()
        buildConstraints()
        setupCollection()
    }
    
    fileprivate func setupCollection() {
        collectionViewSeeCharacter.dataSource = self
        collectionViewSeeCharacter.delegate = self
        
        collectionViewSeeCharacter.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: resuseIdentifierHeader
        )
        
        collectionViewSeeCharacter.register(SeeCharacterCollectionViewCell.self, forCellWithReuseIdentifier: resuseIdentifierCell)
        
        collectionViewSeeCharacter.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: resuseIdentifierFooter
        )
    }
    
    // MARK: - Actions
    @IBAction func buttonBackAction(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Methods
    func updateHeader(_ character: CharacterModel) {
        self.headerData = character
        self.collectionViewSeeCharacter.reloadData()
    }
    
    func updateContent(_ content: AllContentModel) {
        DispatchQueue.main.async {
            self.contentData.append(content)
            self.collectionViewSeeCharacter.reloadData()
        }
    }
    
    fileprivate func buildHierarchy() {
        view.addSubview(stackBase)
        stackBase.addArrangedSubview(collectionViewSeeCharacter)
        
        view.addSubview(buttonArrowBack)
        view.addSubview(buttonHeart)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: view.topAnchor),
            stackBase.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackBase.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackBase.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            buttonArrowBack.widthAnchor.constraint(equalToConstant: 25),
            buttonArrowBack.heightAnchor.constraint(equalToConstant: 25),
            buttonArrowBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            buttonArrowBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            buttonHeart.widthAnchor.constraint(equalToConstant: 25),
            buttonHeart.heightAnchor.constraint(equalToConstant: 25),
            buttonHeart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            buttonHeart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

// MARK: - extension UICollectionViewDelegate
extension SeeCharacterViewController: UICollectionViewDelegate {
}

// MARK: - extension CollectionViewDataSource
extension SeeCharacterViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifierCell, for: indexPath) as! SeeCharacterCollectionViewCell
        cell.settingView(self.contentData[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: resuseIdentifierHeader, for: indexPath) as! HeaderCollectionReusableView
            header.settingView(headerData)
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: resuseIdentifierFooter, for: indexPath)
            return footer
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: - extension CollectionViewDelegateFlowLayout
extension SeeCharacterViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 152)
    }
    
    // Header
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 420)
    }
    
    // Footer
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 30)
    }
}
