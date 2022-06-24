//
//  HomeWireframe.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import UIKit

typealias HomeEntryPoint = HomeViewInterface & UIViewController

protocol HomeWireframeInterface: WireframeInterface {
    var entry: HomeEntryPoint? { get }
    
    static func start() -> HomeWireframeInterface
}

class HomeWireframe: HomeWireframeInterface {
    // MARK: - Variables
    var entry: HomeEntryPoint?
    
    // MARK: - Lifecycle
    static func start() -> HomeWireframeInterface {
        let router = HomeWireframe()
        
        var view: HomeViewInterface = HomeViewController()
        var interactor: HomeInteractorInterface = HomeInteractor()
        var presenter: HomePresenterInterface = HomePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? HomeEntryPoint
        
        return router
    }
}
