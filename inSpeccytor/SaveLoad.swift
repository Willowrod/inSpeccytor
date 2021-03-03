//
//  SaveLoad.swift
//  inSpeccytor
//
//  Created by Mike Hall on 01/03/2021.
//

import Foundation
import FilesProvider

protocol SaveLoadDelegate {
    func fileLoaded(listing: CodeListing)
    func fileSaved()
}

class SaveLoad {
    static let instance: SaveLoad = SaveLoad()
    
    private var documentProvider: CloudFileProvider? = nil
    
    private var delegate: SaveLoadDelegate? = nil
    
    private init() {
        DispatchQueue.background(background: {
            self.documentProvider = CloudFileProvider(containerId: nil)
        }, completion:{
            print("CloudFileProvider created")
        })
    }
    
    func setDelegate(delegate: SaveLoadDelegate){
        self.delegate = delegate
    }
    
    func save(jsonObject: CodeListing, toFilename filename: String) throws -> Bool{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
        let data = try encoder.encode(jsonObject)
        print(String(data: data, encoding: .utf8)!)
            if let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"){
            var fileURL = driveURL.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            //    print("Saving to: \(fileURL.absoluteString)")
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func load(filename: String){
        DispatchQueue.background(background: {
                                    self.documentProvider?.contents(path: "\(filename).json"){    contents, error in
                                        if let contents = contents {
                                                    let encoder = JSONEncoder()
                                                    encoder.outputFormatting = .prettyPrinted
                                            do {
                                                 let listing = try JSONDecoder().decode(CodeListing.self, from: contents)
                                                DispatchQueue.main.sync {
                                                    self.delegate?.fileLoaded(listing: listing)
                                                }
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                        
                                    }        }, completion:{
            print("Load completed")
        })

        
        
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//        //let data = try encoder.encode(jsonObject)
//            if let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"){
//            var fileURL = driveURL.appendingPathComponent(filename)
//            fileURL = fileURL.appendingPathExtension("json")
//              //  print("Saving to: \(fileURL.absoluteString)")
//            //try data.write(to: fileURL, options: [.atomicWrite])
//
//                //let contents = NSData(contentsOfFile: fileURL.absoluteString)
//                let data = try Data(contentsOf: fileURL)   //contents! as Data
//               // print(String(data: data, encoding: .utf8)!)
//                return try JSONDecoder().decode(CodeListing.self, from: data)
//
//
//            }
//        } catch {
//            print(error)
//        }
    //    return listing
    }
    
}
