import oscP5.*;
import netP5.*;

//http://lembra.wordpress.com/2011/08/02/sum-mean-median-and-standard-deviation-using-lists-in-java/

import SimpleOpenNI.*;
import java.util.*;

SimpleOpenNI  context;

OscP5 oscP5;
NetAddress sendAddress;

List<Integer> userdepth = new ArrayList<Integer>();


 int sum (List<Integer> a){
        if (a.size() > 0) {
            int sum = 0;
 
            for (Integer i : a) {
                sum += i;
            }
            return sum;
        }
        return 0;
}
float mean (List<Integer> a){
        int sum = sum(a);
        float mean = 0;
        mean = sum / (a.size() * 1.0);
        return mean;
}

        
void setup()
{
   context = new SimpleOpenNI(this);
   
   context.enableDepth();
   context.enableScene();
   context.enableRGB();
   context.setMirror(true);
   context.setDepthImageColorMode(1); // for RGB
   size(context.depthWidth(), context.depthHeight()); 
   
   background(0,0,0);
   smooth();
   
   oscP5 = new OscP5(this,12000);
   sendAddress = new NetAddress("127.0.0.1",32000);
}
void draw()
{
   int[] dmap = context.depthMap();
   int[] smap = context.sceneMap();
   //if the pixel is a member of a body, the find its depth
   // and add it to a list
   for(int i=0; i< dmap.length; i++){
     if(smap[i] > 0){
       userdepth.add(dmap[i]);
     }
   }
   //calculate the mean of the depth
   float averageDepth = mean(userdepth);
   if( averageDepth > 0){
     println(averageDepth);
   }else{
      averageDepth = 0.0;
   }
   
   OscMessage avgdepth = new OscMessage("/depth");
   avgdepth.add(averageDepth);
   oscP5.send(avgdepth, sendAddress);
   
   context.update();
   image(context.sceneImage(),0,0);
   //image(context.depthImage(),0,0);
   userdepth.clear();
}
