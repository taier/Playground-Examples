## Concurrency
This example demonstrates how to perform multiple numbers of tasks on the background thread, using concurrency (multithreading) and on the finish of all tasks notify UI.
That could be used on different occasions, for example when you need to upload multiple photos to the server, and when the upload is done notify the user about that.
Since devices can have multiple amounts of threads, we could take advantage of that to speed up the process.