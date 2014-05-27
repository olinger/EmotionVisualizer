import controlP5.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import java.util.*;
DropdownList d1,d2;
ListBox l1,l2;
PlayFrame Play;
loadFrame load;
ControlP5 cp5;
ControlP5 c2;
int Subject=5;
int Speed=1;
int Size=1;
String [] lines;
String [][] csv;
float [][] subjectData;
int selectSubject,selectX,selectY;
int s=15;
int xsize,ysize;  
float posScale=1000000;
int dly;
int windowX=1000;
int windowY=800;
int buffer=100;
int maxSubject, minSubject, subjectRange;
float maxX, maxY, minX, minY, xInc, yInc;
int numComponents;
int secondWindowOffset=15;
String fileSelected = new String();
String filename;
String filepath;
String path;
boolean isStopped = false;
boolean isPause = false;
String unpauseCheck = new String();
String stopCheck = new String();

void setup()
{
  path=sketchPath("");
  load = new loadFrame();
  
  //initialize controller
  cp5 = new ControlP5(this);

  //wait until file has been selected
  synchronized(fileSelected) 
  {
      try {
          // Calling wait() will block this thread until another thread
          // calls notify() on the object.
          fileSelected.wait();
      } 
      catch (InterruptedException e) {
      }
  }
          
  lines=loadStrings(filename);
  println(fileSelected);
  
  compileCSV();
  size(300,300);
  createUI();
  
  //default selections
  selectSubject=5;
  selectX=1;
  selectY=1;
  
}

//file selection window
public class loadFrame extends Frame
{
  LoadApp app;
  public loadFrame()
  {
    setBounds(0,0,250,150);
    app = new LoadApp();
    add(app);
    app.init();
    show();
  }
  
  public LoadApp getApp()
  {
    return app;
  }
}

public class LoadApp extends PApplet
{
  boolean entered=false;
  boolean invalid=false;
  
  public LoadApp()
  {
  }
  
  void setup()
  {
    c2 = new ControlP5(this);
    PFont font = createFont("arial",12);
    
    c2.addTextfield("Input")
      .setSize(150,25)
      .setPosition(42,30)
      .setFont(font)
      .setText("example.csv")
      .setFocus(true)
      .getCaptionLabel().hide()
      ;
      
    c2.addButton("Load")
      .setSize(60,20)
      .setPosition(42,75)
      .setValue(0)
      .getCaptionLabel()
      .set("Load File")
      .toUpperCase(false)
      .setFont(font)
      ;
  }
  
  boolean fileExists(String name)
  {
    String f[] =loadStrings(name);
    if(f==null)
      return false;
    return true;
  }
  
  void displayInvalidText()
  {
    textSize(12);
    fill(255,0,0);
    text("Not a valid file",42,70);
  }
  
  void draw()
  {
    background(150,180,200);
    if(invalid)
      displayInvalidText();
    fill(255);
    textSize(15);
    text("Enter file name:",42,25);
    if(c2.get(Button.class,"Load").isPressed())
    {
      entered=true;
    }
    if(entered) //button was pressed
    {
      noLoop();
      invalid=false;
      filename = c2.get(Textfield.class,"Input").getText();
      filepath=path+filename;
      if(fileExists(filepath)) //file name is valid
      {
        synchronized(fileSelected)
        {
          fileSelected.notify();
        }
        load.setVisible(false);
        noLoop();
      }
      else //invalid file name
      {
        entered=false;
        invalid=true;
        loop();
      }
    }
   // noLoop();
  /*  if(c2.get(Button.class,"Load").Value==1)
    {
   //   loop();
      println("looping");
      c2.get(Button.class,"Load").isPressed();
    }*/
    //load.setVisible(false);
    //text(c2.get(Textfield.class,"input").getText(), 360,130);
  }
}

void createUI()
{
  //UI positioning variables
  int d1x,d1y,d2x,d2y,subjectx,subjecty,playx,playy,pausex,pausey,stopx,stopy,modex,modey,speedx,speedy,sizex,sizey;
  d1x=34; d1y=70;
  d2x=164; d2y=70;
  subjectx=34; subjecty=175;
  playx=145; playy=255;
  pausex=195; pausey=255;
  stopx=245; stopy=255;
  modex=34; modey=265;
  speedx=185; speedy=215;
  sizex=34; sizey=215;
  
  //set font
  cp5.setControlFont(new ControlFont(createFont("Arial", 13), 13));
  
  //play button
  cp5.addButton("Play")
    .setBroadcast(false)
    .setSize(45,30)
    .setPosition(playx,playy)
    .setBroadcast(true)
    ;
    
  cp5.getController("Play")
    .getCaptionLabel()
    .toUpperCase(false)
    ;
    
  //pause button
  cp5.addButton("Pause")
    .setBroadcast(false)
    .setSize(45,30)
    .setPosition(pausex,pausey)
    .setBroadcast(true)
    ;
    
  cp5.getController("Pause")
    .getCaptionLabel()
    .toUpperCase(false)
    ;
    
  //stop button
  cp5.addButton("Stop")
    .setBroadcast(false)
    .setSize(45,30)
    .setPosition(stopx,stopy)
    .setBroadcast(true)
    ;
    
  cp5.getController("Stop")
    .getCaptionLabel()
    .toUpperCase(false)
    ;
    
  //2D and 3D mode radio buttons
  cp5.addRadioButton("Mode")
    .setPosition(modex,modey)
    .setSize(20,20)
    .addItem("2D",1)
    .addItem("3D",2)
    .setItemsPerRow(2)
    .setSpacingColumn(30)
  ;

  //dropdown list for X source  
  d1 = cp5.addDropdownList("xlist")
          .setPosition(d1x, d1y)
          .setBackgroundColor(color(190))
          .setItemHeight(20)
          .setBarHeight(23)
          .setId(1)
          .toUpperCase(false)
          ;
  d1.captionLabel().set("select one");
  d1.captionLabel().style().marginTop=3;
  d1.captionLabel().style().marginLeft=3;
  d1.valueLabel().style().marginTop=3;
  for(int i=0;i<numComponents;i++)
  {
    d1.addItem("Component " + (i+1), i+2);
  }
  
  //dropdown list for Y source  
  d2 = cp5.addDropdownList("ylist")
          .setPosition(d2x, d2y)
          .setBackgroundColor(color(190))
          .setItemHeight(20)
          .setBarHeight(23)
          .setId(2)
          .toUpperCase(false)
          ;
  d2.captionLabel().set("select one");
  d2.captionLabel().style().marginTop=3;
  d2.captionLabel().style().marginLeft=3;
  d2.valueLabel().style().marginTop=3;
  for(int i=0;i<numComponents;i++)
  {
    d2.addItem("Component " + (i+1), i+2);
  }
  d2.scroll(0);
  
  //Subject slider
  cp5.addSlider("Subject")
    .setPosition(subjectx,subjecty)
    .setSize(232,15)
    .setRange(minSubject,maxSubject)
    .setNumberOfTickMarks(subjectRange)
    .showTickMarks(false)
    ;
    
    cp5.getController("Subject")
    .getCaptionLabel()
    .toUpperCase(false)
    .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE)
    .setPaddingX(0)
    ;  
    
  //Speed slider
  cp5.addSlider("Speed")
    .setPosition(speedx,speedy)
    .setSize(70,15)
    .setRange(1,3)
    .setNumberOfTickMarks(3)
    ;
    
    cp5.getController("Speed")
    .getCaptionLabel()
    .toUpperCase(false)
    .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE)
    .setPaddingX(0)
    ;
    
  //Size slider
  cp5.addSlider("Size")
    .setPosition(sizex,sizey)
    .setSize(70,15)
    .setRange(1,5)
    .setNumberOfTickMarks(5)
    ;
    
    cp5.getController("Size")
    .getCaptionLabel()
    .toUpperCase(false)
    .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE)
    .setPaddingX(0)
    ;
}

void controlEvent(ControlEvent theEvent) 
{
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());    
    if(theEvent.getGroup().getId()==1)
    {
      selectX=(int)theEvent.getGroup().getValue();
    }
    if(theEvent.getGroup().getId()==2)
    {
      selectY=(int)theEvent.getGroup().getValue();
    }
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

public void Play(int theValue)
{
  if(!isPause)
  {
    isStopped=false;
    loadSelected();
    Play = new PlayFrame();
  }
  else
  {
    synchronized(unpauseCheck)
    {
      unpauseCheck.notify();
      isPause=false;
    }
  }
}

public void Pause(int theValue)
{
  isPause=true;
}

public void Stop(int theValue)
{
  isStopped=true;
  if(isPause)
  {
    synchronized(unpauseCheck)
    {
      unpauseCheck.notify();
      isPause=false;
    }
  }
  synchronized(stopCheck)
  {
    stopCheck.notify();
  }
}

public void Subject(int theValue)
{
  selectSubject=theValue;
}

public void Speed(int theValue)
{
  if(theValue==1)
    dly=250;
  if(theValue==2)
    dly=100;
  if(theValue==3)
    dly=0;
}

public void Size(int theValue)
{
  s=theValue*10;
}

void UIText()
{
  textSize(11);
  text("file loaded: " + filename,5,10);
  textSize(15);
  text("x component",35,37);
  text("y component",165,37);
  text("mode",35,258);
}

//load the csv into a 2d array
public void compileCSV()
{
    maxSubject=1;
    maxX=0;
    maxY=0;
    //read csv file
    //calculate max width of csv file
    int csvLength=0;
    int substrlen=0;
    int csvWidth=0;
    for (int i=0; i < lines.length; i++) 
    {
        csvLength++;
        String [] chars=split(lines[i],',');
        if (chars.length>csvWidth)
        {
          csvWidth=chars.length;
        }
    }
    println(csvLength+ " , " + csvWidth);
    //create csv array based on # of rows and columns in csv file
    csv = new String [csvLength][csvWidth];
  
    //parse values into 2d array
    int i2=0;
    for (int i=0; i < lines.length; i++) 
    {
      String [] temp = new String [lines.length];
      temp= split(lines[i], ',');
      for (int j=0; j < temp.length; j++)
      {
        csv[i2][j]=temp[j];
      }
      i2++;
    }
    
    //get the min and max subject from the data for the size of the subject slider
    minSubject=int(csv[0][0]);
    for(int i=0;i<csvLength;i++)
      {
        if(int(csv[i][0])>=maxSubject)
        {
          maxSubject=int(csv[i][0]);
        }
        if(int(csv[i][0])<=minSubject)
        {
          minSubject=int(csv[i][0]);
        }
    }
    subjectRange=maxSubject-minSubject+1;
    println("max subject : " + maxSubject);
    println("min subject : " + minSubject);
    println("subject range : " + subjectRange);
    
    //number of components in the data for the component dropdown
    numComponents = csvWidth-3;
}

//creates a 2d array (subjectData) from the csv data with only the selected subject's data
public void loadSelected()
{
    int csvLength=0;
    for(int i=0;i<csv.length;i++)
    {
      if(int(csv[i][0])==selectSubject)
      {
        csvLength++;
      }
    }
    int i2=0;
    subjectData = new float [csvLength][4];
    for (int i=0; i < csv.length; i++) 
    {
      if(int(csv[i][0])==selectSubject)
      {
        String [] temp = csv[i];
        for (int j=0; j < temp.length; j++)
        {
            if(j<2)
            {
              subjectData[i2][j]=float(temp[j]);
            }
            else if(j==selectX)
            {
              subjectData[i2][2]=float(temp[j])*posScale;
            }
            else if(j==selectY)
            { 
              subjectData[i2][3]=float(temp[j])*posScale;
            }
        }
        i2++;
      }
    }

    maxX=0;
    maxY=0;
    minX=0;
    minY=0;
    for(int i=0;i<subjectData.length;i++)
    {

      if(subjectData[i][2]>maxX)
      {
        maxX = subjectData[i][2];
      }
      if(subjectData[i][2]<minX)
      {
        minX=subjectData[i][2];
      }
      if(subjectData[i][3]>maxY)
      {
        maxY=subjectData[i][3];
      }
      if(subjectData[i][3]<minY)
      {
        minY=subjectData[i][3];
      }
    }
    
    //Scale up to positive range
    maxX+=abs(minX);
    maxY+=abs(minY);
    for(int i=0;i<subjectData.length;i++)
    { 
      //scale up to positive if necessary
      subjectData[i][2]+=abs(minX);
      subjectData[i][3]+=abs(minY);
    }
    
    println("maxX " + maxX);
    println("minX " + minX);
    println("maxY " + maxY);
    println("minY " + minY);
    
    PrintWriter output = createWriter("debug.txt");
    for(int i=0;i<subjectData.length;i++)
    {        
      output.print(subjectData[i][2] + " , " + subjectData[i][3]);
      output.println();
    }
    output.close();

}

void draw()
{
  background(150,180,200);
  UIText();
}

//second window
public class PlayFrame extends Frame
{
  PlayApp app;
  public PlayFrame()
  {
    setBounds(0,0,windowX,windowY);
    app=new PlayApp();
    add(app);
    app.init();
    show();
  }
  
  public PlayApp getApp()
  {
    return app;
  }
}

public class PlayApp extends PApplet
{
  int cIndex; //circle index
  Circle[] circles;
  float circleR;
  Boundary innerBox;
  int innerBoundx=950;
  int innerBoundy=680;
  int off=secondWindowOffset;
  float posScaleX=1;
  float posScaleY=1;
  Map<Integer,Integer> color_map;
  Map<Integer,String> emotion_map;
  
  public PlayApp()
  {
  }
  
  public void setup()
  {  
    circles = new Circle[subjectData.length];
    emotion_map = new HashMap<Integer, String>();
    Map<Integer,Integer> occurence_map = new HashMap<Integer,Integer>();
    color_map = fillOccurenceMap(occurence_map);
    
    fillEmotionMap(emotion_map);
    colorMode(HSB,color_map.size(),100,100);
    
    setBoundingBox();
    setPosScale();
    
    for(cIndex=0;cIndex<subjectData.length;cIndex++)
    {
      circleR=s;
      int emotion=int(subjectData[cIndex][1]);
      
      //raw X and Y from csv file
      float xRaw = subjectData[cIndex][2];
      float yRaw = subjectData[cIndex][3];
      
      //adjusted x and y to fit within bounds of the drawing space
      float xAdjust = xRaw * posScaleX + off + circleR;
      float yAdjust = yRaw * posScaleY + off + circleR;
      
      //cast to ints
      int x = (int)xAdjust;
      int y = (int)yAdjust;
      
      color circleCol=color(color_map.get((Integer)emotion),50,75);
      String circleName=emotion_map.get(emotion);
      Circle circle = new Circle(x,y,circleR,circleCol,circleName,'a');
      circles[cIndex]=circle;
    }
    cIndex=0;
  }
  public void setPosScale()
  {
    //scale X and Y to fit within bounds of the window
    posScaleX=(innerBoundx - s*2)/(maxX);
    posScaleY=(innerBoundy - s*2)/(maxY);
  }
  
  public void setBoundingBox()
  {
    innerBox=new Boundary(off,off+innerBoundx,off,off+innerBoundy);
  }
  
  public void draw()
  {
    colorMode(RGB,255,255,255);
    background(200);
    drawBoundingBox();
    drawKey();
    
    for(int j=0;j<cIndex;j++)
    {
        circles[j].add();
    }
    color col=circles[cIndex].col;
    fill(col);
    
    if(cIndex<circles.length-1)
    {
      ellipse(circles[cIndex].x,circles[cIndex].y,circles[cIndex].r*2,circles[cIndex].r*2);
    }
    cIndex++;
    
    if(cIndex==circles.length)
    {       
      synchronized(stopCheck) 
      {
          try {
              // Calling wait() will block this thread until another thread
              // calls notify() on the object.
              stopCheck.wait();
          } 
          catch (InterruptedException e) {
          }
      }
      noLoop();
      if(isStopped)
      {
        Play.setVisible(false);
      }
    }
    
    if(isPause)
    {
       synchronized(unpauseCheck) 
      {
          try {
              // Calling wait() will block this thread until another thread
              // calls notify() on the object.
              unpauseCheck.wait();
          } 
          catch (InterruptedException e) {
          }
      }
    }
    
    if(isStopped)
    {
      noLoop();
      Play.setVisible(false);
    }
    
    delay(dly);
  }
  
  /* 
  This method draws the rectangle that will contain the movie and sets the ineerBox boundary object.
  If you want to change the size of this you will have to reposition it. I reccomend not changing it.
  If you do change it, innerBoundx and innerBoundy are global variables within the PlayApp that control 
  the size of the box.
  */ 
  public void drawBoundingBox()
  {
    fill(230);
    rect(off,off,innerBoundx,innerBoundy); //center this rect
    
    textSize(12);
    fill(0);
    text("Source: " + filename + "      Subject: " + selectSubject + "      X: Component " + (selectX-1) + "      Y: Component " + (selectY-1) ,15,12);
  }
  
  //color to emotion key drawn here. resizes based on size of color map
  public void drawKey()
  {
    fill(230);
    int keyBoundX, keyBoundY;
    keyBoundY=40;
    keyBoundX=color_map.size()*150;
    Boundary keyBound = new Boundary(innerBox.xmin,keyBoundX,innerBox.ymax+15,keyBoundY);
    rect(keyBound.xmin,keyBound.ymin,keyBound.xmax,keyBound.ymax);

    colorMode(HSB,color_map.size(),100,100);
    int i=10;
    for (Integer key : color_map.keySet()) 
    {
      fill(color_map.get(key),50,75);
      rect(keyBound.xmin+i,keyBound.ymin+10,30,15);
      textSize(15);
      text(emotion_map.get(key),keyBound.xmin+i+37,keyBound.ymin+23);
      i+=150;
    }
    
    //textSize(10);
   // fill(0);
   // text("Subject " + Subject, 50,50);
  }
  
  Map<Integer,Integer> fillOccurenceMap(Map<Integer,Integer> m)
  {
    for(int i=0;i<subjectData.length;i++)
    {
      if(!m.containsKey(subjectData[i][1]))
      {
        m.put(((Integer)int(subjectData[i][1])),(Integer)1);
      }
      else
      {
        m.put((Integer)int(subjectData[i][1]),m.get((Integer)int(subjectData[i][1])));
      }
    }
    Map<Integer,Integer>color_map=new HashMap<Integer,Integer>();
    Integer c=1;
    for (Integer key : m.keySet()) 
    {
      if(!color_map.containsKey(key))
      {
        color_map.put(key,c);
        c++;
      }
    }
    return color_map;
  }
  
  void fillEmotionMap(Map<Integer,String> m)
  {
    m.put(1,"curiosity");
    m.put(2,"anxiety");
    m.put(3,"bored");
    m.put(4,"interest");
    m.put(5,"challenged");
    m.put(6,"suspense");
    m.put(7,"happy");
    m.put(8,"hope");
    m.put(9,"frustrated");
    m.put(10,"anger");
    m.put(11,"confused");
    m.put(12,"excited");
    m.put(13,"enjoy");
    m.put(14,"dissapointed");
    m.put(15,"surprised");
    m.put(16,"relaxed");
    m.put(17,"intrigued");
    m.put(18,"annoyed");
    m.put(19,"relieved");
    m.put(20,"determined");
    m.put(21,"irritated");
    m.put(22,"neutral");
    m.put(23,"regret");
    m.put(24,"interested");
    m.put(25,"amused");
    m.put(26,"hesistant");
    m.put(27,"mad");
  }
  
  //object to hold the xminow, xmaxigh, ymaxow and ymaxigh values of a boundary box
  class Boundary 
  {
    int xmin, xmax, ymin, ymax;
    Boundary(int a, int b, int c, int d)
    {
        xmin=a;
        xmax=b;
        ymin=c;
        ymax=d;
    }
    
    float xdiff()
    {
      return xmax-xmin;
    }
    float ydiff()
    {
      return ymax-ymin;
    }
  }
  
  class Circle
  {
    int x, y;
    float r;
    color col;
    String name;
    char code;
    Circle(int x_, int y_, float r_, color c_, String n_, char cd_)
    {
      x=x_;
      y=y_;
      r=r_;
      col=c_;
      name=n_;
      code=cd_;
    }
    void xy(int x_, int y_)
    {
      x=x_;
      y=y_;
    }
    void add()
    {
      fill(col);
      ellipse(x,y,r,r);
  //    println("Radius: " + radius);
   //   println("Focus: " + focus);
    }
  }
  
}
