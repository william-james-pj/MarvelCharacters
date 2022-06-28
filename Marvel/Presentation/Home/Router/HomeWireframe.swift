//
//  HomeWireframe.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import UIKit

protocol HomeWireframeInterface: WireframeInterface {
    static func start() -> HomeWireframeInterface
    
    func navigateToSeeCharacter(character: CharacterModel)
}

class HomeWireframe: HomeWireframeInterface {
    // MARK: - Variables
    var entry: EntryPoint?
    
    // MARK: - Lifecycle
    static func start() -> HomeWireframeInterface {
        let router = HomeWireframe()
        
        var view: HomeViewInterface = HomeViewController()
        var interactor: HomeInteractorInterface = HomeInteractor()
        var presenter: HomePresenterInterface = HomePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.wireframe = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    func navigateToSeeCharacter(character: CharacterModel) {
        let seeCharacter = SeeCharacterWireframe.start(character: character)
        seeCharacter.entry?.modalPresentationStyle = .fullScreen
        entry?.presentWireframe(seeCharacter, animated: true)
//        entry?.navigationController?.pushWireframe(seeCharacter)
    }
}
