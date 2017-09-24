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
    return beatSimilarity(r);
  }
  
  private float beatSimilarity(Rhythm r)
  { 
    float countSame = 0;
    boolean[][] rhythm = r.getRhythm();
    float sameAsStart = 0;
    for (int i = 0; i < 12; i++)
    {
      sameAsStart = i / 13.0;
      int[] sameInBlockCount = countSameInBlock(Arrays.copyOfRange(rhythm, i*16, (i+1)*16), i%4);
      countSame+= sameAsStart * sameInBlockCount[0] / (16 * 5) + (1-sameAsStart)*sameInBlockCount[1]/ (16 * 5);
    }

    return (countSame) / 12.0;
  }
  
  // returns [sameAsStartCount, sameAsEndCount]
  private int[] countSameInBlock(boolean[][] block, int blockNumber)
  {
    int[] sameCount = {0, 0};
    for (int i = 0; i < block.length; i++)
    {
       for (int j = 0; j < 5; j++)
       {
         sameCount[0] += start[i + blockNumber * 16][j] == block[i][j] ? 1 : 0;
         sameCount[1] += end[i + blockNumber * 16][j] == block[i][j] ? 1 : 0;
       }
    }
    return sameCount;
  }
  
  private float bottomFullAboveEmpty (Rhythm r)
  {
    int countTop = 0;
    boolean[][] rhythm = r.getRhythm();
    
    for (int i = 0; i < rhythm.length; i++)
    {
      countTop += (rhythm[i][0] ? 1 : 0) - (rhythm[i][1] ? 1 : 0);
    }
    return (float)countTop / rhythm.length; 
  }
  
    private float sameAsFirstBeat(Rhythm r)
  {
    float countSame = 0;
    boolean[][] rhythm = r.getRhythm();
    float sameAsStart = 0;
    for (int i = 0; i < rhythm.length; i++)
    {
      sameAsStart = (i % 16 == 0) ? (i / 16.0) / 13.0 : sameAsStart;

      for (int j = 0; j < 5; j++)
      {
        countSame += rhythm[i][j] == start[i%start.length][j] ? 1:0;
      }
    }
    return (countSame) / (5*rhythm.length); 
  }
}