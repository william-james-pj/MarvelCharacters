//
//  SeeCharacterPresenter.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 24/06/22.
//

import Foundation

protocol SeeCharacterPresenterInterface: PresenterInterface {
    var wireframe: SeeCharacterWireframeInterface? { get set }
    var interactor: SeeCharacterInteractorInterface? { get set }
    var view: SeeCharacterViewInterface? { get set }
    
    func setCharacter(_ character: CharacterModel)
    func interactorDidFetch(with result: Result<ContentDataContainer, Error>, title: String)
}

class SeeCharacterPresenter: SeeCharacterPresenterInterface {
    // MARK: - Variables
    var wireframe: SeeCharacterWireframeInterface?
    var interactor: SeeCharacterInteractorInterface?
    var view: SeeCharacterViewInterface?
    
    // MARK: - Methods
    func setCharacter(_ character: CharacterModel) {
        self.view?.updateHeader(character)
        self.interactor?.getComic(character.id)
        self.interactor?.getSerie(character.id)
    }
    
    func interactorDidFetch(with result: Result<ContentDataContainer, Error>, title: String) {
        switch result {
        case .success(let dataContainer):
            let allContent = AllContentModel(title: title, content: dataContainer.results)
            self.view?.updateContent(allContent)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
