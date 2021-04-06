(define (script-fu-full-page)
  (let* (
	 (image-width (* 300 8))
	 (image-height (* 300 10.5))
	 (stafftopY 840) ; TWEAK THIS
	 (pianotopY 140) ; TWEAK THIS
	 (separatorX 1700)
	 (separatortopY 10)
	 (separatorbottomY 3100)
	 (separatorcolor '(180 180 180))
	 (points           (cons-array 4 'double))
	 (the-image (car (gimp-image-new image-width image-height GRAY)))
	 (background-layer (car (gimp-layer-new the-image image-width image-height GRAY-IMAGE "background" 100 NORMAL-MODE)))
	 (the-layer (car (gimp-layer-new the-image image-width image-height GRAYA-IMAGE "staff and keys" 100 NORMAL-MODE)))
	 )

    (gimp-drawable-fill background-layer BACKGROUND-FILL)
    (gimp-image-add-layer the-image background-layer 0)
    (gimp-drawable-fill the-layer TRANSPARENT-FILL)
    (gimp-image-add-layer the-image the-layer 0)

    (script-fu-piano-keys the-image the-layer pianotopY)
    (script-fu-staff-lines the-image the-layer stafftopY)

    ; draw separator
    (gimp-context-set-brush "Circle (03)")
    (gimp-context-set-foreground separatorcolor)
    (aset points 0 separatorX)
    (aset points 1 separatortopY)
    (aset points 2 separatorX)
    (aset points 3 separatorbottomY)
    (gimp-paintbrush-default the-layer 4 points)

    (insert-copyright the-image)

    (gimp-display-new the-image)
    (gimp-displays-flush)
    (gimp-image-clean-all the-image)

    the-image  ; return handle for use in calling functions
    )
) ; full-page
(script-fu-register
 "script-fu-full-page"
 _"<Image>/Image/Piano Flash Card"
 "Draw the common parts of a flash card page"
 "Steve Furlong"
 "2012, Steve Furlong"
 "2012/11/18"
 ""
 )


(define (script-fu-piano-keys inImage theDrawable topkeyY)
  ; create a layer, then draw lines and filled rectangles
  ; to look like a sideways piano keyboard

  (let* (
	 (points          (cons-array 4 'double))
	 (numkeys 11)
	 (keyheight 280)
	 ;(topkeyY -140) ;10)
	 (keysleftX 1800)
	 (whitekeyrightX 2398)
	 (blackrightX 2100)
	 (blackhalfheight 70)
	 ;(blackkeypos '(0 2 3 5 6 7 9 10)) ; treble clef for staff starting high
	 ;(blackkeypos '(0 1 2 4 5 7 8 9 11)) ; bass clef for staff starting high
	 ;(blackkeypos '(0  2 3 4  6 7  9 10 11)) ; bass clef for staff starting low
	 (blackkeypos '(0 1 2  4 5  7 8 9  11)) ; treble clef for staff starting low

	 (blackkeycolor '(0 0 0))
	 (pianokeycolor '(75 75 75))

	 ;(separatorX 1700)

	 ;(topstaffY 240)
	 ;(staffleftX 0)
	 ;(staffrightX 1600)

	 (i 0) ; misc counter
	 ) ; end of local variables

    (gimp-context-set-foreground pianokeycolor)
    (gimp-context-set-brush "Circle (05)")

    ; draw the right bar of the keys
    (aset points 0 whitekeyrightX) (aset points 1 topkeyY) ; start X, Y
    (aset points 2 whitekeyrightX) (aset points 3 (+ topkeyY (* numkeys keyheight))) ; end X, Y
    (gimp-paintbrush-default theDrawable 4 points)

    ; draw the horizontal lines for the white keys
    (set! points (cons-array 4 'double))
    (aset points 0 (+ keysleftX 2) )
    (aset points 2 whitekeyrightX)
    (while (< i (+ numkeys 1 ))
	   (aset points 1 (+ topkeyY (* i keyheight)))
	   (aset points 3 (+ topkeyY (* i keyheight)))
	   (gimp-paintbrush-default theDrawable 4 points)
	   (set! i (+ i 1))
	   ) ; while over drawing white keys

    ; draw the black keys
    (define (select-black-keys lst)
      (cond ((null? lst)
	     #f)
	    (else
	     (gimp-rect-select inImage keysleftX (- (+ topkeyY (* (car lst) keyheight)) blackhalfheight) (- blackrightX keysleftX) (* 2 blackhalfheight) CHANNEL-OP-ADD FALSE 0)
	     (select-black-keys (cdr lst))
	     ))
      ) ; select-black-keys
    (gimp-selection-none inImage)
    (select-black-keys blackkeypos)
    (gimp-bucket-fill theDrawable BG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-bucket-fill theDrawable FG-BUCKET-FILL NORMAL-MODE  18 0 FALSE 0 0)

    ) ; let block
  (gimp-selection-none inImage)
  (gimp-displays-flush)
  ) ; script-fu-piano-keys
;(script-fu-register
; "script-fu-piano-keys"
; _"<Image>/Image/Piano Keys"
; "Draw sketches of piano keys sideways"
; "Steve Furlong"
; "2012, Steve Furlong"
; "2012/11/18"
; ""
; SF-IMAGE "The Image" 0
; SF-DRAWABLE    "The drawable"   0
; )




(define (script-fu-staff-lines inImage theDrawable topstaffY)
  (let* (
	 (points          (cons-array 4 'double))
	 (keyheight 280)

	 (separatorX 1700)

	 (stafflinecolor '(75 75 75))

	 ;(topstaffY 0) ;150)
	 (staffleftX 0)
	 (staffrightX 1600)
	 (trebleclefimage "/home/steve/Documents/Nonfiction/PianoFlashCards/trebleClef-tall.png")
	 (bassclefimage "/home/steve/Documents/Nonfiction/PianoFlashCards/bassClef-tall.png")

	 (clefLayer (car(gimp-file-load-layer RUN-NONINTERACTIVE inImage trebleclefimage)))

	 (i 0) ; misc counter
	 ) ; end of local variables
    (gimp-context-set-foreground stafflinecolor)
    (gimp-context-set-brush "Circle (05)")
    (aset points 0 staffleftX)
    (aset points 2 staffrightX)
    (while (< i 5)
	   (aset points 1 (+ topstaffY (* i keyheight 2)))
	   (aset points 3 (+ topstaffY (* i keyheight 2)))
	   (gimp-paintbrush-default theDrawable 4 points)
	   (set! i (+ i 1))
	   ) ; while
    ;(cond ((null? clefLayer)
;	   (set! clefLayer (gimp-layer-new inImage 100 100 RGB-IMAGE "Couldn't Load" 0 NORMAL-MODE)) ))
    (gimp-image-add-layer inImage clefLayer 0)
    (gimp-layer-set-offsets clefLayer staffleftX topstaffY)
    )
  (gimp-displays-flush)
) ; script-fu-staff-lines
;(script-fu-register
; "script-fu-staff-lines"
; _"<Image>/Image/Staff Lines"
; "Draw the five lines of the staff"
; "Steve Furlong"
; "2012, Steve Furlong"
; "2012/11/18"
; ""
; SF-IMAGE "The Image" 0
; SF-DRAWABLE    "The drawable"   0
; )


(define (write-note inImage inLetter topstaffY inPosition inExtra)
  (gimp-context-set-brush "Circle (05)")
  (gimp-context-set-foreground '(0 0 0))
  (let* (
	 (keyheight 280)
	 ;(topstaffY 0) ;150)
	 (noteXoffset 1000)
	 (noteYoffset (- (+ topstaffY (* keyheight inPosition)) keyheight))
	 (letterExtraYoffset (if (equal? "flat" inExtra) (/ keyheight 2)  (if (equal? "sharp" inExtra) (- 0 (/ keyheight 2)) 0)))
	 (letterXoffset 2200)
	 (letterYoffset (+ noteYoffset keyheight))
	 (extraXoffset 600)
	 (the-layer (car (gimp-layer-new inImage (+ 4 (* keyheight 2)) (+ 4 (* keyheight 2)) GRAYA-IMAGE "Note" 100 NORMAL-MODE)))
	 (the-letter (if (equal? "sharp" inExtra) (string-append inLetter "♯") (if (equal? "flat" inExtra) (string-append inLetter "♭") inLetter)))
	 (letter-layer (car (gimp-text-layer-new inImage the-letter "Sans" 108 0)))
	 (extra-layer nil)
	 )
    (gimp-drawable-fill the-layer TRANSPARENT-FILL)
    (gimp-image-add-layer inImage the-layer -1)

    (gimp-ellipse-select inImage 2 2 (* keyheight 2) (* keyheight 2) CHANNEL-OP-REPLACE FALSE FALSE 0)
    (gimp-edit-stroke the-layer)
    (gimp-layer-set-offsets the-layer noteXoffset noteYoffset)
    (gimp-selection-none inImage)

    (if (equal? "flat" inExtra)
	(begin
	 (set! extra-layer (car(gimp-file-load-layer RUN-NONINTERACTIVE inImage "/home/steve/Documents/Nonfiction/PianoFlashCards/flat.png")))
	 (gimp-image-add-layer inImage extra-layer 0)
	 (gimp-layer-set-offsets extra-layer extraXoffset (- (+ topstaffY (* keyheight inPosition)) keyheight))
	 )
	)
    (if (equal? "sharp" inExtra)
	(begin
	 (set! extra-layer (car(gimp-file-load-layer RUN-NONINTERACTIVE inImage "/home/steve/Documents/Nonfiction/PianoFlashCards/sharp.png")))
	 (gimp-image-add-layer inImage extra-layer 0)
	 (gimp-layer-set-offsets extra-layer extraXoffset (- (+ topstaffY (* keyheight inPosition)) keyheight))
	 )
	)

    (gimp-image-add-layer inImage letter-layer 0)
    (gimp-layer-set-offsets letter-layer letterXoffset (+ letterYoffset -54 letterExtraYoffset))
    )
) ; write-note


;(define (write-flat-note inImage inLetter topstaffY inPosition)
;  (write-note inImage (string-append inLetter "♭") topstaffY inPosition "flat")
;)

;(define (write-sharp-note inImage inLetter topstaffY inPosition)
;  (write-note inImage (string-append inLetter "♯") topstaffY inPosition "sharp")
;)

;(define (write-natural-note inImage inLetter inPosition)
;  ; "♮"
;)

(define (insert-copyright the-image)
  (gimp-context-set-foreground '(0 0 0))
  (let* (
	 (the-copyright "Piano Note Flash Cards   Copyright (c) 2012 Steve Furlong")
	 (the-layer (car (gimp-text-layer-new the-image the-copyright "Sans" 36 0)))
	 (y-offset (- (car(gimp-image-height the-image)) 50))
	 )
    (gimp-image-add-layer the-image the-layer 0)
    (gimp-layer-set-offsets the-layer 0 y-offset)
    )
) ; insert-copyright

(define (short-line inImage inPosition topstaffY)
  (let* (
	 (points (cons-array 4 'double))
	 (keyheight 280)
	 (leftX 950)
	 (rightX 1600)
	 (stafflinecolor '(75 75 75))
	 ;(topstaffY 0) ;150)
	 (lineY (+ topstaffY (* inPosition keyheight)))
	 )
    (gimp-context-set-foreground stafflinecolor)
    (gimp-context-set-brush "Circle (05)")
    (aset points 0 leftX)
    (aset points 2 rightX)
    (aset points 1 lineY)
    (aset points 3 lineY)
    (gimp-paintbrush-default (car (gimp-image-get-active-layer inImage)) 4 points)
    )
  ) ; short-line


(define (noteflash inNote inPosition inExtra inFilename)
  ; inNote "A" "B" etc
  ; inYoffset Where the top of the staff starts
  ; inPosition Note's position on staff, with 0 being top line
  ; inExtra nil, "sharp", or "flat"
  ; inFilename what to save it as
  (let* (
	 (the-image (script-fu-full-page))
	 (yOffset 840) ; TWEAK THIS
	 (the-layer nil)
	 )
    (write-note the-image inNote yOffset inPosition inExtra)
    (set! the-layer (car(gimp-image-merge-visible-layers the-image CLIP-TO-IMAGE)))
    (file-png-save RUN-NONINTERACTIVE the-image the-layer inFilename inFilename FALSE 9 FALSE FALSE FALSE FALSE FALSE)
    (gimp-image-clean-all the-image)
    )
  ) ; noteflash
