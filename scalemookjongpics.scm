; Process a batch of XCF files to scale down to size for Wing Chun
; Forms book. These are the Mook Jong pictures, which have set size.

; Run from command line with
; $ gimp -i -d -f -b '(scalemookjongpics "*.xcf" 128)' -b '(gimp-quit 0)'
;     with the 128 being the height of the thumbnails

(define (scalemookjongpics pattern height-new)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
	   (let* ((filename (car filelist))
		  (fileparts (strbreakup filename "."))
		  (filename-new (string-append (car fileparts) "_sized_bw.png"))
		  (img (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
		  (drw (car (gimp-image-get-active-layer img)))
		  (original-width  (car (gimp-image-width  img)))
		  (original-height (car (gimp-image-height img)))
		  (width-new (* original-width (/ height-new original-height)))
		  )
	     (gimp-image-scale img width-new height-new)
	     (gimp-image-convert-grayscale img)
	     (set! drw (car (gimp-image-flatten img)))
	     (file-png-save RUN-NONINTERACTIVE img drw filename-new filename-new 0 9 0 0 0 0 0)
	     (gimp-image-delete img)
	     ) ; inner let
	   (set! filelist (cdr filelist))
	   ) ; while
    ) ; top let
  ) ; fn
