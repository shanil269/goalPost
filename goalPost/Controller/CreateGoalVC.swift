//
//  CreateGoalVC.swift
//  goalPost
//
//  Created by Muhaimin on 6/7/20.
//  Copyright © 2020 Muhaimin. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var dismissClosure: (() -> ())?
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.bindToKeyboard()
        shortTermBtn.setSelectorColor()
        longTermBtn.setDeselectorColor()
        goalTextView.delegate = self
        
    }
    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermBtn.setSelectorColor()
        longTermBtn.setDeselectorColor()
        
    }
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        goalType = .longterm
        longTermBtn.setSelectorColor()
        shortTermBtn.setDeselectorColor()
        
    }
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if goalTextView.text != "" && goalTextView.text != "What is your goal?" {
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoalVC") as? FinishGoalVC  else { return }
            finishGoalVC.initData(description: goalTextView.text!, type: goalType)
//            presentingViewController?.presentSecondaryDetail(finishGoalVC)
            present(finishGoalVC, animated: true) {
                finishGoalVC.dismisshandler = {
                    self.dismissClosure?()
                }
            }

        }
        
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
