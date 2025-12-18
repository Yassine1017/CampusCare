//
//  signInPageViewController.swift
//  CampusCare_S3_G5
//
//  Created by MOHAMED ALTAJER on 15/12/2025.
//

import UIKit

class signInPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
                title: "Success",
                message: "Login successful. Welcome.",
                preferredStyle: .alert
            )

            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            }

            alert.addAction(okAction)
            self.present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
