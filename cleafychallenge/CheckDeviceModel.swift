//
//  CheckDeviceModel.swift
//  cleafychallenge
//
//  Created by SERTORIG on 13/12/21.
//

import Foundation

class CheckDeviceModel {
    public var errorString: String?
    
    init() { }
    
    //MARK: - This function calls the api https://api.github.com/repos/owner/repoName/stargazers and with the completion returns a result, .failure if there are errors and .ok if the response is succesfully parsed into a an array of strings.
    func fetchStargazers(owner: String, repoName: String, completion: @escaping (StartResult) -> ()) {
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repoName)/stargazers")!
        let _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let errore = error {
                self.errorString = errore.localizedDescription
                completion(.failure(errore.localizedDescription))
            } else {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 404 || response.statusCode == 422 {
                        completion(.failure("The owner or the repository entered do not exist"))
                    } else if response.statusCode == 200 {
                        guard let data = data else { return completion(.failure("Failed to parse the data")) }
                        do {
                            var stargazersList = [String]()
                            let json = try? JSONDecoder().decode([StargazersResponseModel].self, from: data)
                            if let response = json {
                                for stargazer in response {
                                    stargazersList.append(stargazer.login)
                                }
                                completion(.ok(stargazersList))
                            } else if let error = error {
                                self.errorString = error.localizedDescription
                                completion(.failure(error.localizedDescription))
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    
}
