import Foundation

/**
 Async operation helps scheduling async functionalities e.g. API calls, UI implementation.
 However, to use this class it is important that operation's isFinished is marked true as soon as the execution is over. It will ensure that the operation is off the queue and next operations(dependent) can be started
 */
public class AsyncOperation : Operation
{
    
    private let lockQueue = DispatchQueue(label: "com.queue.operation", attributes: .concurrent)

     internal var _isFinished: Bool = false
     public override internal(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    internal var _isExecuting: Bool = false
     public override internal(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    
}

