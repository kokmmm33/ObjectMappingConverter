//
//  ViewController.swift
//  ArgoParser
//
//  Created by Walig Castain on 21/12/15.
//  Copyright © 2015 Walig Castain. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ViewController: NSViewController {

    var properties = [String]()
    var objectMapping = [String]()

    @IBOutlet weak var classNameTextField: NSTextField!
    @IBOutlet var jsonTextView: NSTextView!
    @IBOutlet var parserTextView: NSTextView!
    @IBOutlet weak var convertButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func convertAction(sender: AnyObject) {

        self.properties = []
        self.objectMapping = []
        
        guard let jsonText = jsonTextView.string else {
            return
        }
        
        let data = jsonText.dataUsingEncoding(NSUTF8StringEncoding)
        let json = JSON(data: data!)
        let dictionaryKeys = json.map { $0.0 }.sort()
        
        for key in dictionaryKeys {

            switch json[key].type {
                
                case Type.Number:
                    self.properties.append("let " + key.underscoreToCamelCase + ": Int?")
                    self.objectMapping.append("<*> j <|? " + key.underscoreToCamelCase.wrappedBy("\"") )

                case Type.String:
                    self.properties.append("let " + key.underscoreToCamelCase + ": String?")
                    self.objectMapping.append("<*> j <|? " + key.underscoreToCamelCase.wrappedBy("\"") )

                case Type.Bool:
                    self.properties.append("let " + key.underscoreToCamelCase + ": Bool?")
                    self.objectMapping.append("<*> j <|? " + key.underscoreToCamelCase.wrappedBy("\"") )

                case Type.Array:
                    self.properties.append("let " + key.underscoreToCamelCase + ": [XXXXXXXXXXXXXXXXXXXXXXX]?")
                    self.objectMapping.append("<*> j <||? " + key.underscoreToCamelCase.wrappedBy("\"") )

                case Type.Dictionary:
                    self.properties.append("let " + key.underscoreToCamelCase + ": Dictionary?")
                    self.objectMapping.append("<*> j <|? " + key.underscoreToCamelCase.wrappedBy("\"") )

                case Type.Null:
                    self.properties.append("let " + key.underscoreToCamelCase + ": !!!!!!!!!!!!! ERROR !!!!!!!!!!!!!")
                    self.objectMapping.append("<*> j <|? " + key.underscoreToCamelCase.wrappedBy("\"") )

                case Type.Unknown:
                    self.properties.append("let " + key.underscoreToCamelCase + ": AnyObject?")
                    self.objectMapping.append("<*> j <|? " + key.underscoreToCamelCase.wrappedBy("\"") )

                return

            }
            
        }
        
        // making sure first element is using ^
        if let firstElement = self.objectMapping.first {
            self.objectMapping[0] = firstElement.stringByReplacingOccurrencesOfString("<*>", withString: "<^>")
        }

        self.generateFinalClass()
    }
    
    internal func generateFinalClass() {
        
        // # - Class name
        // ~ - Properties
        // $ - Argo Mapping
        
        let path = NSBundle.mainBundle().pathForResource("ArgoTemplate", ofType: "strings")
        var template = try! String(contentsOfFile: path!)
        
        template = template.stringByReplacingOccurrencesOfString("#", withString: self.classNameTextField.stringValue)
        template = template.stringByReplacingOccurrencesOfString("~", withString: self.properties.joinWithSeparator("\n\t"))
        template = template.stringByReplacingOccurrencesOfString("$", withString: self.objectMapping.joinWithSeparator("\n\t"))

        self.parserTextView.string = template
    }

}

