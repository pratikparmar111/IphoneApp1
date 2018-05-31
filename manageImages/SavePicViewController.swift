//
//  SavePicViewController.swift
//  manageImages
//
//  Created by Pratik Anilkumar Parmar on 2/11/17.
//  Copyright © 2017 Pratik Anilkumar Parmar. All rights reserved.
//

import UIKit

import CoreData

class SavePicViewController:    UIViewController ,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextViewDelegate
{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextFiled: UITextField!
    
    @IBOutlet weak var date: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pickImageAction(_ sender: Any) {
        
        //for photo lib
        let controller=UIImagePickerController();
        controller.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        controller.allowsEditing = false;
        present(controller, animated: true, completion: nil)
        controller.delegate = self;
        
    }
    
    @IBAction func pickImageCameraAction(_ sender: Any) {
        
        //for Camera
        let controller=UIImagePickerController();
        controller.sourceType = UIImagePickerControllerSourceType.camera;
        controller.allowsEditing = false;
        present(controller, animated: true, completion: nil)
        
        controller.delegate = self;
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image;
        dismiss(animated: false, completion: nil);
    }
    
    
    @IBAction func addImgeButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "PhotoLibraryDb", into: context)
        
        entity.setValue(nameTextField.text,forKey: "name")
        entity.setValue(locationTextFiled.text,forKey: "location")
        entity.setValue(date.date, forKey: "date")
        let image = UIImageJPEGRepresentation(imageView.image!, 1)
        entity.setValue(image, forKey: "pic")       
        
        
        do{
            try context.save()
            //print("Done");
            
            //showing alert on completing
            let alertwindoew = UIAlertController(title: "Saved", message: "Your image has been saved to Photo Library!", preferredStyle: .alert)
            alertwindoew.addAction(UIAlertAction(title: "Ok", style:UIAlertActionStyle.default ,handler: {(action) in alertwindoew.dismiss(animated: true, completion: nil) }))
            self.present(alertwindoew, animated: true, completion:nil)
            
        }
        catch{
            print("Error in data save");
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
