; Script version is 0.1.1

(defvar *quicklisp-install-path* ".quicklisp")

(defun require-quicklisp (&key version) 
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

  (setf (fdefinition  'dist) (fdefinition (intern "DIST" "QL-DIST")))
  (setf (fdefinition  'available-versions) (fdefinition (intern "AVAILABLE-VERSIONS" "QL-DIST")))
  (setf (fdefinition  'enabled-dists) (fdefinition (intern "ENABLED-DISTS" "QL-DIST")))
  (setf (fdefinition  'version) (fdefinition (intern "VERSION" "QL-DIST")))
  (setf (fdefinition  'install-dist) (fdefinition (intern "INSTALL-DIST" "QL-DIST")))

  (flet ((available-version-p (version)
           (find version (mapcar #'version (enabled-dists)) :test #'string=))) 

    (let* ((available-versions (available-versions (dist "quicklisp")))
           (version-distinfo-url (cdr (assoc version available-versions :test #'string=))))
      (unless (available-version-p version)
        (format t "Installing dist version ~A~%" version)
        (install-dist version-distinfo-url :replace t :prompt nil))))) 

(let ((version-file ".quicklisp-version"))
  (when (probe-file version-file)
    (require-quicklisp 
      :version (with-open-file 
                 (in version-file :direction :input)
                 (read in))))) 
