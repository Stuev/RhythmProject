// 2017 Computational Aesthetics -- Project 1: Melody fill-in 
// Written by Jarek Rossignac on July 14, 2017

import processing.pdf.*;    // to save screen shots as PDFs
import ddf.minim.*;         // to play sounds (install library)
Minim minim;
AudioPlayer sound1;
AudioPlayer sound2;
AudioPlayer sound3;
AudioPlayer sound4;
AudioPlayer sound5;
AudioPlayer testsound;
int pnote=0, note=0;
int tuneLength = 8;  // in seconds (one bar per second)
int framesPerSecond=20; // =24; //

int d=2; // number of frames between slots
boolean playing=false, recording=false;
boolean showStaff=false;
PImage author1, author2; // picture of author's face, should be files data/author1.jpg and data/author2.jpg in the sketch folder

TUNE T = new TUNE();

void setup() 
  { 
  size(1500,900,P2D); 
  frameRate(framesPerSecond);
  smooth();
  minim = new Minim(this);
  sound1 = minim.loadFile("Drums/Selected/00.mp3");
  sound2 = minim.loadFile("Drums/Selected/01.mp3");
  sound3 = minim.loadFile("Drums/Selected/02.mp3");
  sound4 = minim.loadFile("Drums/Selected/03.mp3");
  sound5 = minim.loadFile("Drums/Selected/04.mp3");
  T.reset();  //  T.create();
  loadTune(folder+fileName);
  T.printNotes();
  author1 = loadImage("data/author1.jpg");  // load image from file author1.jpg in folder data *** replace that file with your pic of your own face
  author2 = loadImage("data/author2.jpg");  // load image from file author2.jpg in folder data *** replace that file with your pic of your own face
  }
  
void draw() 
  {
  background(255);
  if(snapPic) beginRecord(PDF, "data/PICTURES/P"+nf(pictureCounter++,3)+".pdf"); 
  fill(0); 
  scribeHeader("Rossignac's 2017 Computational Aesthetics course at Georgia Tech -- Project 1: Rhythm fill-in", 0);
  //scribeHeaderRight("Team: Jarek Rossignac & Jarek Rossignac");
  //image(author1, width-author1.width/2-20,25,author1.width/2,author1.height/2); // show pictures of the team members: file data/author1.jpg
  //image(author2, width-author1.width/2-20-author2.width/2-20,25,author2.width/2,author2.height/2); 
  T.showSheet();
  if(snapPic) {endRecord(); snapPic=false;}
  T.continueTune(); // if playing, continues
  fill(0); 
  scribeFooter("SAVE TO:  T=clipboard, S= file (\""+fileName+"\"). LOAD FROM: C=clipboard, L=from file (\""+fileName+"\"). SET FILENAME FROM: F=clipboard. DRAW: \'=staff. SNAP: ~=picture",1);
  scribeFooter("RECORDING: s=start, f=finish, c=continue, notes: 1...= and q...\'.  PLAY: z=start, x=stop. ERASE: :=all, ;=middle. CHANGE ,=change, .=middle, /=middle (students)",0);
  }
  