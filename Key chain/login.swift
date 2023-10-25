import UIKit
import Security

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let emailText = UITextField()
    let passwordText = UITextField()
    let saveBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
       
        
        setupUI()
        
        // Set the delegate for the emailText field
        emailText.delegate = self
    }
    
    func setupUI() {
        emailText.frame = CGRect(x: 50, y: 300, width: 300, height: 35)
        emailText.layer.cornerRadius = 14
        emailText.placeholder = "Enter Your Email"
        emailText.layer.masksToBounds = true
        emailText.backgroundColor = UIColor.lightGray
        self.emailText.keyboardType = .emailAddress
        view.addSubview(emailText)
        
        passwordText.frame = CGRect(x: 50, y: 350, width: 300, height: 35)
        passwordText.layer.cornerRadius = 14
        passwordText.placeholder = "Enter Your Password"
        passwordText.layer.masksToBounds = true
        passwordText.backgroundColor = UIColor.lightGray
        view.addSubview(passwordText)
        
        // Create Save UIButton
        saveBtn.frame = CGRect(x: 150, y: 450, width: 100, height: 40)
        saveBtn.setTitle("Go", for: .normal)
        saveBtn.backgroundColor = .black
        saveBtn.layer.cornerRadius = 15
        saveBtn.layer.masksToBounds = true
        saveBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        view.addSubview(saveBtn)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText {
            // The "Next" button on the keyboard was pressed in the emailText field
            guard let username = textField.text, !username.isEmpty else {
                // Handle empty or invalid username
                return true
            }

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: username,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: kCFBooleanTrue,
            ]

            var passwordData: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &passwordData)

            if status == errSecSuccess {
                if let passwordData = passwordData as? Data,
                   let password = String(data: passwordData, encoding: .utf8) {
                    // Successfully fetched the password
                    print("Password fetched from Keychain: \(password)")

                    // Automatically populate the passwordText UITextField with the fetched password
                    passwordText.text = password
                } else {
                    // Handle the case where the password data could not be converted to a string
                    print("Error converting password data to string.")
                }
            } else {
                // Handle the case where no matching Keychain item was found or an error occurred
                print("Error fetching password from Keychain. Status code: \(status)")
            }
        }
        
        // Return true to dismiss the keyboard
        return true
    }
    
    @objc func btnTapped (){
        
        
        if emailText.text == "" {
            alert(title: "Alert", message: "Enter email id ")
        }
        else if isValidEmail(email: emailText.text!) == false {
            alert(title: "Alert", message: "Enter Valid Mail id ")
        }
        
        if passwordText.text == "" {
            alert(title: "Alert", message: "Enter password")
        }
        else if isValidPassword(password: passwordText.text!) == false {
            alert(title: "Alert", message: "Enter valid password (8 Charaters) ")
        }
        
        if (emailText.text != nil) && (passwordText.text != nil) == true {
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "data") as! Home_ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print(" Navigated sucess")
        } else {
            
//            alert(title: "Alert", message: "check the data")
            
            print("At least one of the fields is not empty.")
        }

        
        
     
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
