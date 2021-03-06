//
//  CreateNewTaskViewController.swift
//  TDC
//
//  Created by Wilson Yan on 8/14/16.
//  Copyright © 2016 Wilson Yan. All rights reserved.
//

import UIKit

//TODO: MAKE IT LOOK NICER
class CreateNewTaskViewController: UIViewController {
    weak var recentViewController: UIViewController?
    var currentTask: Task?
    
    private var isChecked: Bool = false {
        didSet {
            checkButton.setImage(UIImage(named: isChecked ? "CheckedBox" : "UncheckedBox"), for: .normal)
        }
    }
    
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var errorText: UILabel!
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var checkButton: UIButton!

    @IBAction func onSelected(_ sender: UIButton) {
        isChecked = !isChecked
        durationTextField.isUserInteractionEnabled = !isChecked
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView.layer.cornerRadius = 10
        formView.layer.borderWidth = 1
        formView.layer.borderColor = UIColor.blue.cgColor
        
        formView.layer.shadowOffset = CGSize(width: 5, height: -5)
        formView.layer.shadowRadius = 2
        formView.layer.shadowOpacity = 0.1
        
        let visuaEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visuaEffectView.frame = self.view.bounds
        self.view.insertSubview(visuaEffectView, at: 0)
        
        taskNameTextField.autocapitalizationType = .sentences
        
        if let task = currentTask{
            taskNameTextField.text = task.name
            durationTextField.text = String(describing: task.duration!)
        }
        checkButton.setImage(UIImage(named: "UncheckedBox"), for: .normal)
    }
    
    @IBAction func save() {
        if let tlvc = recentViewController as? TaskListViewController{
            if let duration = Int(durationTextField.text!), let taskName = taskNameTextField.text , duration >= 0{
                if currentTask != nil {
//                    Task.updateEditedTask(currentTask!.primaryId! as Int, withName: taskName, inManagedObjectContext: tlvc.managedContext)
                    Task.updateTask(currentTask!.primaryId as! Int, withInfo: [TaskAttributes.Name:taskName as AnyObject], inManagedObjectContext: tlvc.managedContext)
                    _ = tlvc.loadCurrentTasks()
                } else {
                    let task = Task.saveTask(taskName, duration: duration, inManagedObjectContext: tlvc.managedContext)
                    tlvc.updateListWhenNewTask(task)
                }
                dismiss(animated: true, completion: nil)
            } else {
                errorText.text = "Invalid duration. Must be a whole number"
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
