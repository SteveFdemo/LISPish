; rotate a set of images leftward
;
; run as
; $ gimp -i -d -f -b '(rotatepics "*" -0.1)' -b '(gimp-quit 0)'

(define (rotatepics pattern angle)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
	   (let* ((filename (car filelist))
		  (fileparts (strbreakup filename "."))
		  (filename-new (string-append (car fileparts) "_rotated.xcf"))
		  (img (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
		  (drw (car (gimp-image-get-active-layer img)))
		  )
	     (gimp-drawable-transform-rotate-default drw angle TRUE 0 0 TRUE TRANSFORM-RESIZE-CLIP)
	     (gimp-xcf-save 0 img drw filename-new filename-new)
	     (gimp-image-delete img)
	     ) ; inner let
	   (set! filelist (cdr filelist))
	   ) ; while
    ) ; outer let
  ) ; fn
