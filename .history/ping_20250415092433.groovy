import java.io.*;
import java.net.*;
 
//start
long lStartTime = System.nanoTime()
 
//task
Socket soc = new Socket()
soc.connect(new InetSocketAddress("10.244.4.165", 8081), 50000);
//end
long lEndTime = System.nanoTime()
 
//time elapsed
long output = lEndTime - lStartTime
println "Elapsed time in milliseconds: " + output / 1000000