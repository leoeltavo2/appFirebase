//
//  ViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var lblCorreoL: UITextField!
    @IBOutlet weak var lblPassL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mantener sesin
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String{
        self.performSegue(withIdentifier: "iniciarSesion", sender: self)
        }
    }
    
    //MARK: alerta
    func mensajeAlerta(msg: String){
        let alerta = UIAlertController(title: "ERROR", message: msg, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: nil))
        present(alerta, animated: true, completion: nil)
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        if let email = lblCorreoL.text, let password = lblPassL.text{
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error{
                    
                    self.mensajeAlerta(msg: "Error: \(e.localizedDescription)")
                    
                }else{
                    self.performSegue(withIdentifier: "iniciarSesion", sender: self)
                }
                
            }
        }
        
    }
//    MARK: GOOGLE
    @IBAction func btnGoogle(_ sender: UIButton) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
//
//          if let error = error {
//            mensajeAlerta(msg: "Error: \(error.localizedDescription)")
//            return
//          }
//
//          guard
//            let authentication = user?.authentication,
//            let idToken = authentication.idToken
//          else {
//            return
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                  let authError = error as NSError
//                  if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
//                    // The user is a multi-factor user. Second factor challenge is required.
//                    let resolver = authError
//                      .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//                    var displayNameString = ""
//                    for tmpFactorInfo in resolver.hints {
//                      displayNameString += tmpFactorInfo.displayName ?? ""
//                      displayNameString += " "
//                    }
//                    self.showTextInputPrompt(
//                      withMessage: "Select factor to sign in\n\(displayNameString)",
//                      completionBlock: { userPressedOK, displayName in
//                        var selectedHint: PhoneMultiFactorInfo?
//                        for tmpFactorInfo in resolver.hints {
//                          if displayName == tmpFactorInfo.displayName {
//                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                          }
//                        }
//                        PhoneAuthProvider.provider()
//                          .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
//                                             multiFactorSession: resolver
//                                               .session) { verificationID, error in
//                            if error != nil {
//                              print(
//                                "Multi factor start sign in failed. Error: \(error.debugDescription)"
//                              )
//                            } else {
//                              self.showTextInputPrompt(
//                                withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
//                                completionBlock: { userPressedOK, verificationCode in
//                                  let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
//                                    .credential(withVerificationID: verificationID!,
//                                                verificationCode: verificationCode!)
//                                  let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
//                                    .assertion(with: credential!)
//                                  resolver.resolveSignIn(with: assertion!) { authResult, error in
//                                    if error != nil {
//                                      print(
//                                        "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
//                                      )
//                                    } else {
//                                      self.navigationController?.popViewController(animated: true)
//                                    }
//                                  }
//                                }
//                              )
//                            }
//                          }
//                      }
//                    )
//                  } else {
//                    self.showMessagePrompt(error.localizedDescription)
//                    return
//                  }
//                  // ...
//                  return
//                }
//                // User is signed in
//                // ...
//            }
//        }
    }
}

