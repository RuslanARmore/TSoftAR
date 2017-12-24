//
//  SurveyViewController.swift
//  GPO
//
//  Created by Руслан Ахриев on 08.11.2017.
//  Copyright © 2017 Руслан Ахриев. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class SurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var surveyTitle = [String]()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        downloadSurvey()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadSurvey() {
        
       // print("\(UserDefaults.standard.value(forKey: "access_token")!)")
        let headers = [
            "Authorization" : "bearer " + String(describing: UserDefaults.standard.value(forKey: "access_token")!)
        ]
        Alamofire.request("http://codesurvey.r-mobile.pro/api/survey/", method: .get, headers: headers).responseJSON { (responseObject) in
            if responseObject.result.isSuccess {
                let resJSON = JSON(responseObject.result.value!)
                self.addInfoIntoRealm(resJSON)
                for (_,subJson):(String, JSON) in resJSON {
                    self.surveyTitle.append(subJson["title"].string!)
                    
                    
                }
                
                self.myTableView.reloadData()
                //print("lol")
            }
            if responseObject.result.isFailure{
                let error = responseObject.result.error as NSError?
                print(error!)
            }
        }
    }
    
    func addInfoIntoRealm(_ json : JSON) {
        //print(json)
        for (_,subJson) : (String, JSON) in json {
            print(subJson["title"])

                try! realm.write {
                    let survey = Survey()
                    survey.title = subJson["title"].stringValue
                    survey.id = subJson["id"].intValue
                    survey.instruction = ""
                    realm.add(survey, update: true)
                }
            
           
            print("*********")
            for (_, subJson2) : (String, JSON) in subJson["questions"] {
                print(subJson2["title"])
                print("******")
                for (_, subAnswersJson) : (String, JSON) in subJson2["answers"] {
                    print("ответ \(subAnswersJson["title"])")
                    print("next question \(subAnswersJson["nextQuestionId"])")
                    print("id \(subAnswersJson["id"])")
                
                }
            }
        }
        print(surveyTitle)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyTableViewCell
        cell.surveyTitle.text = surveyTitle[indexPath.row]
        return cell
        
    }
}
