import UIKit
import Security


class ViewController: UIViewController,UITextFieldDelegate {

    let emailText = UITextField()
    let passwordText = UITextField()
    let saveBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailText.keyboardType = .emailAddress
        
        setupUI()
    }
    
    func setupUI() {
        // Create email UITextField
        emailText.frame = CGRect(x: 50, y: 300, width: 300, height: 35)
        emailText.layer.cornerRadius = 14
        emailText.placeholder = "Enter Your Email"
        emailText.layer.masksToBounds = true
        emailText.backgroundColor = UIColor.lightGray
        view.addSubview(emailText)

        // Create password UITextField
        passwordText.frame = CGRect(x: 50, y: 350, width: 300, height: 35)
        passwordText.layer.cornerRadius = 14
        passwordText.placeholder = "Enter Your Password"
        passwordText.layer.masksToBounds = true
        passwordText.backgroundColor = UIColor.lightGray
        view.addSubview(passwordText)

        // Create Save UIButton
        saveBtn.frame = CGRect(x: 150, y: 450, width: 100, height: 40)
        saveBtn.setTitle("Save It", for: .normal)
        saveBtn.backgroundColor = .black
        saveBtn.layer.cornerRadius = 15
        saveBtn.layer.masksToBounds = true
        saveBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        view.addSubview(saveBtn)
    }

    @objc func btnTapped() {
        // Email Alert Action
        if emailText.text ==  "" {
            alert(title: "Alert", message: "Enter email id ")
        }
        else  if isValidEmail(email: emailText.text!) == false {
            alert(title: "Alert", message: "Enter valid email")
        }
    
        // Password Alert Action
        if passwordText.text == ""{
            alert(title: "Alert", message: "Enter password")
        }
        else  if isValidPassword(password: passwordText.text!) == false {
            alert(title: "Alert", message: "Enter valid password (8 Charaters)")
        }
    
        
        guard let username = emailText.text, !username.isEmpty,
                  let password = passwordText.text, !password.isEmpty else {
                // Handle empty fields or other validation as needed.
                return
            }
            
            // Create a keychain query dictionary
            let keychainQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: username,
                kSecValueData as String: password.data(using: .utf8)!,
            ]
            
            // Delete any existing item with the same username
            SecItemDelete(keychainQuery as CFDictionary)
            
            // Add the new username and password to the Keychain
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            
            if status == errSecSuccess {
                print("Username and password saved to Keychain.")
            } else {
                print("Error saving username and password to Keychain. Status code: \(status)")
            }
        print("Save button tapped!")
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "fetch") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default,handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(password: String) -> Bool {
        let passWordRegEx = "^.{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passWordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
