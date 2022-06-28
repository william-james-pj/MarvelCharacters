//
//  SeeCharacterRouter.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 24/06/22.
//

import UIKit

protocol SeeCharacterWireframeInterface: WireframeInterface {
    static func start(character: CharacterModel) -> SeeCharacterWireframeInterface
}

class SeeCharacterWireframe: SeeCharacterWireframeInterface {
    // MARK: - Variables
    var entry: EntryPoint?
    
    // MARK: - Lifecycle
    static func start(character: CharacterModel) -> SeeCharacterWireframeInterface {
        let router = SeeCharacterWireframe()
        
        var view: SeeCharacterViewInterface = SeeCharacterViewController()
        var interactor: SeeCharacterInteractorInterface = SeeCharacterInteractor()
        var presenter: SeeCharacterPresenterInterface = SeeCharacterPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.wireframe = router
        presenter.view = view
        presenter.interactor = interactor
        presenter.setCharacter(character)
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
}
