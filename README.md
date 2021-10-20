# BSL-Space-invaders
The final project of the How to Code: Simple Data course. Fun game to play



The nature of BSL makes the language somewhat hard to read even when well designed, so here is some insight into how the code works:

The main data structure used for the program:
"game": like an Object(java) that contains:
                           (list of x,y for invader images)
                           (list of x, y for beam images)
                           (ship-struct)
                           counter -> Integer
                           
The code is formatted into one main function that calls on separate functions for every major aspect of the program, and each
of those functions has helper functions for performing complementary tasks.
         
Takes in a "game"                 
(Main game):
         (tock game): Every epsilon seconds it updates the list of (x y) for invaders and beams *Has helper functions that update he list of (x,y)'s 
			for invdrs and for list of (x,y)'s for beam

         (render game): Uses the given sets of (x,y)'s to set it as coordinates to
                        place images.
        
	 (gameover game): Checks to see if the y coordinate of any invader is within a given range of
			the height of the scene.
	
	 (handle-mouse game): adds another (x,y) to the list of beams; Uses current coordinates of the ship-struct.
	 (handle-key game):  moves the ship struct 5 units right/left if corresponding button is clicked, otherwise returns the input.


---------------------------------------
let m: list of (x,y)  for invaders
let z: list of (x, y)  for beams

**tock works somewhat like this:

(addINV (invade(destroy-invaders (game-loi ws) (game-lob ws))) (game-counter ws) )

(tock game )
    ( data
     m  =   a(g( f(game-m ,game-z)) counter)     f(m,z)		-> removes invaders that have the same (x,y) as an element in z 
						 g(m)  		-> advanvces the invaders
						 a(m , counter) -> Adds an invader to the current list based on count
    
      z  =     t( r(game-z ,game-m))             r(z , m)	 -> removes invaders that have the same (x,y) as an element in m
						 g(m)     	 -> advances the invaders       
      count = count + 1 
)


 **Render works somewhat like this:
(render game )
	f(game-ship, g(m , h(z)) )  		f(ship , background) -> uses the (x,y) of ship to create an image at that position, place on that background
						g(m, background )    -> uses the (x,y) of each element in m to make corresponding images, placed on given background
						h(z)                 -> uses the (x,y) of each element in z to make corresponding image, placed on a set background



Questions?:

How does the add invader, based on count, mechanism work?
 The tock functio adds 1 every iteration. 
 Then a(m , counter) decides whether or not to add a new invader.

 how?: If (count % 50 = 0) then add a invader with random (x[0 , -HEIGHT ]* , y ) coords , otherwise don't.  *Above the visible screen


 Although this may seem as if the invaders are going to be coming in a predictable manner, they don't. This is because they are placed randomly(above vis. screen).
 This means that the invaders may be placed in clusters, or not in, in essence providing a "chaotic" series of invaders that gives the outlook as if they were
 made every random amount of seconds.
 Another way to look at it:
	In the actual game, most likely , the invaders are created every random couple of seconds/ OR  a set of intervals. The way my implementation works is by 
	creating them in timely intervals but placing them in random intervals which in essence has the same effect.



How does the Blast mechanism work?
 Blast mechanism: Eliminate the beams if the hit a invader, and eliminate the invader if it hits a beam.

 This mechanism works in two separte methods that combine to give the correct result. 
 One method takes in the original list of invaders and original list of beams. Then gives the updated version of the list of invaders.
 The second method does the inverse of this ^ (look up) ^ . 



