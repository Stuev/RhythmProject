// Class for a short melody. Supports several visualization, replay, animaiton, mouse or keyboard editing
// Written by Jarek Rossignac on July 14, 2017

class TUNE
  {
  int n=8*8*5; // number of slots for notes or silences
  boolean [][] slot = new boolean [n][5]; // notes or silence (if ==-1)
  int s=0; // current slot number for playing
  int f=0; // current frame number since start of tune
  float lm=40, tm=150; // left & top margins
  
  // ********************************************************* CREATION
  TUNE() {reset();}
  void reset() {for(int i=0; i<n; i++) {for(int j=0; j<5; j++){slot[i][j]=false;}}}
  void resetMiddle() {for(int i=8*8; i<n-8*8; i++) {for(int j=0; j<5; j++){slot[i][j]=false;}}}
  void create() {for(int i=0; i<n; i++)  {for(int j=0; j<5; j++){slot[i][j]=(int(random(2))==0);}}}
  void makeRandom() 
    {
    for(int k=0; k<5; k++)
      {
      for(int i=k*8*8; i<k*8*8+8*8/4; i++) 
        {
        for(int j=0; j<5; j++)
          {
          if(int(random(8))==0) slot[i][j]=true;
          else  slot[i][j]=false;
          }
        }
      fillFourBars(k);
      }
    }
    
  void fillFourBars(int mx, int my)
  {
    float w = (width-2*lm) / (n/5), h = (height - 2*tm) / 25;
    int x = int((mx-lm)/w);        // slot
    if(x<0) x=0; if(x>(n/5)-1) x=(n/5)-1;  // check that valid slot
    int y = int((my-tm)/h); // note
    if(y<0) y=0; if(y>24) y=24; // check that valid note
    
    fillFourBars(y/5);
  }
    
  void fillFourBars(int row)
  {
    for(int i=row*8*8+8*8/4; i<(row+1)*8*8; i++)
      {
      for(int j=0; j<5; j++)
        {
        slot[i][j] = slot[i - 8*8/4][j];
        }
      }
  }
    
  void fillIn()//Given AAAA and BBBB. Fill In AAAABBBBAABBAAAABBBB
  {
    for(int i=8*8; i<n-8*8; i++)
      {
      for(int j=0; j<5; j++)
        {
        if(i<8*8*2)
          {slot[i][j] = slot[i + 8*8*3][j];}
        else if(i<8*8*3)
          {
          if(i<8*8*2.5)
            {slot[i][j] = slot[i - 8*8*2][j];}
          else
            {slot[i][j] = slot[i + 8*8*2][j];}
          }
        else if(i<8*8*4)
          {slot[i][j] = slot[i - 8*8*3][j];}
        }
      }
  }
    
  void fillInRandom() 
    {
      for(int i=8*8; i<n-8*8; i++) 
        {
        for(int j=0; j<5; j++)
          {
          if(int(random(2))==0) slot[i][j]=false;
          else  slot[i][j]=true;
          }
        }
    }

  //*********** REPLACE THIS METHOD BELOW WITH STUDENTS' FILL-IN HEURISTIC ***** 
  void myFillIn() 
    {
      print("generating rhythm... Please be patient." + "\n");
      byte[] r = new byte[8*8*3];
      for ( int i = 0; i < r.length; i++)
      {
        r[i] = 127;
      }
      //Rhythm rhythm = new Rhythm(r);
      //print("Hey");

      
      RhythmGenerator a = new RhythmGenerator();
      boolean[][] start = Arrays.copyOfRange(slot, 0, 8*8);
      boolean[][] end = Arrays.copyOfRange(slot, 8*8*4, 8*8*5);

      Rhythm rhythm = a.generateRhythm(new Profile(start, end));
      
      boolean[][] b = rhythm.getRhythm();
      for (int i = 8*8; i < 8*8*4; i++)
      {
        slot[i] = b[i - 8*8];
      }
      
    }

  // ********************************************************* EDITING WITH KEYS
  void startRecording(){s=0; recording=true; reset();}
  void recordNote(boolean myNote1, boolean myNote2, boolean myNote3, boolean myNote4, boolean myNote5) {if(recording && s<n) slot[s++]=new boolean[]{myNote1, myNote2, myNote3, myNote4, myNote5};}
  void resumeRecording() {recording=true;}
  void endRecording() {recording=false;}


  // ********************************************************* EDITING WITH MOUSE
  void deleteNote(int when, int what) {slot[when][what]=false;}
  void addNote(int when, int note) {if(0<=note && note<5 && 0<=when && when<=n ) slot[when][note]=true;}
  void toggleSlot(int mx, int my) // BASED ON MOUSE LOCATIONS
    {
    float w = (width-2*lm) / (n/5), h = (height - 2*tm) / 25;
    int x = int((mx-lm)/w);        // slot
    if(x<0) x=0; if(x>(n/5)-1) x=(n/5)-1;  // check that valid slot
    int y = int((my-tm)/h); // note
    if(y<0) y=0; if(y>24) y=24; // check that valid note
    int i = (y/5*n/5)+x;
    int j = 4-y%5;
    if(slot[i][j] == true) //If note present, remove it
      slot[i][j] = false;
    else  //Else add it
      {
      slot[i][j] = true;
      playNote(j);
      }
    }


  // ********************************************************* PLAYING
  void startTune() {s=-1; f=0; playing=true;}
  
  void startTune(int mx, int my) 
    {
    float w = (width-2*lm) / (n/5), h = (height - 2*tm) / 25;
    int x = int((mx-lm)/w);        // slot
    if(x<0) x=0; if(x>(n/5)-1) x=(n/5)-1;  // check that valid slot
    int y = int((my-tm)/h); // note
    if(y<0) y=0; if(y>24) y=24; // check that valid note
    int i = (y/5*n/5)+x;
    //int j = 4-y%5;
    s=i-1;
    f=(i+1)*d; 
    playing=true;
    }
    
  void continueTune() 
    {
    float w = (width-2*lm) / (n/5), h = (height - 2*tm) / 25;
    if(playing) 
      {
      if(f%d==0) 
        {
        s++;            // advance slot counter
        playNotes(slot[s]);
        } 
      float barH = 5;
      for(int j=0; j<5; j++)
        {
        if(slot[s][j]==true) 
        {
        stroke(0); strokeWeight(3); noFill();
        ellipse(lm+w*(s%64+0.5),(tm+((s/64)*barH+(4-j)+0.5)*h),h,h); 
        }
        }
      stroke(100,100,255); strokeWeight(2); line(lm+w*((f/d)%64),tm+(((s/64)+1)*barH)*h,lm+w*((f/d)%64),tm+((s/64)*barH)*h);//TODO ADJUST THE HEIGHT
      text("PLAYING (f="+nf(f,2,0)+")",10,45);
      f++; // advance frame counter
      if(s>=n-1) playing=false;  
     }
    else {fill(0); text("STOPPED",10,70);}
    }; 

  void play(int note) {pnote=note; playAndShowNote(note); }
  
   // ********************************************************* DRAWING
  void showSheet() 
    {
    float w = (width-2*lm) / (n/5), h = (height - 2*tm) / 25;
    stroke(50,50,50); strokeWeight(1);
    fill(0); 
    char drum[] = new char[] {'k', 's', 't', 'h', 'c'};
    for(int y=0; y<=24; y++) //Write note names on left side of sheet
      {
      String N = nf(4-y/5,2,0);
      char L = drum[y%5];
      text(N+L,5,height-(tm+y*h+8)); 
      }
    noFill();
      for(int y=0; y<=24; y++) 
        {
        //if(y%12==2 || y%12==4 || y%12==7 || y%12==9 || y%12==11 ) fill(210,215,225);
        if(y<5)
          fill(250,250,120);
        else if(y<10)
          fill(250,250,170);
        else if(y<15)
          fill(250,250,170);
        else if(y<20)
          fill(250,250,170);
        else if(y<25)
          fill(250,250,120);
        rect(lm,height-(tm+(y+1)*h),width-2*lm,h); // horizontal bars
        }  
         
    stroke(50,50,50); strokeWeight(1);
    for(int x=0; x<=n/5; x++) line(lm+w*x,height-tm,lm+w*x,tm); // draw vertical lines
    for(int y=0; y<=25; y++) line(lm,height-(tm+y*h),width-lm,height-(tm+y*h)); // draw horizontal lines
    strokeWeight(3); 
    for(int y=0; y<=25; y++) if(y%5==0) line(lm,height-(tm+y*h),width-lm,height-(tm+y*h)); // draw horizontal octave lines
    for(int x=0; x<=n/5; x++) if(x%16==0) line(lm+w*x,height-tm,lm+w*x,tm); // draw vertical bar lines
    
    stroke(200,255,200); strokeWeight(1); // draw the notes as disks
    for(int i=0; i<n; i++)
      {
      for(int j=0; j<5; j++)
        {
        if(i<64 ||i>=4*64) fill(250,0,0); else fill(0,0,250);
        if(slot[i][j]==true)
          {
            ellipse(lm+w*(i%64+0.5),(tm+((i/64)*5+(4-j)+0.5)*h),h,h);
          }
        }
      }
    }
    
   // ********************************************************* CONVERT TO AND FROM STRING
  void printNotes() {println("TUNE:"); for(int i=0; i<n; i++) {if(i%64 == 0) println(); for(int j=0; j<5; j++) {print(((slot[i][j]) ? "+" : "-"));} println();}}

  String convertToString() 
    {
    String S = "";
    for(int i=0; i<n; i++)
      {
      for(int j=0; j<5; j++)
        {
        if(slot[i][j])
          {
          S+= "+";
          }
        else
          {
          S+= "-";
          }
        }
      }
    return S;
    }
    
  void ConstructFromString(String S) 
    {
    for(int i=0, j=0; i<S.length(); i++)
      {
      if(i>(n-1)*5)
        {
        break;
        }
      slot[i/5][j] = (S.charAt(i) == '+') ? true : false;
      j = (j+1)%5;
      }
    }
 
  } // END OF CLASS
  
char noteName(int p) // note name from pitch
  {
  if(p%12==1) return 'C';
  if(p%12==3) return 'D';
  if(p%12==5) return 'E';
  if(p%12==6) return 'F';
  if(p%12==8) return 'G';
  if(p%12==10) return 'A';
  if(p%12==0) return 'B';
   return ' ';
  }

// row colors In Staff (altered by '#' and 'b')  
char [] rc = {'w','g','y','w','y','b','w','y','b','y','w','y','b','w','y','b','y','w','b','y','w','y','g','y','w','g'};

int tonic = 1;
int sharpCount=0;

void addSharp() 
  {
  for(int i=0; i<23; i++) if(i%12 == (tonic+5)%12) { char c = rc[i]; rc[i]=rc[i+1]; rc[i+1]=c;} 
  rc[24]=rc[0]; rc[25]=rc[1];
  tonic = (tonic+7)%12;
  sharpCount++;
  }
  
void resetSharp() 
  {
  char [] orc = {'w','g','y','w','y','b','w','y','b','y','w','y','b','w','y','b','y','w','b','y','w','y','g','y','w','g'}; 
  for(int i=0; i<26; i++) rc[i]=orc[i];
  sharpCount=0;
  tonic = 1;
  }  
  
  
// ********************************************************* PLAY NOTES WHEN KEYS PRESSED (NOT ON SCORE)
void playAndShowNote(int thisNote)
  {
  pnote=note; 
  note=thisNote;
  playNote(thisNote);
  }
  
void playNotes(boolean[] notes)
{
  if(notes[0])
    {
    sound1.play();
    sound1.rewind();
    }
  if(notes[1])
    {
    sound2.play();
    sound2.rewind();
    }
  if(notes[2])
    {
    sound3.play();
    sound3.rewind();
    }
  if(notes[3])
    {
    sound4.play();
    sound4.rewind();
    }
  if(notes[4])
    {
    sound5.play();
    sound5.rewind();
    }
}


void playNote(int thisNote)
  {
  String soundFile = "Drums/Selected/"+nf(thisNote,2,0)+".mp3";
  testsound = minim.loadFile(soundFile);
  testsound.play();
  testsound.rewind();
  }