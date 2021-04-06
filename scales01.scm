; GIMP script to make an illustration for showing how to do two-hand
; scales on a piano.



(define (scales-master inKey inFilename)
  ; inKey: "C", "Afm" - A-G required, "s" or "f" optional, "m" optional
  ; inFilename: what to save as, relative to user's home dir
  (let* (
	 (the-image (scales-full-page inKey))
	 (the-layer nil)
	 )
    (set! the-layer (car(gimp-image-merge-visible-layers the-image CLIP-TO-IMAGE)))
    (file-png-save RUN-NONINTERACTIVE the-image the-layer inFilename inFilename FALSE 9 FALSE FALSE FALSE FALSE FALSE)
    (gimp-image-clean-all the-image)
    )
  ) ; scales-master


(define (scales-full-page inKey)
  (let* ((keys (cons
		; key   sharps-and-flats-A-through-G
		; should have one line for each possible key
		("C" . (nil . nil . nil . nil . nil . nil . nil))
		("G" . (nil . nil . nil . nil . nil . #\s . nil))
		) ; TODO look up how to do a map with lisp "structures"
	       (the-image nil) ; TODO
	       )
	 (page-width (* 11 300))
	 (page-height (* 8.5 300))
	 (margin 150)
	 (title)
	 (draw-staff the-image)
	 (draw-notes inKey the-image) ; TODO first arg
	 (draw-piano (string-ref inKey 0) the-image)
	 (draw-fingering inKey the-image) ; TODO first arg
	 (copyright)
	 )
    ; create an image
    
    )
  ) ; scales-full-page


(define (draw-piano inStartKey the-image)
  ; inStartKey: note of leftmost key as "C"; used in drawing the black keys
  (let* (
	 (keyTop 1000)
	 (keyLeftOffset 100)
	 (whiteWidth 140)
	 (whiteBottom 1800)
	 (blackWidth 40)
	 (blackBottom 1400)
	 )
    ; code goes here
    )
  ) ; draw-piano


(define (draw-staff the-image)
  (gimp-context-set-foreground '(0 0 0))
  (let* (
	 (spacing 10)
	 (trebleTop 100)
	 (bassTop 200)
	 (leftX 40)
	 (rightMargin -40)
	 (staff-line-color '(75 75 75))
	 (rightX (+ (car(gimp-image-width the-image)) rightMargin))
	 (trebleclefimage "Documents/Nonfiction/PianoFlashCards/trebleClef-tall.png")
	 (bassclefimage "Documents/Nonfiction/PianoFlashCards/bassClef-tall.png")
	 (treble-clef-layer (car(gimp-file-load-layer RUN-NONINTERACTIVE inImage trebleclefimage)))
	 (bass-clef-layer (car(gimp-file-load-layer RUN-NONINTERACTIVE inImage bassclefimage)))
	 (clef-X 10)
	 (points (cons-array 4 'double))
	 (i 0) ; counter for drawing lines
	 (the-layer (car (gimp-layer-new the-image image-width image-height GRAYA-IMAGE "staff" 100 NORMAL-MODE)))
	 )

    ; make a layer
    (gimp-drawable-fill the-layer TRANSPARENT-FILL)
    (gimp-image-add-layer the-image the-layer 0)

    ; draw five lines of treble and five lines of bass
    (gimp-context-set-foreground stafflinecolor)
    (gimp-context-set-brush "Circle (05)")
    (aset points 0 leftX)
    (aset points 2 rightX)
    (while (< i 5)
	   (aset points 1 (+ trebleTop (* i spacing)))
	   (aset points 3 (+ trebleTop (* i spacing)))
	   (gimp-paintbrush-default the-layer 4 points)
	   (set! i (+ i 1))
	   ) ; while
    (while (< i 5)
	   (aset points 1 (+ bassTop (* i spacing)))
	   (aset points 3 (+ bassTop (* i spacing)))
	   (gimp-paintbrush-default the-layer 4 points)
	   (set! i (+ i 1))
	   ) ; while

    ; scale the clef image or layer
    ; stick the clef in

    ;(cond ((null? clefLayer)
;	   (set! clefLayer (gimp-layer-new inImage 100 100 RGB-IMAGE "Couldn't Load" 0 NORMAL-MODE)) ))
    (gimp-image-add-layer the-image treble-clef-layer 0)
    (gimp-image-add-layer the-image bass-clef-layer 0)
    (gimp-layer-set-offsets treble-clef-layer clef-X trebleTop)
    (gimp-layer-set-offsets bass-clef-layer clef-X bassTop)
    )
  (gimp-displays-flush)
  ) ; draw-staff


(define (draw-fingering inStartKey the-image)
  ; inStartKey: note of leftmost key as "C"
  (gimp-context-set-foreground '(0 0 0))
  (let* (
	 ; needed: two lists of fingerings for every key we're going to do
	 )
    )
  ) ; draw-fingering


(define (copyright the-image)
  (gimp-context-set-foreground '(0 0 0))
  (let* (
	 (copyright-string "Piano Scale Fingerings   Copyright (c) 2013 by Steve Furlong. All rights reserved.")
	 (font-size 12)
	 (the-layer (car (gimp-text-layer-new the-image copyright-string "Sans" font-size 0)))
	 (startX 40)
	 (startY -40) ; negative means pixels up from bottom margin
	 (y-offset (+ (car(gimp-image-height the-image)) startY))
	 )
    (gimp-image-add-layer the-image the-layer 0)
    (gimp-layer-set-offsets the-layer startX y-offset)
    )
  ) ; copyright


(define (title inKey the-image)
  (gimp-context-set-foreground '(0 0 0))
  ; inKey The key the scale is in, as "C" or "Bfm"
  (let* (
	 (font-size 36)
	 (the-message (concat inKey " Scale")) ; TODO expand the passed-in string
	 (the-layer (car (gimp-text-layer-new the-image the-message "Sans" font-size 0)))
	 (startX 0)
	 (startY 30)
	 )
    (gimp-image-add-layer the-image the-layer 0)
    (gimp-layer-set-offsets the-layer startX startY)
    ; I want to center the title; don't have references on-hand
    )
  ) ; title


(define (draw-notes inKey inTrebleTop inBassTop  the-image)
  (gimp-context-set-foreground '(0 0 0))
  ; inKey The key the scale is in, as "C" or "Bfm"
  (let* (
	 (ellipseX 10)
	 (ellipseY 5)
	 (ledger-width 20)
	 (lower-message "8 vb")
	 (lower-messageX 20)
	 (lower-leftX 50)
	 (lower-rightX 200)
	 (lower-Y 20)
	 (raise-message "8 va")
	 (raise-messageX 20)
	 (raise-leftX 50)
	 (raise-rightX 200)
	 (raise-Y 20)
	 (font-size 12)
	 (treble-raise-message-layer ((car gimp-text-layer-new the-image raise-message "Sans" font-size 0)))
	 (treble-lower-message-layer ((car gimp-text-layer-new the-image lower-message "Sans" font-size 0)))
	 (bass-raise-message-layer   ((car gimp-text-layer-new the-image raise-message "Sans" font-size 0)))
	 (bass-lower-message-layer   ((car gimp-text-layer-new the-image lower-message "Sans" font-size 0)))
	 )
    ; steps here
    )
  ) ; draw-notes
