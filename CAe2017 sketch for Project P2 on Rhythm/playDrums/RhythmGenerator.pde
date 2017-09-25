public class RhythmGenerator{

  private Random random = new Random(System.currentTimeMillis() % 1000);
  public boolean verbose = false; //print debugging info
  public int populationSize = 50;
  public int iterations = 10000;
  public int numberOfCrossovers = 8*8*3/6; // length of rhythm divided by six
  public boolean competeWithParentsOnly = false;
  int randomCounter = 1;
  float minFitness = .92;
  
  
  // Returns the rhythm to be played.
  public Rhythm generateRhythm(Profile profile)
  {
    // Call genetic algorithm to optimize to the player profile
    
    DNA dna = this.geneticAlgorithm(profile);
    
    // Post process
    dna = this.postProcess(dna);
    
    // Convert the solution to the GA into a Rhythm
    Rhythm rhythm = new Rhythm(dna);
    
    return (Rhythm)rhythm;
    }
  
  // Genetic Algorithm implementation
  private DNA geneticAlgorithm (Profile profile)
  {
    // Make the solution, which is initially null
    DNA solution = null;    
    
    // Make the population array
    ArrayList<DNA> population = new ArrayList<DNA>();
    

    
    // Generate a random population
    for (int i=0; i < populationSize; i++) {
      DNA newIndividual = this.generateRandomIndividual();
      newIndividual.setFitness(this.evaluateFitness(newIndividual, profile));
      population.add(newIndividual);
    }
    if (this.verbose) {
      print("Initial population:\n");
      printPopulation(population);
    }
    
    // Iteration counter
    int count = 0;
    
    // Iterate until termination criteria met
    while (!this.terminate(population, count)) {
      // Make a new, possibly larger population
      ArrayList<DNA> newPopulation = new ArrayList<DNA>();

      // Keep track of individual's parents (for this iteration only)
      Hashtable parents = new Hashtable();

      // Mutuate a number of individuals
      ArrayList<DNA> mutationPool = this.selectIndividualsForMutation(population);
      for (int i=0; i < mutationPool.size(); i++) {
        DNA parent = mutationPool.get(i);
        // Mutate
        DNA mutant = parent.mutate();
        // Evaluate fitness
        double fitness = this.evaluateFitness(mutant, profile);
        mutant.setFitness(fitness);
        // Add mutant to new population
        newPopulation.add(mutant);
        // Create a list of parents and remember it in a hash
        ArrayList<DNA> p = new ArrayList<DNA>();
        p.add(parent);
        parents.put(mutant, p);
      }
      
      // Do Crossovers
      for (int i=0; i < this.numberOfCrossovers; i++) {
        // Pick two parents
        DNA parent1 = this.pickIndividualForCrossover(newPopulation, null);
        DNA parent2 = this.pickIndividualForCrossover(newPopulation, parent1);
        
        if (parent1 != null && parent2 != null) {
          // Crossover produces one or more children
          ArrayList<DNA> children = parent1.crossover(parent2);
          
          // Add children to new population and remember their parents
          for (int j=0; j < children.size(); j++) {
            // Get a child
            DNA child = children.get(j);
            // Evaluate fitness
            double fitness = this.evaluateFitness(child, profile);
            child.setFitness(fitness);
            // Add it to new population
            newPopulation.add(child);
            // Create a list of parents and remember it in a hash
            ArrayList<DNA> p = new ArrayList<DNA>();
            p.add(parent1);
            p.add(parent2);
            parents.put(child, p);
          }
        }
        
      }
      
      // Cull the population
      // There is more than one way to do it.
      if (this.competeWithParentsOnly) {
        population = this.competeWithParents(population, newPopulation, parents);
      }
      else {
        population = this.globalCompetition(population, newPopulation);
      }
      
      //increment counter
      count = count + 1;

      if (this.verbose) {
        DNA best = this.getBestIndividual(population);
        print("" + count + ": Best: " + best + " fitness: " + best.getFitness() + "\n");
      }
    }
    
    // Get the winner
    solution = this.getBestIndividual(population);
    
    if (this.verbose) {
      print("Solution: " + solution + " fitnes: " + solution.getFitness() + "\n");
    }
    print("Solution: " + solution + " fitnes: " + solution.getFitness() + "\n" + "number of iterations: " + count);

    return solution;
  }
  
  // Create a random individual.
  private DNA generateRandomIndividual ()
  {
    DNA individual = new DNA(randomCounter++);
    return individual;
  }
  
  // Returns true if the genetic algorithm should terminate.
  private boolean terminate (ArrayList<DNA> population, int count)
  {
    for (DNA d : population) {
      if (d.getFitness() > minFitness) {
        return true;
      }
    }
    if (count > this.iterations){
      return true;
    }
    return false;
  }
  
  // Return a list of individuals that should be copied and mutated.
  private ArrayList<DNA> selectIndividualsForMutation (ArrayList<DNA> population)
  {
    ArrayList<DNA> selected = new ArrayList<DNA>();
    for (int i = 0; i < this.populationSize/5; i++) {
      selected.add(population.get(this.random.nextInt(this.populationSize)));
    }
    return selected;
  }
  
  // Pick one of the members of the population that is not the same as excludeMe
  private DNA pickIndividualForCrossover (ArrayList<DNA> population, DNA excludeMe)
  {
    DNA picked = null;
    picked = population.get(random.nextInt(population.size()));
    if (picked == excludeMe) {
      return null;
    }
    else {
      return picked;
    }
  }
  
  // Determine if children are fitter than parents and keep the fitter ones.
  private ArrayList<DNA> competeWithParents (ArrayList<DNA> oldPopulation, ArrayList<DNA> newPopulation, Hashtable parents)
  {
    ArrayList<DNA> finalPopulation = new ArrayList<DNA>();
    if (finalPopulation.size() != this.populationSize) {
      print("Population not the correct size." + "\n");
      System.exit(1);
    }
    return finalPopulation;
  }
  
  // Combine the old population and the new population and return the top fittest individuals.
  private ArrayList<DNA> globalCompetition (ArrayList<DNA> oldPopulation, ArrayList<DNA> newPopulation)
  {
    ArrayList<DNA> finalPopulation = new ArrayList<DNA>();
    finalPopulation = (ArrayList<DNA>) newPopulation.clone();
    finalPopulation.addAll(oldPopulation);
    Collections.sort(finalPopulation);
    finalPopulation.subList(0, finalPopulation.size() - this.populationSize).clear();
    if (finalPopulation.size() != this.populationSize) {
      print("Population not the correct size." + "\n");
      System.exit(1);
    }
    return finalPopulation;
  }
  
  // Return the fittest individual in the population.
  private DNA getBestIndividual (ArrayList<DNA> population)
  {
    DNA best = population.get(0);
    double bestFitness = Double.NEGATIVE_INFINITY;
    for (int i=0; i < population.size(); i++) {
      DNA current = population.get(i);
      double currentFitness = current.getFitness();
      if (currentFitness > bestFitness) {
        best = current;
        bestFitness = currentFitness;
      }
    }
    return best;
  }
  
  private double evaluateFitness (DNA dna, Profile profile)
  {
    double fitness = 0.0;
    Rhythm rhythm = new Rhythm(dna);
    fitness = profile.evaluateRhythm(rhythm);
    return fitness;
  }
  
  private DNA postProcess (DNA dna)
  {
    return dna;
  }
  
  private void printPopulation (ArrayList<DNA> population)
  {
    for (int i=0; i < population.size(); i++) {
      DNA dna = population.get(i);
      print("Individual " + i + ": " + dna + " fitness: " + dna.getFitness() + "\n");
    }
  }  
}