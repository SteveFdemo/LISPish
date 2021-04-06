;;
;; Prepare a standard HTML file for upload to various story sites.
;; Each site's rules differ, so we need custom tweaking for each.
;;
;; Because I forget how to do this EVERY STINKING TIME:
;; load from the *scratch* buffer with (load "path/prep-upload.el")
;;     (and ^J)
;; Execute by going to the buffer to change and pressing M-: and
;;     typing (prep-ficwad) or (prep-fp)
;;


(defun prep-ficwad ()
  "Improved version of:
   Modify a standard html file for posting to ficwad.
   Simplify the HTML and convert character entities to ASCII."
  (dolist (from-to '( ("<p align=\"center\">...oooOOOooo...</p>" "<p><center>...oooOOOooo...</center></p>")
		      ("<p align=\"center\"><strong>...oooOOOooo...</strong></p>" "<p><b><center>...oooOOOooo...</center></b></p>")
		      ("<span style='display:none'>\"</span>" "")
		      ("<span style='display:none;'>\"</span>" "")
		      ("<em>" "<i>")
		      ("</em>" "</i>")
		      ("<strong>" "<b>")
		      ("</strong>" "</b>")
		      ("&hellip\;" "...")
		      ("&ndash\;" "--")
		      ("&mdash\;" "---")
		      ("&eacute\;" "e")
		      ("&ecirc\;" "e")
		      ("&egrave\;" "e")
		      ))
    (beginning-of-buffer)
    (while (re-search-forward (car from-to) nil t)
      (replace-match (cadr from-to))
      ) ; while
    ) ; dolist
) ; defun prep-ficwad


(defun prep-fp ()
  "Modify a standard HTML file for posting to fictionpress.com."
  (dolist (from-to '( ("<span style='display:none'>\"</span>" "")
		      ("<span style='display:none;'>\"</span>" "")
		      ("``"    "&ldquo;")
		      ("`"     "&lsquo;")
		      ("''"    "&rdquo;")
		      ("'"     "&rsquo;")
		      ("---"   "&mdash;")
		      ("--"    "&ndash;")
		      ("<!&ndash;" "<!--")
		      ("&ndash;>" "-->")
		      ("&povbreak;"    "<p align=\"center\">...---...</p>") ; was '- - -', but FP deletes that on upload for some reason
		      ("&scenebreak;"  "<p align=\"center\">...ooo000ooo...</p>")
		      ("&majorbreak;"  "<hr />")
		      ("&chapterbreak;" "<p align=\"center\">=========== ========== ============= ============</p>")
		      ))
    (beginning-of-buffer)
    (while (re-search-forward (car from-to) nil t)
      (replace-match (cadr from-to))
      )  ; while
    )  ; dolist
  )  ; defun prep-fp


(defun markup-to-entity ()
  "Process a file which has my 'easy' markup and replace markup
   with html character entities. This is intended for HTML and
   XML files but should also work on any text file."
  (dolist (from-to '( ("``" "&#8220;")
		      ("`" "&#8216;")
		      ("''" "&#8221;")
		      ("'" "&#8217;")
		      ("---" "&#8212;")
		      ("--" "&#8211;")
		      ("<!&#8211;" "<!--")
		      ("&#8211;>" "-->")
		      ))
    (beginning-of-buffer)
    (while (re-search-forward (car from-to) nil t)
      (replace-match (cadr from-to))
      )  ; while
    )  ; dolist
  )  ; defun markup-to-entity
