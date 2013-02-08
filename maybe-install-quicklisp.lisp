; Script version is 0.1.0

(defvar *quicklisp-install-path* ".quicklisp")

(or 
  (progn 
    (format t "Trying to load quicklisp~%")
    (ignore-errors (load (format nil "~A/setup.lisp" *quicklisp-install-path*))))
  (progn 
    (format t "It seems like quicklisp is not installed~%")
    (format t "Trying to install quicklisp~%")
    (let ((*standard-output* (make-string-output-stream)))
      (load ".quicklisp-install/quicklisp.lisp"))
    (format t "Installer loaded~%")
    (prog1 
      (funcall (eval `(function ,(intern "INSTALL" "QUICKLISP-QUICKSTART"))) :path (format nil "~A/ "*quicklisp-install-path*))
      (format t "Quicklisp installed~%"))))

(use-package :ql-dist)

(defun available-version-p (version)
  (find version (mapcar #'version (enabled-dists)) :test #'string=))

(let* ((available-versions (available-versions (dist "quicklisp")))
       (version (with-open-file (in ".quicklisp-install/quicklisp-version" :direction :input) (read in)))
       (version-distinfo-url (cdr (assoc version available-versions :test #'string=))))
  (unless (available-version-p version)
    (format t "Installing dist version ~A~%" version)
    (install-dist version-distinfo-url :replace t :prompt nil)))
