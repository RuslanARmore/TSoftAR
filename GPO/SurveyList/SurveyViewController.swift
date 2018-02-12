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


struct Surveys : Decodable {
    let questions : [Questions]
    let title : String
    let id : Int
}

struct Questions : Decodable {
    let type : String
    let maxAnswerOptionsCanBeSelected : Int
    let answers : [Answers]
    let orderIndex : Int
    let title : String
    let id : Int
}
struct Answers : Decodable {
    let orderIndex : Int
    let nextQuestionId : Int?
    let title : String
    let id : Int
}
class SurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var surveyTitle = [String]()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        downloadSurvey()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadSurvey() {
        let webService = WebService()
        let headers = [
            "Authorization" : "bearer " + String(describing: UserDefaults.standard.value(forKey: "access_token")!)
        ]
        
        webService.getMethod("http://codesurvey.r-mobile.pro/api/api/survey/", headers) { (response) in
            let decoder = JSONDecoder()
            do {
                let survey = try decoder.decode([Surveys].self, from: response!)
                for title in survey {
                    print(title.title)
                    self.surveyTitle.append(title.title)
                    DispatchQueue.main.async {
                         self.myTableView.reloadData()
                    }
                }
                
            } catch {
                print(error)
            }
           
        }
//        Alamofire.request("http://codesurvey.r-mobile.pro/api/api/survey/", method: .get, headers: headers).responseJSON { (responseObject) in
//            if responseObject.result.isSuccess {
//                let resJSON = JSON(responseObject.result.value!)
//                self.addInfoIntoRealm(resJSON)
//                for (_,subJson):(String, JSON) in resJSON {
//                    self.surveyTitle.append(subJson["title"].string!)
//                }
//                self.myTableView.reloadData()
//            }
//            if responseObject.result.isFailure{
//                let error = responseObject.result.error as NSError?
//                print(error!)
//            }
//        }
         self.myTableView.reloadData()
    }
    
    func addInfoIntoRealm(_ json : JSON) {
       
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
