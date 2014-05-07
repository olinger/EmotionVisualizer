import controlP5.*;
import java.awt.Frame;
import java.util.*;
DropdownList d1,d2;
ListBox l1,l2;
PlayFrame Play;
ControlP5 cp5;
int Subject=5;
int Speed=1;
int Size=1;
String[] lines;
String [][] csv;
int selectSubject,selectX,selectY;
int s=15;
int xsize,ysize;  
int posScale=100000;
int maxX=0; int maxY=0;
int dly;
int windowX=1000;
int windowY=800;
int buffer=100;

//You will need to change sahara.csv to your own data file. 
// Use the full path OR put the file inside the visulizer folder
void setup()
{
  size(300,300);
  createUI();
  lines=loadStrings("sahara.csv");
  selectSubject=5;
  selectX=1;
  selectY=1;
}

void createUI()
{
  //UI positioning variables
  int d1x,d1y,d2x,d2y,subjectx,subjecty,playx,playy,modex,modey,speedx,speedy,sizex,sizey;
  d1x=34; d1y=70;
  d2x=164; d2y=70;
  subjectx=34; subjecty=175;
  playx=185; playy=255;
  modex=34; modey=265;
  speedx=185; speedy=215;
  sizex=34; sizey=215;
  //initialize controller
  cp5 = new ControlP5(this);
  
  //set font
  cp5.setControlFont(new ControlFont(createFont("Arial", 13), 13));
  
  //play button
  cp5.addButton("Play")
    .setBroadcast(false)
    .setSize(70,30)
    .setPosition(playx,playy)
    .setBroadcast(true)
    
    ;
  cp5.getController("Play")
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
  d1 = cp5.addDropdownList("Xlist")
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
  d1.addItem("Component 1",1);
  d1.addItem("Component 2",2);
  d1.addItem("Component 3",3);
  d1.addItem("Component 4",4);
  
  //dropdown list for Y source  
  d2 = cp5.addDropdownList("Ylist")
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
  d2.addItem("Component 1",1);
  d2.addItem("Component 2",2);
  d2.addItem("Component 3",3);
  d2.addItem("Component 4",4);
  d2.scroll(0);
  
  //Subject slider
  cp5.addSlider("Subject")
    .setPosition(subjectx,subjecty)
    .setSize(232,15)
    .setRange(5,42)
    .setNumberOfTickMarks(38)
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
  compileCSV();
  Play = new PlayFrame();
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
  textSize(15);
  text("x component",35,37);
  text("y component",165,37);
  text("mode",35,258);
}

public void compileCSV()
{
    //read csv file
    //calculate max width of csv file
    int csvLength=0;
    int substrlen=0;
    int csvWidth=0;
    if(selectSubject<10) substrlen=1;
    else
      substrlen=2;
    for (int i=0; i < lines.length; i++) 
    {
        if(lines[i].substring(0,substrlen).equals(Integer.toString(selectSubject)))
        {
          csvLength++;
        }
        String [] chars=split(lines[i],',');
        if (chars.length>csvWidth)
        {
          csvWidth=chars.length;
        }
    }
    //create csv array based on # of rows and columns in csv file
    csv = new String [csvLength][csvWidth];
  
    //parse values into 2d array
    int i2=0;
    for (int i=0; i < lines.length; i++) 
    {
      if(lines[i].substring(0,substrlen).equals(Integer.toString(selectSubject)))
      {
        String [] temp = new String [lines.length];
        temp= split(lines[i], ',');
        for (int j=0; j < temp.length; j++)
        {
          csv[i2][j]=temp[j];
        }
        i2++;
      }
    }
    for(int i=0;i<csv.length;i++)
    {
      int x=abs(int(float(csv[i][selectX+1])*posScale));
      int y=abs(int(float(csv[i][selectY+1])*posScale));
      if(x>maxX) maxX=x;
      if(y>maxY) maxY=y;
    }
    xsize=maxX+s;
    ysize=maxY+s;
}

void draw()
{
  background(150,180,200);
  UIText();
}


public class PlayFrame extends Frame
{
  PlayApp app;
  public PlayFrame()
  {
    //setBounds(0,0,xsize+15,ysize+38);
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
  int i;
  Circle[] circles;
  float circleR;
  Boundary innerBox;
  int innerBoundx=950;
  int innerBoundy=680;
  int off=15;
  float posScaleX=1;
  float posScaleY=1;
  Map<Integer,Integer> color_map;
  Map<Integer,String> emotion_map;
  
  public PlayApp()
  {
  }
  
  public void setup()
  {  
    //create circles
    circles = new Circle[csv.length];
    emotion_map = new HashMap<Integer, String>();
    Map<Integer,Integer> occurence_map = new HashMap<Integer,Integer>();
    color_map = fillOccurenceMap(occurence_map);
    fillEmotionMap(emotion_map);
    colorMode(HSB,color_map.size(),100,100);
    //println(color_map.size());
    //int maxX=0;
    //int maxY=0;
    setBoundingBox();
    setPosScale();
    println("x pos" + posScaleX);
    for(int i=0;i<csv.length;i++)
    {
      circleR=s;
      int emotion=int(csv[i][1]);
      int x=abs(int(float(csv[i][selectX+1])*posScale*posScaleX+off+circleR));
      int y=abs(int(float(csv[i][selectY+1])*posScale*posScaleY+off+circleR));
      //float pred=float(csv[i][6]);
      //if(pred!=2) circleR*=pred;
      if(x<=circleR+off) x=int(circleR)+off;
      if(y<=int(circleR+off)) y=int(circleR)+off;
      color circleCol=color(color_map.get((Integer)emotion),50,75);
      String circleName=emotion_map.get(emotion);
      Circle circle = new Circle(x,y,circleR,circleCol,circleName,'a');
      circles[i]=circle;
    }
    i=0;
  }
  public void setPosScale()
  {
    if(maxX>innerBox.xdiff())
    {
      posScaleX=innerBox.xdiff()/float(maxX);
    }
    if(maxY>innerBox.ydiff())
    {
      posScaleY=innerBox.ydiff()/float(maxY);
    }
  }
  
  public void setBoundingBox()
  {
    innerBox=new Boundary(off,off+innerBoundx,off,off+innerBoundy);
  }
  
  public void draw()
  {
    int xcenter=(windowX)/2;
    int ycenter=(windowY)/2;
    colorMode(RGB,255,255,255);
    background(200);
    drawBoundingBox();
    //add color key bottom (left?) of rectangle
    drawKey();
    //fix circles to stay within bounds of rectangle
    //print current emotion data in bottom right? (maybe)
    for(int j=0;j<i;j++)
    {
        circles[j].add();
    }
    i++;
    if(i==circles.length)
      noLoop();
    //delay(dly);
    //println(innerBox.xl);
    
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
    int off=15;
    rect(off,off,innerBoundx,innerBoundy); //center this rect
  }
  
  //color to emotion key drawn here.
  public void drawKey()
  {
    Boundary keyBound = new Boundary(innerBox.xl,600,innerBox.yh+15,40);
    rect(keyBound.xl,keyBound.yl,keyBound.xh,keyBound.yh);

    colorMode(HSB,color_map.size(),100,100);
    int i=10;
    for (Integer key : color_map.keySet()) 
    {
      fill(color_map.get(key),50,75);
      rect(keyBound.xl+i,keyBound.yl+10,30,15);
      println(key);
      //println(color_map.get(key));
      
      textSize(15);
      text(emotion_map.get(key),keyBound.xl+i+37,keyBound.yl+23);
      i+=150;
    }
  }
  
  Map<Integer,Integer> fillOccurenceMap(Map<Integer,Integer> m)
  {
    for(int i=0;i<csv.length;i++)
    {
      if(!m.containsKey(csv[i][1]))
      {
        m.put(((Integer)int(csv[i][1])),(Integer)1);
      }
      else
      {
        m.put((Integer)int(csv[i][1]),m.get((Integer)int(csv[i][1])));
      }
    }
    Map<Integer,Integer>color_map=new HashMap<Integer,Integer>();
    Integer c=1;
    for (Integer key : m.keySet()) 
    {
      if(!color_map.containsKey(key))
      {
        color_map.put(key,c);
        println("key: ",key);
        println("c: ", c);
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
  
  //object to hold the xlow, xhigh, ylow and yhigh values of a boundary box
  class Boundary 
  {
    int xl, xh, yl, yh;
    Boundary(int a, int b, int c, int d)
    {
        xl=a;
        xh=b;
        yl=c;
        yh=d;
    }
    
    float xdiff()
    {
      return xh-xl;
    }
    float ydiff()
    {
      return yh-yl;
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
     // println(name);
    }
  }
  
}
