//
//  ⚡️Created by Generatus⚡️ on 28.05.2018
// 
//  MainViewController.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  var presenter: MainPresenter?
  
  @IBOutlet private weak var imgPreview: UIImageView!
  @IBOutlet private weak var txtCornerRadius: UITextField!
  @IBOutlet private var btnsFigures: [UIButton]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    MainConfiguratorImplementation.configure(for: self)
    presenter?.viewDidLoad()
    
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    txtCornerRadius.inputAccessoryView = doneToolbar
  }
  
  @IBAction func btnPressed(_ sender: UIButton) {
    presenter?.cropFigure(sender.tag)
  }
  
  @IBAction func btnGetImagePressed(_ sender: UIButton) {
    presenter?.getImage()
  }
  
  @objc private func doneButtonAction() {
    txtCornerRadius.resignFirstResponder()
  }
}

//MARK: - MainView
extension MainViewController: MainView {
  var cornerRadius: CGFloat? {
    guard let str = txtCornerRadius.text, let number = NumberFormatter().number(from: str) else { return nil }
    return CGFloat(truncating: number)
  }
  
  func isBtnsFiguresEnable(_ enable: Bool) {
    btnsFigures.forEach { btn in
      btn.isEnabled = enable
    }
  }
}

//MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let imageData = image.pngData() else {
      return
    }
    imgPreview.image = image
    presenter?.didSelect(imageData)
  }
}


//MARK: - UIImagePickerControllerDelegate
extension MainViewController: UITextFieldDelegate {
  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
