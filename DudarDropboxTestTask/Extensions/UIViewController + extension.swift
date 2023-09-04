//
//  UIViewController + extension.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit

extension UIViewController {
     
    func showAlerd(withDataInfo info: FileInfo?, withAlertStyle style: UIAlertController.Style = .alert){
        let infoMessage =   """
                            Name: \(info?.name ?? "_____") \n
                            Modified: \(info?.modified ?? "_____") \n
                            Size: \(info?.sizeString ?? "-----") \n
                            """
        let alert = UIAlertController(title: "Info", message: infoMessage, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in self.dismiss(animated: true)})
        present(alert, animated: true)
    }
     
}
