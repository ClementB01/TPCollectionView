//
//  ViewController.swift
//  TPCollectionView
//
//  Created by lpiem on 13/03/2020.
//  Copyright © 2020 lpiem. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    enum SectionData: CaseIterable {
        case serieCharacters
        case second
    }
    
    private static  let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private var seriesCharacters: [SeriesCharacter] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchCharaters()
    }
    
    private func fetchCharaters() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else {
                    // TODO: Handle Error
                    return
            }
            
            guard let data = data,
                let mimeType = httpResponse.mimeType,
                mimeType == "application/json"
                else {
                    // TODO: Handle Error
                    return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let dateString = try decoder.singleValueContainer().decode(String.self)
                    let date = ViewController.iso8601Formatter.date(from: dateString)!
                    
                    return date
                })
                
                let result = try jsonDecoder.decode(PaginedElements<SeriesCharacter>.self, from: data)
                
                DispatchQueue.main.async {
                    self.seriesCharacters = result.decodedElements
                }
            } catch {
                // TODO: Handle Error
                return
            }
        }
        task.resume()
    }
    
    //MARK: - TableView Methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionData.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Color.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCell", for: indexPath) as! SerieCharacterTableViewCell
        
        //let seriesCharacter = seriesCharacters[indexPath.item]
        
        switch SectionData.allCases[indexPath.section] {
        case SectionData.serieCharacters:
            //cell.configure(title: seriesCharacter.name, imageURL: seriesCharacter.imageURL)
            cell.configure(title: "coucou")//, imageURL: )
        case SectionData.second:
            cell.backgroundColor = Color.allCases[indexPath.item].uiColor
        }
            
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch SectionData.allCases[indexPath.section] {
        case SectionData.serieCharacters:
            return CGSize.init(width: 50, height: 50)
        case SectionData.second:
            return CGSize.init(width: 100, height: 100)
        }
        
    }
    
}

