# steve's bees

A "bee hive" simulation based on the genetic algorithm chapter from [Nature of Code](http://natureofcode.com), which, in turn, was inspired by 'Smart Rockets'.

##the idea

Four beehives send out bees to find a flower. They eventually learn to return home after finding the flower. The bees that get to the target and back home the fastest are rewarded with a higher "fitness"-- a higher probability of spreading their genes (their genes are the path they take throughout their lifetime-- its an array of PVectors managed by a class called DNA). Magically, each generation gets better at finding the flower. 

But, there are a few variables that can be manipulated to help the bees learn faster.

These variables are (so far):

* lifetime (the length of a generation)
* mutation rate (how much the new generation deviates from the old)
* max force (how much force can be applied to shift the path of the bee at any given point)
 
##the meta idea

Instead of playing around to find the optimal value of each of the above mentioned variables, I just use the same kind of genetic algorith employed to teach bees, but instead of an array of PVectors, the hive genes are characteristics like "lifetime", "mutation rate" and "max force". I want to add location and population size eventually as well-- but I have to introduce more interaction between the hives first.. so they don't all just go to the best location or all just make huge populations. There has to be something that limits population size and something that makes it so that hives somehow exert a kind of repelling force on each other.

The hives get better at producing bees that are good at learning how to find the flower. They evolve. The bees learn to find the target and the hives learn to create the best conditions for their bees.

The best hives are the ones that produce the most number of bees that are able to go to the flower and return home in the course of 10,000 frames. 

The best hives get the biggest fitness scores. Hives with the biggest fitness scores occupy more space in the mating pool and therefore their genes are more likely to end up being present in the next generation. The values of the various characteristics are shuffled around and eventually we get some very productive bee hives!

##Hive Characteristic Mutation

In Shiffman's example, there is mutate().
```
// Based on a mutation probability, picks a new random Vector
  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
        float angle = random(TWO_PI);
        genes[i] = new PVector(cos(angle), sin(angle));
        genes[i].mult(random(0, maxforce));
      }
    }
  }
```  
You give it a float, your desired mutation rate, and for each of the steps (vectors) in the bee's genes, it decides whether or not to change the direction and force by gettting a random number between 0 and 1 and evaluating that against the value of your desired mutation rate. 

With really low mutation rates, the children bees will follow paths very close to their parents-- and! their parents are likely to be the most fit bees so the children will end up being fairly 'fit' themselves. 

But! If no bees come close to the flower in the first generation, hives with really low mutation rates will have a hard time finding the flower in subsequent generations. This is why the question of 'the best mutation rate' came to mind. Hives with higher mutation rates are able to adjust in case the first generation didn't find the flower. Big mutation rates will create children that deviate from the paths of their parents-- and sometimes this is helpful.

I approached mutation a bit differently with hive evolution. I don't use a separate function, mutation is applied to every gene for every generation in crossover().. and hive genes aren't PVectors. 

Mutation is now a random float within one of two ranges (high and low) that adjusts the value of other floats (the genes). If parent hives are successful, it's children's genes will not be adjusted very much-- but, if the parents are not so successful, their children's genes will deviate to a larger degree.

It works like this:
```
  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  EcoRules crossover(EcoRules partner, float momMadeHome, float dadMadeHome, float genHighHome, float last) {

    ArrayList<Float> child = new ArrayList<Float>();
    
    // Pick a midpoint, the point where we will stop taking genes from one parent and start taking from another
    // because this is a hive, we aren't talking about PVectors-- our genes are characteristics like
    // lifetime, mutation rate, and max force. eventually we may work location and popNum into the genes too.
    int crossover = int(random(genes.size()));
    
    // Take "half" from one and "half" from the other. As we walk through the genes, depending on the performance
    // of this child's parents, we will mutate the genes at a high or low rate. 
    // the value of mutRate is set by comparing the last generation's max number of successful bees with this one's
    for (int i = 0; i < genes.size(); i++) {
      
     //these are the two different mutation rates. we use a wide range-- hMRate (high mutation rate)--
     //when none of the hives are able to produce a high enough number of bees smart enough to return home.
     //We use a smaller range-- nMRate (normal) when the bees are doing well.
      
     hMRate = random(.8,1.2);
      
     nMRate  = random(.99,1.01);
     
     // if this generation's high score was less than 75% of the last generation's high score,
     // we know we need to change some values so we use a bigger mutation rate. 
     
     if(genHighHome / last < .75){
        mutRate = hMRate;
      } else {
        //or, we just use the normal mutation rate, because if bees are returning
        //we don't want to deviate too much. this hive is on the right track
        mutRate = nMRate;
      }
      
      //now,  if the parents did well, we use the mutation rate to change the value of the gene a little bit 
      //or a lot if they did not do so well
      if (i > crossover) child.add(genes.get(i)*mutRate);
      else               child.add(partner.genes.get(i)*mutRate);
    } 
    
    //create the new genes and return them
    EcoRules newgenes = new EcoRules(child);
    return newgenes;
  }
  ```

And, we print the highest number of bees to return from each generation in the window so we can see that our ecosystem is learning how to produce hives that produce bees that are good at learning how to find flowers. 

It seems that there are a few combinations of characteristics that do well under these circumnstances. I've run the over and over and have observed different values doing pretty well. As I write now, I'm watching an ecosystem that for the first ten hive generations (which is equal to 10,000 frames) did not have any hives that exceeded 300 max returning bees. But, after 30 generations there were some hives that had almost reached 400 max returning bees. A hive finally hit 431 in generation # 39. Now, the highest score ever, after couple hundred generations, is 979.

The ecosystem is definitely learning how to create hives that produce bees that are able to find flowers and return home!

It's fun.


