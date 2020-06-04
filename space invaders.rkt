(require 2htdp/image)
(require 2htdp/universe)

;;Space Invaders

;; =================
;; Constants:

(define HEIGHT 700)
(define WIDTH 500)
(define MTS (empty-scene WIDTH HEIGHT))

(define shipIMG .  )
(define sHeight (- HEIGHT 40))
(define invaderIMG .)
(define invDX 5)


(define beamIMG  (rectangle 10 30 "solid" "light blue")  )
(define bullspeed 5)
(define hit-range  20)

;; =================
;; Data definitions:




(define-struct ship (x y))
;;(make-ship Natural[0,WIDTH] Natural[0,HEIGHT])
;;A struct where:
;; x: x-cor of ship
;; y: y-cor of ship    stays cons

(define shp1 (make-ship 5 HEIGHT))
(define shp2 (make-ship 500 HEIGHT))


(define-struct invader (x y dx))
;;(make-invader Natural[0, WIDTH] Natural[0,HEIGHT])
;; A struct where:
;;   x: x-cor of invader  
;;   y: y-cor of invader        
  
(define inv1 (make-invader 0 0 invDX))
(define inv2 (make-invader (/ WIDTH 2) (/ HEIGHT 2) (- invDX)))
(define inv3 (make-invader 600  700 invDX ))
(define inv4 (make-invader (- WIDTH invDX)  300 invDX ))
(define inv5 (make-invader invDX 700 (- invDX) ))



(define-struct beam (x y))
;;(make-beam Natural[0,WIDTH] Natural[0,HEIGHT]
;; A struct where:
;;   x: x-cor of beam    stays cons when shot
;;   y: y-cor of beam

(define beam1 (make-beam 675 sHeight ))
(define beam2 (make-beam 30   0 ))
(define beam3 (make-beam 800 600))


;;LOI
;; loi is a list of Invaders
;;(list (make-invader 785 300) (...))
(define loi1 (list (make-invader 400 300 invDX )  ))
(define loi2 (list (make-invader 300 300 invDX ) (make-invader 60 900 (- invDX)) ))
(define loi3 (list (make-invader 300 300 invDX ) (make-invader 60 900 invDX)  (make-invader 450 300 invDX) (make-invader 0 0 invDX)))

(define lob4 (list (make-beam  20 40 ) (make-beam   250 370)  (make-beam   500 300 ) (make-beam   0 0))) ;;Blast testing

;;LOB
;; lob is a list of Beams
;; (list make-beam 500 500)
(define lob1 (list (make-beam 200 300 )  ))
(define lob2 (list (make-beam 720 300 ) (make-beam 60  900) ))
(define lob3 (list (make-beam 34  666 ) (make-beam 223 110)  (make-beam 150 300 ) (make-beam 0 0)))

;;Blast testing 
(define loi4 (list (make-invader  20 40 invDX) (make-invader  250 370 invDX)  (make-invader  500 300 invDX ) (make-invader  0 0 invDX)))
(define loi5 (list (make-invader  20 40 invDX) (make-invader  112 211 invDX)  (make-invader  500 300 invDX ) (make-invader  5 45 invDX)))
(define loi5a (list (make-invader  112 211 invDX) (make-invader  5 45 invDX)))
(define loi6 (list (make-invader  111 0 invDX) (make-invader  112 211 invDX)  (make-invader  80 300 invDX ) (make-invader  5 10 invDX)))


;;Game is a list
;;(list ship (cons invaders) (cons beam) )

; 
; ;;Tests for blast mechanism
; ;;All match
; (define loi4 (list (make-invader  20 40 invDX) (make-invader  250 370 invDX)  (make-invader  500 300 invDX ) (make-invader  0 0 invDX)))
; ;;2/4 match
; (define loi5 (list (make-invader  20 40 invDX) (make-invader  112 211 invDX)  (make-invader  500 300 invDX ) (make-invader  5 10 invDX)))
; ;;0/4 match
; (define loi6 (list (make-invader  111 0 invDX) (make-invader  112 211 invDX)  (make-invader  80 300 invDX ) (make-invader  5 10 invDX)))
; (define lob4 (list (make-beam  20 40 ) (make-beam   250 370)  (make-beam   500 300 ) (make-beam   0 0)))

(define-struct game (shp loi lob counter))
;;(make-game  make-ship list(invaders) list(beams) Natural)
;; make-game is a struct in which
;;             shp: holds the make-ship struct 
;;             loi: holds the list of make-invader struct
;;             lob: holds the list of the make-beam struct
;;             counter: var to aid in creating invaders at random intervals

(define G1 (make-game shp1 empty empty 2 ))
(define G2 (make-game shp1 loi2 lob2  4 ))
(define G3 (make-game shp1 loi1 lob3  600 ))
(define G0 (make-game shp1 loi3 empty 700))
(define G4 (make-game shp1 loi4 lob3  200 )) ;;Switched with G1

;;Special cases for blast mechanism    matches:
(define G5 (make-game shp1 loi4 lob4 25)) ;;4/4 
(define G6 (make-game shp1 loi5 lob4 25)) ;;2/4 
(define G7 (make-game shp1 loi6 lob4 25)) ;;0/4

; (define G1 (list shp1 loi4 lob3))
; (define G2 (list shp1 loi2 lob2))
; (define G3 (list shp1 loi1 lob1))
; (define G4 (list shp1 empty empty))
; 
; (define G5 (list shp1 loi4 lob4)) ;; 4/4
; (define G6 (list shp1 loi5 lob4)) ;; 2/4
; (define G7 (list shp1 loi6 lob4)) ;; 0/4





;; ====================================================================================================
;; Functions:

;; Game == WS
;; WS -> WS
;; start the world with (main G0)
(define (main ws)
  (big-bang ws                   ; WS
            (on-tick   tock)     ; WS -> WS
            (to-draw   render)   ; WS -> Image
            (stop-when gameover)      ; WS -> Boolean
            (on-mouse  handle-mouse)      ; WS Integer Integer MouseEvent -> WS
            (on-key    handle-key)))    ; WS KeyEvent -> WS



;; WS -> WS
;; produce the next WS
(define (tock ws)(make-game (game-shp ws)  (addINV (invade(destroy-invaders (game-loi ws) (game-lob ws))) (game-counter ws) )
                                           (shoot (destroy-missiles (game-lob ws)  (game-loi ws))) (add1 (game-counter ws)))  )

;;________________________________________________________________________________________________

; 
; (define G5 (list shp1 loi4 lob4)) ;; 4/4
; (define G6 (list shp1 loi5 lob4)) ;; 2/4
; (define G7 (list shp1 loi6 lob4)) ;; 0/4
; 

;;BLAST MECHANISM 
;; loi/lob -> loi/lob
;;(check-expect (destroy-invaders loi4 lob4) empty  ) test pass but change hitrange for all
;;(check-expect (destroy-invaders loi5 lob4) loi5a )
;;(check-expect (destroy-invaders loi6 lob4) loi6   )


;;loi lob -> loi
;; produces the update version of loi; removing those that have same coords as elements in loi
(define (destroy-invaders loi lob )
                 (if  (empty? loi) empty (  if (beam-hit? (first loi) lob) (destroy-invaders (rest loi) lob)
                                               (cons (first loi) (destroy-invaders (rest loi) lob))) ))
;;Helper
;; invader lob -> Boolean
;; produces a boolean based on if the given invader matches any of the beams in lob
(define (beam-hit? invader lob) (if (empty? lob) false
                                    (if (INVmatches? invader (first lob)) true (beam-hit? invader (rest lob))) ))
;;Helper
;; invader beam -> Boolean
;; produces a boolean based on if the beam and invader have the same coords
(define (INVmatches? invader beam ) (and (<= (abs (- (invader-x invader) (beam-x beam))) hit-range)
                                      (<= (abs (- (invader-y invader) (beam-y beam))) hit-range)))


;;-------------------------------------------

;;loi lob -> lob
;; produces the update version of lob; removing those that have same coords as elements in lob
(define (destroy-missiles lob loi )
                 (if  (empty? lob) empty (  if (inv-hit? (first lob) loi) (destroy-missiles (rest lob) loi)
                                               (cons (first lob) (destroy-missiles (rest lob) loi ))) ))
;;Helper
;; beam loi -> Boolean
;; produces a boolean based on if the given beam matches any of the beams in loi
(define (inv-hit? beam loi) (if (empty? loi) false
                                    (if (BMmatches? beam (first loi) ) true (inv-hit? beam (rest loi))) ))

;;Helper
;; beam  invader -> Boolean
;; produces a boolean based on if the beam and invader have the same coords
(define (BMmatches? beam invader ) (and (<= (abs (- (invader-x invader) (beam-x beam))) hit-range)
                                      (<= (abs (- (invader-y invader) (beam-y beam))) hit-range)))

;;____________________________________________________________________________________________________

;;Create random invader
(define (addINV loi count )  (if (= (modulo count 50) 0) (createINV loi count)  loi ))
(define (createINV loi count) (if (empty? loi) (cons (make-invader (random WIDTH)(- (random HEIGHT)) count) empty )
                                                             (cons (first loi) (createINV (rest loi) count )) ))

;;_____________________________________________________________________________________________________
;;Gameover
;; loi -> Boolean
(define (gameover ws) (if (empty? (game-loi ws)) false (if (invaded? (first (game-loi ws))) true
                                                           (gameover (make-game (game-shp ws) (rest (game-loi ws)) (game-lob ws) (game-counter ws)) )) ))
(define (invaded? invd) (<= (abs (- (invader-y invd) HEIGHT )) hit-range) )

;;_________________________________________________________________________________________________

;;loi -> loi 
;; update the locations of the invaders
(define (invade loi) (cond [(empty? loi) empty]
                           [else ( cons (upInvader (first loi)) (invade (rest loi)) ) ]))

(check-expect (upInvader inv1) (make-invader invDX 1 invDX) )
(check-expect (upInvader inv2) (make-invader (+ (/ WIDTH 2) (- invDX)) (+ (/ HEIGHT 2) 1) (- invDX)) )
;; (check-expect (upInvader inv3) (make-invader (+ 600 invDX) 701 invDX) )  
(check-expect (upInvader inv4) (make-invader (- (- WIDTH invDX) invDX) 301 (- invDX) ) )  ;;Right edge case
(check-expect (upInvader inv5) (make-invader (+ invDX invDX)  701 invDX) )                ;;Left edge case
;;invader -> invader
;; update the location of an invader
(define (upInvader inv) (cond [(>= (+ (invader-x inv) (invader-dx inv))  WIDTH)
                                                         (make-invader (- (invader-x inv) invDX) (+(invader-y inv) 1)  (- invDX) ) ] 
                              [(<= (+ (invader-x inv) (invader-dx inv))  0)
                                                         (make-invader (+ (invader-x inv) invDX) (+ (invader-y inv) 1)   invDX ) ]
                              [else
                                   (make-invader ( + (invader-x inv) (invader-dx inv) ) (+ (invader-y inv) 1)  (invader-dx inv) ) ]))


;;lob -> lob
;;update the locations of the beams 
(define (shoot lob) (cond [(empty? lob) empty]
                          [else (cons (make-beam (beam-x (first lob)) (- (beam-y (first lob)) bullspeed)) (shoot (rest lob))  )]))


;;Change location of the ship
(define (handle-key ws ke)
  (cond [(key=? ke "d") ( make-game ( make-ship (+ (ship-x(game-shp ws)) 5) (ship-y (game-shp ws)) ) (game-loi ws) (game-lob ws) (game-counter ws))]
        [(key=? ke "a") ( make-game ( make-ship (- (ship-x(game-shp ws)) 5) (ship-y (game-shp ws)) ) (game-loi ws) (game-lob ws) (game-counter ws))]
        [else 
         ws]))

;;Create beam
(define (handle-mouse ws x y me)
  (cond [(mouse=? me "button-down") (make-game (game-shp ws) (game-loi ws)             
                                       (create-shots (game-lob ws) (ship-x(game-shp ws)) (+ (ship-y(game-shp ws)) 10) ) (game-counter ws))] 
        [else
         ws]))
(define (create-shots lob x y) (if (empty? lob) (cons (make-beam x y)empty) (cons (first lob)(create-shots (rest lob) x y))  ))
;;______________________________________________________________________


;; WS -> Image
;; render the final image with the given set of lists of coordinates
(define (render ws) (place-image shipIMG (ship-x(game-shp ws))  (ship-y(game-shp ws)) (setInvaders (game-loi ws) (game-lob ws))  ))

(define (setInvaders loi lob)(if (empty? loi) (setBeams lob)
                  (place-image invaderIMG (invader-x (first loi))  (invader-y(first loi)) (setInvaders (rest loi) lob) ) ))

(define (setBeams lob) (if (empty? lob) MTS
                           (place-image beamIMG (beam-x(first lob))  (beam-y(first lob))  (setBeams (rest lob)) )  ))


