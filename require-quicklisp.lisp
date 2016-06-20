; Script version is 0.2.2

(defvar *quicklisp-install-path* (make-pathname :directory '(:relative ".quicklisp")))

(declaim #+sbcl(sb-ext:muffle-conditions style-warning))

(defun require-quicklisp (&key (version :latest)) 
  (let ((quicklisp-setup-file 
          (merge-pathnames 
            (parse-namestring "setup.lisp")
            *quicklisp-install-path*)))
    (or 
      (progn 
        (format t "Trying to load quicklisp~%")
        (when (probe-file quicklisp-setup-file)
          (load quicklisp-setup-file)))
      (progn 
        (format t "It seems like quicklisp is not installed~%")
        (format t "Trying to install quicklisp~%")
        (let ((*standard-output* (make-string-output-stream)))
          (load ".quicklisp-install/quicklisp.lisp"))
        (format t "Installer loaded~%")
        (prog1 
          (funcall (eval `(function ,(intern "INSTALL" "QUICKLISP-QUICKSTART"))) :path *quicklisp-install-path*)
          (format t "Quicklisp installed~%"))))) 

  (setf (fdefinition  'dist) (fdefinition (intern "DIST" "QL-DIST")))
  (setf (fdefinition  'available-versions) (fdefinition (intern "AVAILABLE-VERSIONS" "QL-DIST")))
  (setf (fdefinition  'enabled-dists) (fdefinition (intern "ENABLED-DISTS" "QL-DIST")))
  (setf (fdefinition  'version) (fdefinition (intern "VERSION" "QL-DIST")))
  (setf (fdefinition  'install-dist) (fdefinition (intern "INSTALL-DIST" "QL-DIST")))

  (flet ((enabled-version-p (version)
           (find version (mapcar #'version (enabled-dists)) :test #'string=))) 

    (let* ((available-versions (available-versions (dist "quicklisp")))
           (version-distinfo-url))

      (when (eq version :latest)
        (setf version (caar available-versions)))

      (setf version-distinfo-url (cdr (assoc version available-versions :test #'string=)))

      (unless (find version available-versions :key #'car :test #'string=)
        (error "Version ~a is not available. Use one of ~a, see (ql-dist:available-versions (ql-dist:dist \"quicklisp\"))" version (mapcar #'car available-versions)))

      (unless (enabled-version-p version)
        (format t "Installing dist version ~A~%" version)
        (install-dist version-distinfo-url :replace t :prompt nil)))))

(declaim #+sbcl(sb-ext:unmuffle-conditions style-warning))

(let ((version-file (parse-namestring ".quicklisp-version")))
  (when (probe-file version-file)
    (require-quicklisp 
      :version (with-open-file 
                 (in version-file :direction :input)
                 (read in))))) 
