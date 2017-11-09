import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;
String preVal;
import cc.arduino.*;


int[] testChord={0, 4, 7};
int[][] fretBoardArray=new int[6][22];
PFont f;
void setup() {
  String portName = Serial.list()[5]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);

  f = createFont("HelveticaNeue-Light", 16, true);
  size(1280, 800);  
  makeArray();


  //for (int k = 0; k < 6; k++) {
  //  print("\n{");
  //  print(" ");
  //  for (int b = 0; b < 22; b++) {

  //    print(fretBoardArray[k][b]);
  //    System.out.print(" , ");
  //  }
  //  println("}");
  //}
  background(0);
  drawFretBoard();
  println(serialArray("0,4,7,11"));
}



void draw() {
  //drawFretBoard();
  if ( myPort.available() > 0) 
  {  // If data is available,

    val = myPort.readStringUntil('\n'); 
    // read it and store it in val
  } 
  if (val!=null) {
    clear();
    drawFretBoard();
    getNotes((serialArray(val)));
  }
}

void drawFretBoard() {

  int scaleLength=1780;
  float counter=33.333;
  for (int i=0; i<6; i++) {
    fill(0, 145, 255);    
    rect(0, 280+counter, 1280, 2);
    counter+=33.333;
  }
  for (int i=0; i<22; i++) {
    fill(255);
    rect((scaleCalc(scaleLength, i)), 313, 10, 167);
  }

  for (int i=2; i<9; i+=2) {
    fill(255);   
    textFont(f, 30);
    text(i+1, (((scaleCalc(1780, i)+(scaleCalc(1780, i+1)))/2))-5, 520);
  }
  text(12, (((scaleCalc(1780, 11)+(scaleCalc(1780, 11+1)))/2))-13, 520);

  for (int i=14; i<22; i+=2) {
    fill(255);   
    textFont(f, 30);
    text(i+1, (((scaleCalc(1780, i)+(scaleCalc(1780, i+1)))/2))-13, 520);
  }
}



float scaleCalc(float s, float f) {
  return (s-(s/(pow(2, (f/12)))));
}


void makeArray() {
  fretBoardArray[0][0]=5;
  fretBoardArray[1][0]=0;
  fretBoardArray[2][0]=8;
  fretBoardArray[3][0]=3;
  fretBoardArray[4][0]=10;
  fretBoardArray[5][0]=5;  

  for (int i=0; i<6; i++) {
    for (int j=1; j<22; j++) {

      if (fretBoardArray[i][j-1]+1>11) {
        fretBoardArray[i][j]=0;
      } else 
      fretBoardArray[i][j]=(fretBoardArray[i][j-1])+1;
    }
  }
}

void getNotes(int [] a) {
  for (int note=0; note<3; note++) {
    for (int string=0; string<6; string++) {
      for (int fret=0; fret<21; fret++) {
        if (a[note]==fretBoardArray[string][fret]) {
          drawNote(string, fret);
        }
      }
    }
  }
}

void drawNote(int s, int i) {
  float y;
  y=313.333+(33.333*s+1);
  ellipseMode(CENTER);
  ellipse(((scaleCalc(1780, i)+(scaleCalc(1780, i+1))+10)/2), y, 10, 10);
}

int[] serialArray(String s) {
  s=s.trim();
  String []temp=s.split(",");
  int [] finalArray=new int [temp.length];
  for (int i=0; i<finalArray.length; i++)
    finalArray[i]=Integer.parseInt(temp[i]);

  return finalArray;
}