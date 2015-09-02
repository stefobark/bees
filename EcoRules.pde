class EcoRules{
  
  ArrayList<Float> genes = new ArrayList<Float>();
  float nMRate;
  float hMRate;
  float mutRate;
  int mutLimit = 10;
  
  EcoRules(float lifetime, float mRate, float x, float y, float mForce) {
    genes.add(lifetime);
    genes.add(mRate);
    genes.add(x);
    genes.add(y);
    genes.add(mForce);
  }
  
   // Constructor #2, creates the instance based on an existing array
  EcoRules(ArrayList<Float> newgenes) {
    // We could make a copy if necessary
    // genes = (PVector []) newgenes.clone();
    genes = newgenes;
  }
  
  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  EcoRules crossover(EcoRules partner, float momMadeHome, float dadMadeHome, float genHighHome, float last) {
    ArrayList<Float> child = new ArrayList<Float>();
    
    // Pick a midpoint, the point where we will stop taking from one parent and start taking from another
    // here, because this is a hive, we aren't talking about PVectors-- our genes are characteristics like
    // lifetime, mutation rate, and max force. eventually we may work location into the genes too.
    int crossover = int(random(genes.size()));
    
    // Take "half" from one and "half" from the other. As we walk through the genes, depending on the performance
    // of this child's parents, we will mutate the genes at a high or low rate. 
    // the value of mutRate is set by a condition above
    for (int i = 0; i < genes.size(); i++) {
      
      //these are two different mutation rates. we use a wide hMRate (high mutation rate) when none of the hives
      //were able to produce a high enough number of bees smart enough to return home. we use nMRate (normal) when
      //the bees are doing well. Instead of doing mutation in a seperate function, i just mixed it into crossover()
      
      // up to a half could be taken, or up to half of the current value could be added
      hMRate = random(.8,1.2);
      
      // it could be reduced to 90% its size, or, 10% its current size could be added
      nMRate  = random(.99,1.01);
      
     //I wonder what the best limit is here... how many bees should return before we stop forcing randomization of genes?
     //it depends on the length of the ecosystem generation!   
     //if the maximum number of bees to return to any hive in this generation is less than some number
     println("genHighHome ", genHighHome);
     println("last ", last);
     if(  genHighHome / last < .75){
        // if bees are not returning to any of the hives we know we need to change some values. 
        // so, we use a bigger mutation rate.
        mutRate = hMRate;
        println("hMRate produced: ", mutRate);
      } else {
        //or, we just use the normal mutation rate, because if bees are returning
        //we don't want to deviate too much. this hive is on the right track
        mutRate = nMRate;
        println("NMRate produced: ", mutRate);
      }
      
      if (i > crossover) child.add(genes.get(i)*mutRate);
      else               child.add(partner.genes.get(i)*mutRate);
    }    
    
    EcoRules newgenes = new EcoRules(child);
    return newgenes;
  }
  
    
  float getMRate(){
    return genes.get(1);
  }
  
  float getLifetime(){
    return genes.get(0);
  }
 
}
  
