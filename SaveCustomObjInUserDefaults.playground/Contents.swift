//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

typealias CalcFunc = String //(Double) -> Double?


class FuncStorage : NSObject, NSCoding {

    var calcFunc : CalcFunc
    
    
    required init(savedFunc : CalcFunc) { //@escaping CalcFunc) {
        self.calcFunc = savedFunc
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        calcFunc = aDecoder.decodeObject(forKey: "calcFunc") as! CalcFunc
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(calcFunc, forKey: "calcFunc")
    }
    
}

func archiveFunc(calcFunc : FuncStorage) -> NSData {
    let archivedObject = NSKeyedArchiver.archivedData(withRootObject: calcFunc)
    return archivedObject as NSData
}

func saveFunc(calcFunc : NSData) {
    let ud = UserDefaults.standard
    ud.set(calcFunc, forKey: "calcFuncKey")
    if  !ud.synchronize() { print("calcFunc not saved")  }
}

func retriveFunc() -> CalcFunc? {
    let ud = UserDefaults.standard
    if let unarchivedObject = ud.object(forKey: "calcFuncKey") {
        print("test")
        let unarchivedObjectData = unarchivedObject as! NSData
        let funcStorage = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObjectData as Data) as! FuncStorage
        return funcStorage.calcFunc
        
    }
    
    return nil
}



let myFunc : CalcFunc  = "{$0*$0}"

let myFuncWraped = FuncStorage(savedFunc: myFunc)

let myFuncAsData = archiveFunc(calcFunc: myFuncWraped)

saveFunc(calcFunc: myFuncAsData)

if let retMyFunc = retriveFunc() {
    let res = retMyFunc //(2)!
    print("Func result: \(res)")
}








