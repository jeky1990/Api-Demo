//
//  ViewController.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 21/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit

class LogInPage: UIViewController {
    
    //----Outlets
    
    @IBOutlet weak var checkMarkButton : UIButton!
    @IBOutlet weak var rememberMelabel : UILabel!
    @IBOutlet weak var userEmail : UITextField!
    @IBOutlet weak var userpassword : UITextField!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var recoverAccountView : UIView!
    @IBOutlet weak var resetEmailField : UITextField!
    @IBOutlet weak var  forgetPasswordView : UIView!

    //----Variable diclaration
    
    var clientDetail : [MainResponse] = []
    var clientAllEvents : [EventMainReponse] = []
    var client_encrypt_Id : String = ""
    var clientEventsData : [ClientEvents] = []
    var flag = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        recoverAccountView.fadeOutOnstarting()
        chekMarkButtonBorder()
        checkfIfUserAlreadyLogIn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userEmail.becomeFirstResponder()
        userEmail.text = (UserDefaults.standard.value(forKey: "userEmail") as! String)
        userpassword.text = (UserDefaults.standard.value(forKey: "userPassword") as! String)
        
        if (userEmail!.text != nil) && (userpassword.text != nil)
        {
            checkMarkButton.setImage(UIImage(named: "checkMark.png"),for: .normal)
        }
        
    }
    
    func checkfIfUserAlreadyLogIn()
    {
        if UserDefaults.standard.bool(forKey: "LoggedIn") == true
        {
                print("Already Logged In")
                self.client_encrypt_Id = UserDefaults.standard.value(forKey: "clientId") as! String
                self.downloadEventData(client_encrypt_id: self.client_encrypt_Id)
        }
    }
    
    func performClientLogin()
    {
        SKActivityIndicator.show()
        APIManager.sharedInstance.performClientLogin(with: userEmail.text!, password: userpassword.text!) { (req, Responce, Error) in
            DispatchQueue.main.async {
                if Error != nil
                {
                    SKActivityIndicator.dismiss()
                    print("Eroor in fatch Data")
                }
                else
                {
                    print("Logged In")
                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                    self.clientDetail = [Responce!]
                    self.client_encrypt_Id = self.clientDetail[0].data.client_encrypt_id
                    UserDefaults.standard.set(self.client_encrypt_Id, forKey: "clientId")
                    self.downloadEventData(client_encrypt_id: self.client_encrypt_Id)
                    
                }
            }
        }
    }
    
    func downloadEventData(client_encrypt_id : String)
    {
        APIManager.sharedInstance.getClientEvents(clientID: client_encrypt_id) { (req,Responce, Error) in
    
                if Error != nil
                {
                    print("Error to fetch client Events")
                    SKActivityIndicator.dismiss()
                }
                else
                {
                    self.clientAllEvents = [Responce!]
                    self.clientEventsData = self.clientAllEvents[0].data
                    SKActivityIndicator.dismiss()
                    let nav = self .storyboard?.instantiateViewController(withIdentifier: "EventList") as! EventList
                    nav.ClientEventsData = self.clientEventsData
                    self.navigationController?.pushViewController(nav, animated: true)
                }
        }
    }
    
    func tapGestureForRememberMe()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RememberMe))
        tap.numberOfTapsRequired = 1
        rememberMelabel.isUserInteractionEnabled = true
        self.rememberMelabel.addGestureRecognizer(tap)
    }
    
    @objc func RememberMe(sender:UITapGestureRecognizer)
    {
        if flag == 1
        {
            flag = 0
            checkMarkButton.setImage(nil, for: .normal)
            UserDefaults.standard.set("", forKey: "userEmail")
            UserDefaults.standard.set("", forKey: "userPassword")
        }
        else
        {
            checkMarkButton.setImage(UIImage(named: "checkMark.png"), for: .normal)
            flag = 1
            UserDefaults.standard.set(userEmail.text, forKey: "userEmail")
            UserDefaults.standard.set(userpassword.text, forKey: "userPassword")
        }
    }
    
    func chekMarkButtonBorder()
    {
        checkMarkButton.layer.borderWidth = 1
        checkMarkButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        checkMarkButton.setImage(nil, for: .normal)
        tapGestureForRememberMe()
    }
    
    @IBAction func signInAction (_ sender : UIButton!)
    {
        performClientLogin()
    }
    
    @IBAction func checkMarkAction (_ sender : UIButton!)
    {
        if flag == 1
        {
            flag = 0
            checkMarkButton.setImage(nil, for: .normal)
            UserDefaults.standard.set("", forKey: "userEmail")
            UserDefaults.standard.set("", forKey: "userPassword")
        }
        else
        {
            checkMarkButton.setImage(UIImage(named: "checkMark.png"), for: .normal)
            flag = 1
            UserDefaults.standard.set(userEmail.text, forKey: "userEmail")
            UserDefaults.standard.set(userpassword.text, forKey: "userPassword")
        }
    }
    
    @IBAction func forgetPassword (_ sender : UIButton!)
    {
        recoverAccountView.fadeIn()
    }
    
    @IBAction func sendResetAction(_ sender:UIButton!)
    {
        /*if resetEmailField.text == ""
        {
            print("Enter Email in field")
        }
        else
        {
            //resetPassword()
            recoverAccountView.fadeOut()
        }*/
        
        recoverAccountView.fadeOut()
    }

    func resetPassword()
    {
        APIManager.sharedInstance.resetPassword(clientEmail: resetEmailField.text!) { (request, response, error) in
            
            if error != nil {
                print("Error in Reset Password")
            }
            else
            {
                if response["status"].boolValue == true
                {
                    print("Reset Succeesfull")
                }
            }
        }
    }
}

extension UIView {
    
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func fadeOutOnstarting() {
        UIView.animate(withDuration: 0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
