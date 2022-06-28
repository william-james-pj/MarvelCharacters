//
//  WireframeInterface.swift
//  Marvel
//
//  Created by Pinto Junior, William James on 24/06/22.
//

import UIKit

typealias EntryPoint = ViewInterface & UIViewController

protocol WireframeInterface {
    var entry: EntryPoint? { get }
}
