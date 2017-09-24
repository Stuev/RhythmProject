import java.util.Random;
import java.util.*;

//Make any new member variables and functions you deem necessary.
//Make new constructors if necessary
//You must implement mutate() and crossover()


public class DNA implements Comparable<DNA>
{
  
  protected byte[] chromosome = new byte[8*8*3]; // The default representation is a string
  private double fitness = 0.0; // Store the fitness
  protected int length = 8*8*3; // The length of the Rhythm
  private Random random;
  public int numGenes = 0; //number of genes
 
  public DNA(int randomSeed) {
    random = new Random(randomSeed);
    
    // All permutations of sounds in each timestep can be represented by a bitstring of length 5, or the numbers [0, 31]
    for (int i = 0; i < this.chromosome.length; i++){
      this.chromosome[i] = (byte) random.nextInt(32);
    }
  }

  // Set the chromosome string
  public void setChromosome (byte[] chrom)
  {
    this.chromosome = chrom;
    this.length = chrom.length;
  }
  
  // Get the genotype string
  public byte[] getChromosome ()
  {
    return this.chromosome;
  }
  
  // Set the fitness
  public void setFitness (double fit)
  {
    this.fitness = fit;
  }
  
  // Get the fitness
  public double getFitness ()
  {
    return this.fitness;
  }
  
  // Set the level length
  public void setLength (int n)
  {
    this.length = n;
  }
  
  public int getLength ()
  {
    return this.length;
  }
  
  public int compareTo (DNA other)
  {
    if (this.fitness == other.getFitness()) {
      return 0;
    }
    else if (this.fitness < other.getFitness()) {
      return -1;
    }
    else {
      return 1;
    }
  }
  
  public String toString ()
  {
    String s = "";
    for (int i = 0; i < this.length; i++)
    {
      s += this.chromosome[i] + ", ";
    }
    return s;
  }

  // Return a new DNA that differs from this one in a small way.
  public DNA mutate ()
  {
    DNA copy = new DNA(random.nextInt(9999999));
    byte[] chrom = this.chromosome.clone();
    chrom[this.random.nextInt(chrom.length)] = (byte) random.nextInt(32);
    copy.setChromosome(chrom);
    return copy;
  }

  public byte get(int index) {
    return this.chromosome[index];
  }

  public ArrayList<DNA> crossover (DNA mate)
  {
    ArrayList<DNA> offspring = new ArrayList<DNA>();
    DNA copy = new DNA(random.nextInt(9999999));
    byte[] chrom1 = this.chromosome.clone();
    byte[] chrom2 = this.chromosome.clone();
    for (int i = 0; i < chrom1.length; i++){
      if (this.random.nextInt(10) < 5) {
        chrom1[i] = chrom2[i];
      }
    }
    copy.setChromosome(chrom1);

    DNA copy1 = new DNA(random.nextInt(9999999));
    chrom1 = this.chromosome.clone();
    chrom2 = this.chromosome.clone();
    for (int i = 0; i < chrom1.length; i++){
      if (this.random.nextInt(10) < 5) {
        chrom1[i] = chrom2[i];
      }
    }
    copy1.setChromosome(chrom1);
    offspring.add(copy);
    offspring.add(copy1);
    return offspring;
  }
  
  
  public void setNumGenes (int n)
  {
    this.numGenes = n;
  }

}