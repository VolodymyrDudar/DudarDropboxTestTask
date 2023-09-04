//
//  LoginViewController.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 03.09.2023.
//

import UIKit 

class LoginViewController: UIViewController {
    
    var presenter: LoginViewPresenterOut?
    
    private lazy var loginButton = {
        let button = UIButton()
        button.setTitle("Dropbox \n  Login", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.contentMode = .center
        button.frame = CGRect(origin: .zero, size: CGSize(width: 169, height: 74))
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.titleLabel?.tintColor = .white
        button.addTarget(self, action: #selector(didTapLoginButtom), for: .touchUpInside)
        return button
    }()
    
    init(presenter: LoginViewPresenterOut = LoginViewPresenterImpl()) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.presenter?.view = self
    }
    required init?(coder: NSCoder) { fatalError( )}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.center = view.center
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear() 
    }
 
    @objc private func didTapLoginButtom() {
        presenter?.didTapLoginButtom()
    }
    
}

extension LoginViewController: LoginViewPresenter {
    func presentMinVC(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.viewControllers.removeFirst()
    }
}
