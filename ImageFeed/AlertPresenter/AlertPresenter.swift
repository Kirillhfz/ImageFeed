//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 26.12.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(for model: AlertModel)
}


final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(for model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        alert.addAction(action)
        
        if let nextButtonText = model.nextButtonText {
            let nextAction = UIAlertAction(
                title: nextButtonText,
                style: .default) { _ in
                model.nextCompletion()
            }
        alert.addAction(nextAction)
        }
        
        delegate?.present(alert, animated: true)
    }
}
