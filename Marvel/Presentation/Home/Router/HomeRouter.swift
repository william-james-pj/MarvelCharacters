//
//  HomeRouter.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 21/06/22.
//

import UIKit

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get }
    
    static func start() -> AnyRouter
}

class HomeRouter: AnyRouter {
    var entry: EntryPoint?
    
    static func start() -> AnyRouter {
        let router = HomeRouter()
        
        var view: AnyView = HomeViewController()
        var interactor: AnyInteractor = HomeInteractor()
        var presenter: AnyPresenter = HomePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
