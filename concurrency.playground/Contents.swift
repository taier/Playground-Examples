/*
 This example demonstrates how to perform multiple numbers of tasks on the background thread,
 using concurrency (multithreading) and on the finish of all tasks notify UI.
 That could be used on different occasions, for example when you need to upload multiple photos
 to the server, and when the upload is done notify the user about that.
 Since devices can have multiple amounts of threads, we could take advantage of that
 to speed up the process.
 
 Deniss Kaibagarovs, deniss.kaibagarovs@gmail.com
 MIT License
*/

import UIKit
import PlaygroundSupport

/// Simulate single operation with random execution time
/// performed on the background thread
///
/// - Parameter completion: completion with random result
func doSomeStuff(_ completion: @escaping ((_ number: Int) -> Void)) {
  // add a task to the default background queue
  DispatchQueue.global(qos: .background).async {
    // generate a random value to return
    let number = UInt32.random(in: 0 ..< 5)
    // stop thread for a random time
    sleep(number)
    // return result to caller
    completion(Int(number))
  }
}

/// Simulate multiple items downloading/uploading and return final result
///
/// - Parameter completion: final composed number
func downloadStuff(_ completion: @escaping ((_ finalNumber: Int) -> Void)) {
  // add a taks to the priority background queue
  DispatchQueue.global(qos: .userInitiated).async {
    // create a dispatch group that would wait for all operations to finish work
    let dispatchGroupForTasks = DispatchGroup()
    // final number that would be composed from all operations
    var finalNumber = 0
    // create a queue that would serial a writing access to finalNumber
    let dispatchQueueForAddingNumber = DispatchQueue(label: "atomic finalNumber queue")
    // perform work 6 times
    for index in 0...5 {
      // notify group that there is a taks to wait for
      dispatchGroupForTasks.enter()
      // perform work
      doSomeStuff { (number) in
        print("Finish executing task with index: \(index), result: \(number)")
        // work is finished, append data
        // make sure that we dont have a race conditions
        dispatchQueueForAddingNumber.sync {
          finalNumber += number
        }
        // notify group that task is finished
        dispatchGroupForTasks.leave()
      }
    }
    // when all work is done
    dispatchGroupForTasks.notify(queue: .main) {
      // Execute completion on the main thread so caller wont need to
      // explicitly call it on main thread
      DispatchQueue.main.async {
        completion(finalNumber)
      }
    }
  }
}

class MyViewController : UIViewController {
  /// Indicator to indicate that something is in progress
  var activityIndicator: UIActivityIndicatorView!
  
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .black // make view iOS 13 ready :]
    activityIndicator = createActivityIndicatorOnView(view)
    self.view = view
  }
  
  override func viewDidLoad() {
    // indicate to the user that something is happening
    showActivityIndicator(true)
    // perform async multi thread task
    downloadStuff { [weak self] (finalNumber) in
      // when task is finished, indicate to the user that work is done
      self?.showActivityIndicator(false)
      print(finalNumber)
    }
  }
}

extension MyViewController {
  /// Creates and add a new activity indicator on a view and return its referece.
  /// Activity indicator would be centerd in view
  ///
  /// - Parameter view: view to add activity indicator on
  /// - Returns: activityIndicator that was added to the view
  private func createActivityIndicatorOnView(_ view: UIView) -> UIActivityIndicatorView {
    var activityIndicator = UIActivityIndicatorView()
    activityIndicator.style = .whiteLarge
    activityIndicator.startAnimating()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.isHidden = true
    view.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
    return activityIndicator
  }
  
  /// Show or hide activity indicator
  ///
  /// - Parameter show: show or hide activity indicator
  private func showActivityIndicator(_ show: Bool) {
    activityIndicator.isHidden = !show
  }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
