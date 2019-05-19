(asdf:load-system :cl-markless-plump)
(asdf:load-system :clip)

(defvar *here* (make-pathname :name NIL :type NIL
                              :defaults #.(or *load-pathname*
                                              (error "Please simply LOAD this file."))))

(defun file (name type)
  (make-pathname :name name :type type :defaults *here*))

(clip:define-tag-processor "main" (node)
  (cl-markless:output (file "specification" "mess")
                      :target node :format 'cl-markless-plump:plump))

(defun run (&key (input (file "template" "ctml"))
                 (output (file "index" "html")))
  (with-open-file (output output :direction :output
                                 :if-exists :supersede)
    (plump:serialize (clip:process input) output)))

(run)
