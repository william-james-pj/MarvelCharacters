//
//  HomeViewController.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import UIKit

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with dataContainer: CharacterDataContainer, isByOffset: Bool)
    func setLoading(to isLoading: Bool)
}

class HomeViewController: UIViewController, AnyView {
    // MARK: - Constrants
    fileprivate let resuseIdentifierCharacter = "CharacterCollectionViewCell"
    
    // MARK: - Variables
    var presenter: AnyPresenter?
    var characters: [MavelCharacter] = []
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let viewStackAux: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let labelMarvel: UILabel = {
        let label = UILabel()
        label.text = "MARVEL"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(named: "Text")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let textFieldSearch: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search character"
        textField.backgroundColor = UIColor(named: "Card")
        textField.layer.cornerRadius = 16
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate let collectionViewCharacter: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        view.backgroundColor = UIColor(named: "Backgroud")
        
        self.textFieldSearch.delegate = self
        
        self.setLoading(to: true)
    
        buildHierarchy()
        buildConstraints()
        setupCollection()
    }
    
    fileprivate func setupCollection() {
        collectionViewCharacter.dataSource = self
        collectionViewCharacter.delegate = self
        
        collectionViewCharacter.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: resuseIdentifierCharacter)
    }
    
    // MARK: - Methods
    func update(with dataContainer: CharacterDataContainer, isByOffset: Bool) {
        DispatchQueue.main.async {
            if isByOffset {
                self.characters += dataContainer.results
            }
            else {
                self.characters = dataContainer.results
            }
            
            self.collectionViewCharacter.reloadData()
        }
    }
    
    func setLoading(to isLoading: Bool) {
        DispatchQueue.main.async {
            if !isLoading {
                self.viewStackAux.isHidden = true
                self.indicatorView.stopAnimating()
                self.collectionViewCharacter.isHidden = false
                return;
            }

            self.viewStackAux.isHidden = false
            self.indicatorView.startAnimating()
            self.collectionViewCharacter.isHidden = true
        }
    }
    
    fileprivate func buildHierarchy() {
        view.addSubview(stackBase)
        stackBase.addArrangedSubview(labelMarvel)
        stackBase.addArrangedSubview(textFieldSearch)
        stackBase.addArrangedSubview(viewStackAux)
        stackBase.addArrangedSubview(collectionViewCharacter)
        
        view.addSubview(indicatorView)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackBase.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackBase.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackBase.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textFieldSearch.heightAnchor.constraint(equalToConstant: 45),
            
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
}

// MARK: - extension UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.characters.count - 1 {
            self.presenter?.featchByOffset()
        }
    }
}

// MARK: - extension CollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifierCharacter, for: indexPath) as! CharacterCollectionViewCell
        cell.configCell(character: self.characters[indexPath.row])
        return cell
    }
}

// MARK: - extension CollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 150)
    }
}

// MARK: - extension UITextInputDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldSearch.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        self.textFieldSearch.placeholder = "Search character"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let str = textField.text else { return }
        self.presenter?.seachText.send(str)
    }
}

// MARK: - extension UITextField
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
