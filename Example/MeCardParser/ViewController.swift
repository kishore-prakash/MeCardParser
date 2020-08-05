// Copyright (c) 2020 Kishore Prakash <kishore.balasa@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  ViewController.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 07/31/2020.
//  Copyright (c) 2020 Kishore Prakash. All rights reserved.
//

import UIKit
import MeCardParser
import Contacts
import ContactsUI

class ViewController: UIViewController {

    var contactController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /// Presents an alert with a text field so a MeCard string can be entered by
    /// hand (or pasted) and parsed, without opening the camera.
    @IBAction func showMeCardInput(_ sender: Any) {
        let alert = UIAlertController(
            title: "Enter MeCard",
            message: "Paste or type a MeCard string to parse.",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "MECARD:N:Doe,John;TEL:5555555555;..."
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Parse", style: .default) { [weak self, weak alert] _ in
            let code = alert?.textFields?.first?.text ?? ""
            self?.handle(code: code)
        })

        present(alert, animated: true)
    }

    /// Parses a MeCard string and either shows the resulting contact or an error.
    private func handle(code: String) {
        print("MeCard input: \(code)")

        switch MeCardContactBuilder().makeContact(from: code) {
        case .success(let contact):
            show(contact: contact)
        case .failure(let error):
            presentParseError(message: error.localizedDescription)
        }
    }

    private func presentParseError(message: String) {
        let alert = UIAlertController(
            title: "Could not parse MeCard",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func show(contact: CNContact) {
        let contactView = CNContactViewController(forUnknownContact: contact)
        contactView.contactStore = CNContactStore()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(destroyContactController))
        contactView.navigationItem.leftBarButtonItem = cancelButton
        
        contactController = UINavigationController(rootViewController: contactView)
        
        if let contactController = contactController {
            present(contactController, animated: true, completion: nil)
        }
    }
    
    @objc private func destroyContactController() {
        resignFirstResponder()
        contactController?.dismiss(animated: true, completion: nil)
    }

}

