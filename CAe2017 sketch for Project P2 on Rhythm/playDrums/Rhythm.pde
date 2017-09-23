public class Rhythm {
  //Store information about the Rhythm
  public   boolean[][] rhythm = new boolean[8*8*3][5];;

  private Random random = new Random(1);
  
  public Rhythm(DNA dna)
  {
    this(dna.getChromosome());
  }
  
  public Rhythm(byte[] beats)
  {
    for (int i = 0; i < beats.length; i++)
    {
      rhythm[i][0] = (beats[i] & 0x01) != 0;
      rhythm[i][1] = (beats[i] & 0x02) != 0;
      rhythm[i][2] = (beats[i] & 0x04) != 0;
      rhythm[i][3] = (beats[i] & 0x08) != 0;
      rhythm[i][4] = (beats[i] & 0x10) != 0;
    }
  }
  
  public boolean[][] getRhythm()
  {
    return rhythm;
  }
}