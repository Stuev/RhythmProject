public  class Profile
{
  boolean[][] start;
  boolean[][] end;
  Random r = new Random();
  public Profile(){}
  
  public Profile(boolean[][] start, boolean[][] end)
  {
    this.start = start;
    this.end = end;
  }
  
  
  public float evaluateRhythm(Rhythm r)
  {
    
    int countTop = 0;
    boolean[][] rhythm = r.getRhythm();
    for (int i = 0; i < rhythm.length; i++)
    {
      countTop += (rhythm[i][0] ? 1 : 0) - (rhythm[i][1] ? 1 : 0);
    }
    return (float)countTop / rhythm.length;
    
    //return beatSimilarity(r);
  }
  
  private float beatSimilarity(Rhythm r)
  {
  //  float startBeatCount = 0;
  //  float endBeatCount = 0;
  //  float rhythmBeatCount = 0;
  //  float countScore = 0;
    
    float countSame = 0;
    boolean[][] rhythm = r.getRhythm();
    boolean sameAsStart = true;
    for (int i = 0; i < rhythm.length; i++)
    {
      sameAsStart = (i % 16 == 0) ? this.r.nextFloat() < (i / 16) / 13.0 : sameAsStart;
      //startBeatCount = 0;
      //endBeatCount = 0;
      //rhythmBeatCount = 0;
      for (int j = 0; j < 5; j++)
      {
        countSame += (sameAsStart && rhythm[i][j] == start[i%start.length][j] || !sameAsStart && rhythm[i][j] == end[i%end.length][j] ? 1 : -1);
        //rhythmBeatCount += (rhythm[i][j] ? 1 : 0);
        //endBeatCount += (end[i%end.length][j]) ? 1 : 0;
        //startBeatCount += (start[i%start.length][j]) ? 1 : 0;
      }
      //countScore += (sameAsStart) ? 5 - abs(startBeatCount - rhythmBeatCount): 5 - abs(endBeatCount - rhythmBeatCount);
    }

    return (countSame) / (5*rhythm.length);
  }
  
}