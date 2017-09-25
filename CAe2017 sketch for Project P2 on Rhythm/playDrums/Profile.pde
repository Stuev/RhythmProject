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
    float sameAsStart = 0; // this is the ration of beats in a given measure that should be the same as in the corresponding start measure
    for (int i = 0; i < 12; i++)
    {
      sameAsStart = 1 - (i / 11.0);
      int[] instrumentWeights = {5, 4, 3, 4, 5};
      float sum = 21.0;
      
      // twins are pairs of measures [1, 3] [2, 4] in each row. These should be similar.
      boolean[][] twin = null;
      if (i % 4 == 0)
      {
        twin = Arrays.copyOfRange(rhythm, (i+2)*16, (i+3)*16);
      } else if (i%4 ==1)
      {
        twin = Arrays.copyOfRange(rhythm, (i+2)*16, (i+3)*16);
      } else if (i %4 ==2)
      {
        twin = Arrays.copyOfRange(rhythm, (i-2)*16, (i-1)*16);
      } else
      {
        twin = Arrays.copyOfRange(rhythm, (i-2)*16, (i-1)*16);
      }
      
      int[] sameInBlockCount = countSameInBlock(Arrays.copyOfRange(rhythm, i*16, (i+1)*16), twin, i%4, instrumentWeights);
      countSame+= (sameAsStart * sameInBlockCount[0] / (16 * sum) + (1-sameAsStart)*sameInBlockCount[1]/ (16 * sum) + sameInBlockCount[2] / (64 * sum)) / 1.25;
    }

    return (countSame) / 12.0;
  }
  
  // returns [sameAsStartCount, sameAsEndCount, sameAsTwin ([1,3] or [2,4])]
  private int[] countSameInBlock(boolean[][] block, boolean[][] twin, int blockNumber, int[] instrumentWeights)
  {
    int[] sameCount = {0, 0, 0};
    for (int i = 0; i < block.length; i++)
    {
       for (int j = 0; j < 5; j++)
       {
         sameCount[0] += start[i + blockNumber * 16][j] == block[i][j] ? instrumentWeights[j] : 0;
         sameCount[1] += end[i + blockNumber * 16][j] == block[i][j] ? instrumentWeights[j] : 0;
         sameCount[2] += twin[i][j] == block[i][j] ? instrumentWeights[j] : 0;
       }
    }
    return sameCount;
  }
  
  //------------------------ TEST EVALUATION FUNCTIONS ----------------------------
  //-------------------------------------------------------------------------------
  
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