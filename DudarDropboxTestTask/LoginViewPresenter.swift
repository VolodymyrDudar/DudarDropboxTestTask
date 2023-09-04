//
//  LoginViewPresenter.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 03.09.2023.
//

import UIKit
import SwiftyDropbox

protocol LoginViewPresenter: AnyObject {
    func presentMinVC(viewController: UIViewController)
}

protocol LoginViewPresenterOut {
    var view: LoginViewPresenter? { get set }
    func viewDidAppear()
    func didTapLoginButtom()
    func authorized(url: URL)
}
 
class LoginViewPresenterImpl {
    
    weak var view: LoginViewPresenter?
     
}

extension LoginViewPresenterImpl: LoginViewPresenterOut {
    
    func viewDidAppear() {
        
        guard  DropboxClientsManager.authorizedClient != nil  else { return }
        let vc = CollectionViewController()
        vc.presenter = CollectionViewPresetnerImpl() 
        view?.presentMinVC(viewController: vc)
    }
    
    func didTapLoginButtom() {
       let scopeRequest = ScopeRequest(scopeType: .user,
                                       scopes: ["files.metadata.read", "files.content.read"],
                                       includeGrantedScopes: false)
       DropboxClientsManager.authorizeFromControllerV2(
           UIApplication.shared,
           controller: view as! LoginViewController,
           loadingStatusDelegate: nil,
           openURL: { url in
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           },
           scopeRequest: scopeRequest
       )
   }
    
    func authorized(url: URL) {
        _ = DropboxOAuthManager.sharedOAuthManager.handleRedirectURL(url) {  res in
             guard let res else { return }
             switch res {
             case .success(let token):
                 DropboxClientsManager.authorizedClient = .init(accessToken: token.accessToken) 
             case .error(let err, _):
                 print(err.localizedDescription, "Eerr")
             case .cancel:
                 print("Cancel", #function)
             }
         }
    }
    
}

