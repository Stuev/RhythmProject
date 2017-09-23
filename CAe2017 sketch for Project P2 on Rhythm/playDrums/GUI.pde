 // ********************************************************* GUI
 
void keyPressed()
  {
  if(key=='Z') T.startTune(mouseX, mouseY);
  if(key=='z') T.startTune();
  if(key=='x') playing=false;
  if(key==',') {T.fillFourBars(mouseX, mouseY);} // copy first bar to next three bars for four bars that mouse is on vertically.
  if(key=='<') {T.makeRandom(); T.startTune();} // set center to random
  if(key=='.') {T.fillIn(); T.startTune();} // set center to random
  if(key=='/') {T.myFillIn(); T.startTune();} // use student's method to set center to random
  if(key==':') T.reset();
  if(key==';') T.resetMiddle();
  if(key=='?') T.printNotes();
  if(key=='S') saveTune(folder+fileName);
  if(key=='L') loadTune(folder+fileName);
  if(key=='F') fileName=getClipboard();
  if(key=='T') {String S=T.convertToString(); println("Saved to clipboard: "+S); setClipboard(S);}
  if(key=='C') {String S=getClipboard(); println("Loaded from clipboard: "+S); T.ConstructFromString(S);}
  if(key=='~') snapPic=true; // to snap an image of the canvas and save as a PDF
  }
  
void mousePressed() 
  {
  T.toggleSlot(mouseX,mouseY);  
  }