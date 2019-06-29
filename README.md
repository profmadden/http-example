# http-example
Sample code in iOS to post to the web, and get a response back.

Lots of apps need to be able to retrieve data from the web, so this is a simple example to do it (with both iOS and Android versions in the repository).

There's a simple PHP script running on the CS department web server that expects a number to come in from a "post" HTTP request. It then doubles that number, and returns the result as JSON.  The apps take a number typed into a text box on screen, send that to the web server (using a couple of simplified wrappers around the standard HTTP tools), and then put the result on screen when the web server respons.

There are a couple of "gotchas" to be careful of -- mostly revolving around the asynchronous nature of web interactions.  The iOS version of the code has a "completion block" that gets called when the response from the web server comes in.  THIS IS ON A THREAD THAT CANNOT ACCESS THE USER INTERFACE!  Note that in the ViewController, there is "performSelectorOnMainThread", which is called from the completion block.  This puts a request to call the function into a queue, and then when a thread that has access to the user interface runs, the function is called.

There's a "networker" class in the iOS code that you can grab and use; it makes the interactions with the HTTP classes a little easier (in my opinion!).  Values are set to the web server by creating an NSDictionary -- essentially a key/value array.  What comes back is JSON, and we can extract the result from that.

For Android, the structure is similar, and there are the same sort of thread-constraints.  In the Java code, there's a "NetTask" class, which is an extension of the AsyncTask base class.  It can run in the background, and handles the required waiting to get a result back from the web server. The data coming back from the web server has to be read (in a loop), and built up; that's what "readAll" does.  Once the data is back, we call the "netResult" method on the MainActivity class, which updates the screen -- note that this is done by calling "runOnUiThread".

The Networker class in the iOS version, and the NetTask class for Android, are code that I cobbled together from a variety of sources, trying to make something that was a little bit cleaner, and a little bit more consistent.  This is by no means the "only way to do it" -- just the way I knocked it together here.  There are a lot of packages that will wrap the HTTP interface; trying to keep it relatively clean, simple, and comprehensible.

Once you can upload and download numbers....  pretty much anything is do-able!
