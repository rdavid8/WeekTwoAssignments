
import UIKit

//Implement handling multiple accounts

/*
Closures

Can capture and store refereces to variables. Closing Over the Variable from the context from which the variable was defined

Closures are like ballons. Balloons capture air and returns it if it needs to.

Doesn't depend on the variable existing any more

Useful because

When you animate. you pass in functionality that animates over the parameter of time.
*/

//Global

//Nested

//Closure Expression


var closure: (Int, String) -> ()
//closure is of type function


//func setUp() {
//    
//    let text = "Hi"
//    let code = 100
//    
//    let cls: closure = {(param, param2) in
//       self.text  = param
//        self.code = parm2
//    }
//}


/*
Network Calls:

Executing functions that fire after the requests come back.
*/




/*
Closure Features:

if the closure is the last parameter of the function then it is a trailing closure.

*/

var arr = [1,2,3,4,5]
arr.sort({$0 < $1})
print(arr.sort({$0 > $1}))


/*
Accounts FrameWork
ACAcountStore

get a ref to account store
get a ref to acount type(twitter)
send request to count store
return an array of accounts


*/




/*
Social Framework

Request, and composing

To make request. SLRequest-easy way to perform network request for social framework
-this removes the need for you build a client
-execute request
-gives back jsondata

-Can You please integrate social media stuff in the app?

-perform request on the instance of that request

-SLRequest: request with handler.

*/





/*
Concurrecy

-a fancy work for multiple things happening at one time in an application.
Multithreading

-threads are light way to implement multiple paths of execution inside of an application

-app can have multiple threads going at once

-many tasks going on  at once

-improve reponsiveness of your app by multithreading

-in our app everything is happening on the main thread

-if there was a lot of data then this would take a lot time to load the tableview

-use multiple threads to manage this task. so the UI doesn't become blocked.

-keep away from main thread so that the ui doesn't become blocked

-every ui main update needs to happen on the main thread.

-UI on the backthreads will cause app to crash.

-Each thread needs to coordinate actions with other threads to prevent memory corruption

-threads cannot read write the same information at the same time or else there will be a crash.

-

*/




/*
NSOperationQueue

-use dispatch queues under the hood

An API that add operations to different threads

-you can add operations to queues individually

- you can create multiple queues and execute them simultaneously

-serial queue one after another

Queues V Threads:
-queues are much safer than threads

*/


var background = NSOperationQueue()

background.addOperationWithBlock { () -> Void in
    
}

NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
    
}

/*

Http Status Code:


*/




/*
Switch Statements



*/



/*

*/



/*

*/


/*

*/