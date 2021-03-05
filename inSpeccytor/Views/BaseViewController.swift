//
//  BaseViewController.swift
//  inSpeccytor
//
//  Created by Mike Hall on 12/01/2021.
//

import UIKit
import FilesProvider

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CPUDelegate, CodeLineDelegate, SaveLoadDelegate, DisassemblyDelegate, UICollectionViewDelegate, UICollectionViewDataSource {


    
    func fileSaved() {
        
    }
    @IBOutlet weak var screenRender: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var hexView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var programCounter: UITextField!
    @IBOutlet weak var jumpBox: UITextField!
    @IBOutlet weak var baseSelector: UISegmentedControl!
    @IBOutlet weak var ramViewTable: UICollectionView!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var snapShotTableView: UITableView!
    
    @IBOutlet weak var routineTableView: UITableView!
    
    
    @IBOutlet weak var primaryFunction: UISegmentedControl!
    
    let pCOffset = 16384 - 27
    let lineCellIdentifier = "lineCell"
    let mainCellIdentifier = "codeCell"
    let ramCellIdentifier = "ramCell"
    let routineCellIdentifier = "routineCell"
    var model: [CodeByteModel] = []
    var opCodes: [OpCode] = []
    var stopAfterEachOpCode = false
    var shouldDisplayScreen = false
    let borderX = 0 //32
    let borderY = 0 //24
    var computer: CPU? = nil
    let opcodeLookup = OpCodeDefs()
    var frames = 1
    var seconds = 1
    var lastcount = 0
    var lastFlashChange = 0.0
    var flashOn = false
    var useHexValues = false
    var lastSecond: TimeInterval = Date.init().timeIntervalSince1970
    var pCInDisAssembler = 0

    var entryPoints: [Int] = []
    var alreadyAdded: [Int] = []
    var currentEntryPoint = 0
    var isCalc = false
    var snapShots: [String] = []
    
    var assembler = Z80Assembler()
    
    var currentLineType: TypeOfTarget = .CODE
    var currentLinePosition = 0
    var lastSelectedLine = 0
    
    var computerModel: ComputerModel = .ZXSpectrum_48K  //.ZXSpectrum_128K//
    
    
    var codeStart: UInt16 = 0x5CCB
    
    var current_d_filename = ""
    var current_c_filename = ""
    
    var withRom = true
    
    var sizeOfLastJumpMap = 0
    
    
    var memoryModel: [UInt8] = []
    
    var routineModel: [CodeRoutine] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        screenRender.setUpImageView()
        SaveLoad.instance.setDelegate(delegate: self)
//        updateBorder(colour: Color.red)
        self.snapShotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "snapshotcell")
        self.snapShotTableView.isHidden = true
        bootEmulator()
    }
    
    func refreshTables() {
        mainTableView.reloadData()
        routineTableView.reloadData()
        tableView.reloadData()
    }
    
    func bootEmulator(){
        switch computerModel {
        case .ZXSpectrum_48K:
            computer = ZXSpectrum48K()
        case .ZXSpectrum_128K:
            computer = ZXSpectrum128K()
        default:
            print("Model \(computerModel.rawValue) is not currently supported")
        }
        computer?.delegate = self
        computer?.writeCodeBytes()
        startProcessor()
    }
    
    func startProcessor(){
        DispatchQueue.background(background: {
            self.computer?.process()
        }, completion:{
            // when background job finished, do something in main thread
        })
    }
    
    func alertUser(alertBody: String){
        let alert = UIAlertController(title: "Inspeccytor", message: alertBody, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func keyboardInteraction(key: Int, pressed: Bool){
        
            switch computerModel {
            case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
                if let speccy = computer as? ZXSpectrum {
                    speccy.keyboardInteraction(key: key, pressed: pressed)
                }
            default:
                print("Model \(computerModel.rawValue) is not currently supported")
            }
    }
    
    func joystickInteraction(key: Int, pressed: Bool){
        switch computerModel {
        case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
            if let speccy = computer as? ZXSpectrum {
                speccy.joystickInteraction(key: key, pressed: pressed)
            }
        default:
            print("Model \(computerModel.rawValue) is not currently supported")
        }
        
        
    }
    
  
    
  
    
    func updateFPS(){
        let timestamp = Date.init().timeIntervalSince1970
        if timestamp > lastSecond + 1 {
            lastSecond = timestamp
            seconds += 1
            //hexView.text = "FPS: \(frames / seconds) in \(seconds) seconds"
        }
        frames += 1
    }
    
    // Disassembler
    
    func updatePC(){
        if let pc = programCounter.text, !isHex() , let pcUint = Int(pc) {
            pCInDisAssembler = pcUint
        resetDisassembly()
            return
        }
        
        if let pc = programCounter.text, isHex() , let pcUint = Int(pc, radix: 16) {
            pCInDisAssembler = pcUint
            resetDisassembly()
                return
        }
          
            switch computerModel {
            case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
                if let speccy = computer as? ZXSpectrum {
                    pCInDisAssembler = Int(speccy.header.registerPC)
                }
            default:
                print("Model \(computerModel.rawValue) is not currently supported")
            }
resetDisassembly()

        updatePCFromSnapshot()
        
    }
    
    func updatePCFromSnapshot(){
        switch computerModel {
        case .ZXSpectrum_48K, .ZXSpectrum_128K, .ZXSpectrum_128K_Plus2, .ZXSpectrum_128K_Plus3:
            if let speccy = computer as? ZXSpectrum {
                pCInDisAssembler = Int(speccy.header.registerPC)
            }
        default:
            print("Model \(computerModel.rawValue) is not currently supported")
        }
resetDisassembly()
        updatePCUI(pc: pCInDisAssembler)
    }
    
    func resetDisassembly(){
        entryPoints.removeAll()
        entryPoints.append(pCInDisAssembler)
        currentEntryPoint = 0
    }

    func updatePCUI(){
        programCounter.text = isHex() ? String(pCInDisAssembler, radix: 16) : "\(pCInDisAssembler)"
        if (pCInDisAssembler < model.count){
            let targetRowIndexPath = IndexPath(row: pCInDisAssembler, section: 0)
            tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
    }

    
    func updatePCUI(pc: UInt16){
        updatePCUI(pc: Int(pc))
    }
    
    func isHex() -> Bool {
        return baseSelector.selectedSegmentIndex == 0
    }
    
    func isDisassembly() -> Bool{
        return primaryFunction.selectedSegmentIndex == 1
    }
    
    func isEmulator() -> Bool{
        return primaryFunction.selectedSegmentIndex == 0
    }
    
    func isIDE() -> Bool{
        return primaryFunction.selectedSegmentIndex == 2
    }
    
    func updatePCUI(pc: Int){
        
        programCounter.text = isHex() ? String(pc, radix: 16) : "\(pc)"
        if let modelPosition = opCodes.firstIndex(where: {$0.line == pc}){
       // let modelPosition = pc - pCOffset
        if (modelPosition < model.count){
            let targetRowIndexPath = IndexPath(row: modelPosition, section: 0)
               tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
        }
        }
    }
    
    func disassemblyComplete(disassembly: [OpCode]) {
        opCodes = disassembly
        opCodes.sort{$0.line < $1.line}
        refreshTables()
        alertUser(alertBody: "Disassembly complete - found \(disassembly.count) lines of code")
    }
    
    func disassemblyComplete(codeRoutines: [CodeRoutine]) {
        opCodes = []
        routineModel = codeRoutines
        codeRoutines.forEach{ routine in
            opCodes.append(contentsOf: routine.code)
        }
        opCodes.sort{$0.line < $1.line}
        refreshTables()
        alertUser(alertBody: "Disassembly complete - found \(opCodes.count) lines of code in \(codeRoutines.count) routines")
    }
    
    func addNewLineOfCode(){
        var newLine = OpCode.init(v: "", c: "", m: "", l: 0)
        newLine.lineType = currentLineType
        newLine.isNewLine = true
        newLine.shouldAutoFocus = true
        if (currentLinePosition < opCodes.count){
        opCodes.insert(newLine, at: currentLinePosition)
        } else {
            opCodes.append(newLine)
        }
        refreshTables()
    }
    
    func checkIfNewLineRequired(){
        if let newLine = opCodes.firstIndex(where: {$0.isNewLine}) {
            opCodes.remove(at: newLine)
        }
            currentLinePosition += 1
            addNewLineOfCode()
       
        
    }
    
    
    @IBAction func insertLine(_ sender: Any) {
        if primaryFunction.selectedSegmentIndex == 2 {
        currentLinePosition = lastSelectedLine
        checkIfNewLineRequired()
        }
    }
    

    @IBAction func saveCode(_ sender: Any) {
        switch primaryFunction.selectedSegmentIndex {
        case 1:
            d_saveCode()
        case 2:
            c_saveCode(fileName: "savedCode")
        default:
            break
        }
    }
    
    
    @IBAction func loadCode(_ sender: Any) {
        switch primaryFunction.selectedSegmentIndex {
        case 1:
            d_loadCode()
        case 2:
            c_loadCode(fileName: "savedCode")
        default:
            break
        }
    }
    
    @IBAction func clearCode(_ sender: Any) {
        model.removeAll()
        opCodes.removeAll()
        currentLinePosition = 0
            switch primaryFunction.selectedSegmentIndex {
            case 2:
addNewLineOfCode()
            default:
                break
            }
        refreshTables()
    }
    
    func negateNewLine(id: Int){
        opCodes[id].isNewLine = false
        checkIfNewLineRequired()
    }
    
    // Delegates
    
    // Code Line Delegate
    
    func updateComment(id: Int, comment: String) {
        if id < opCodes.count{
        opCodes[id].meaning = comment
        }
    }
    
    func updateOpCode(id: Int, comment: String) {
        if id < opCodes.count && !comment.isEmpty{
            opCodes[id].addCode(opCode: comment)
            negateNewLine(id: id)
        }
    }
    
    func updateByteValue(id: Int, comment: String) {
        if id < opCodes.count{
            opCodes[id].opCodeString = comment
            negateNewLine(id: id)
        }
    }
    func updateLineType(id: Int, comment: TypeOfTarget) {
        if id < opCodes.count{
        opCodes[id].lineType = comment
        }
        currentLineType = comment
        refreshTables()
    }
    
    func updateJumpLabel(id: Int, comment: String) {
        if id < opCodes.count{
            opCodes[id].label = comment
        }
    }
    
    // CPU Delegate
    
    func updateCodeByteModel(model: [CodeByteModel]){
    }
    
    func updateTitle(title: String){
        fileName.text = title
    }
    
    func updateBorder(colour: Color){
        border.backgroundColor = colour.toUIColor()
    }
    
    func updateRegisters() {
        
    }
    
    func updateView(bitmap: Bitmap?) {
        updateFPS()
        if let bitmap = bitmap{
           screenRender.image = (UIImage(bitmap: bitmap))
        }
        updateRegisters()
    }
    
    
    func updateDebug(line: UInt16){
        var targLine = Int(line) - 4
        if targLine < 0 {
            targLine = 0
        }
        guard let index = model.firstIndex(where: {$0.lineNumber == targLine}) else { return }
        let targetRowIndexPath = IndexPath(row: index, section: 0)
        tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
    }
    
    func hideSnapShotTable(){
        
    }
    
    func createFileList(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        snapShots.removeAll()
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found: \(item)")
                if item.contains(".sna") || item.contains(".z80") { //} || item.contains(".zip"){
                 //   print("Adding: \(item)")
                    snapShots.append(item)
                }
            }
            snapShots.sort()
            snapShotTableView.reloadData()
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    // Tables
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.snapShotTableView){
            return self.snapShots.count
        }
        if (tableView == mainTableView){
            return self.opCodes.count
        }
        if (tableView == routineTableView){
            return self.routineModel.count
        }
        return self.model.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if (tableView == self.snapShotTableView){
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "snapshotcell") as UITableViewCell?)!
            cell.textLabel?.text = snapShots[row]
            return cell
        }
        if (tableView == mainTableView){
            switch primaryFunction.selectedSegmentIndex {
            case 1:
                return d_mainTableViewCell(indexPath: indexPath)
            case 2:
                return c_mainTableViewCell(indexPath: indexPath)
            default:
                return UITableViewCell.init()
            }
        } else if (tableView == routineTableView){
//            switch primaryFunction.selectedSegmentIndex {
//            case 1:
//                return d_mainTableViewCell(indexPath: indexPath)
//            case 2:
//                return c_mainTableViewCell(indexPath: indexPath)
//            default:
//                return UITableViewCell.init()
//            }
        let cell = tableView.dequeueReusableCell(withIdentifier: routineCellIdentifier, for: indexPath) as! RoutineTableViewCell
        let thisLine = self.routineModel[row]
        cell.routine.text = thisLine.title
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: lineCellIdentifier, for: indexPath) as! LineTableViewCell
            let thisLine = self.model[row]
            if isHex() {
            cell.lineNumber.text = "\(String(thisLine.lineNumber, radix: 16))"
            } else {
                cell.lineNumber.text = "\(thisLine.lineNumber)"
                }
            cell.hexValue.text = thisLine.hexValue
            cell.intValue.text = "\(thisLine.intValue)"
            let breakPoint = UInt16(thisLine.lineNumber)
            if let breakPoints = computer?.breakPoints, breakPoints.contains(breakPoint){
                cell.backgroundColor = UIColor.yellow
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == snapShotTableView){
            let row = indexPath.row
            let thisFile = self.snapShots[row]
            computer?.load(file: thisFile)
            updatePCFromSnapshot()
            hideSnapShotTable()
        } else if (tableView == mainTableView){
            let row = indexPath.row
            lastSelectedLine = row
            let thisLine = self.opCodes[row]
            if (thisLine.target > 0){
                if let target = self.opCodes.firstIndex(where: {$0.line == thisLine.target}) {
                    let targetRowIndexPath = IndexPath(row: target, section: 0)
                    tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
                    mainTableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
                }
                
            }
        } else if (tableView == routineTableView){
            let row = indexPath.row
            let thisLine = self.routineModel[row]
                if let target = self.opCodes.firstIndex(where: {$0.line == thisLine.startLine}) {
                    let targetRowIndexPath = IndexPath(row: target, section: 0)
                   // tableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
                    mainTableView.scrollToRow(at: targetRowIndexPath, at: .top, animated: true)
                }
                
        } else if (tableView == self.tableView){
            let row = indexPath.row
            let thisLine = self.model[row]
            let breakPoint = UInt16(thisLine.lineNumber)
            if let breakPoints = computer?.breakPoints{
            if breakPoints.contains(breakPoint){
                while breakPoints.contains(breakPoint){
                    if let index = breakPoints.firstIndex(of: breakPoint) {
                        computer!.breakPoints.remove(at: index)
                    }
                }
                
            } else {
                computer!.breakPoints.append(breakPoint)
            }
            }
            tableView.reloadData()
        }
    }
    
    // Collection View Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoryModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     //   return UICollectionViewCell()
        let cell = ramViewTable.dequeueReusableCell(withReuseIdentifier: ramCellIdentifier, for: indexPath) as! RamCollectionViewCell
        
        let thisLine = self.memoryModel[indexPath.row]
        cell.value.text = thisLine.hex()
        return cell
    }
    
    
    // File Provider Delegates
    
    func fileLoaded(listing: CodeListing) {
        switch primaryFunction.selectedSegmentIndex {
        case 1:
            d_codeLoaded(listing: listing)
        case 2:
            c_codeLoaded(listing: listing)
        default:
            break
        }
    }

    
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType, error: Error) {
        print("File load failed: \(error.localizedDescription)")
        //        switch primaryFunction.selectedSegmentIndex {
        //        case 1:
        //            d_codeLoaded()
        //        case 2:
        //            c_codeLoaded()
        //        default:
        //            break
        //        }
    }
        
    func fileproviderProgress(_ fileProvider: FileProviderOperations, operation: FileOperationType, progress: Float) {
//        switch operation {
//        case .copy(source: let source, destination: let dest):
//            print("Copy\(source) to \(dest): \(progress * 100) completed.")
//        default:
//            break
//        }
    }
    
    

}
extension UIImageView {
    func setUpImageView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.magnificationFilter = .nearest
        self.backgroundColor = .black
    }
}
