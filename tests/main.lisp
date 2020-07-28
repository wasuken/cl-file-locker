(defpackage cl-file-locker/tests/main
  (:use :cl
        :cl-file-locker
        :rove))
(in-package :cl-file-locker/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-file-locker)' in your Lisp.
(setf *current* (intern (package-name *package*) :keyword))

(deftest base-tests
	(testing "定義されているか確認。"
			 (cl-file-locker:define-operations *current* '((contents)))
			 (ok (symbol-function 'cl-file-locker::lock))
			 (ok (symbol-function 'cl-file-locker::unlock))
			 (ok (symbol-function 'cl-file-locker::to-string))
			 )
  (testing "軽く動かす。"
		   (cl-file-locker:define-operations *current* '((contents)))
		   (ok (eq :SUCCESS_LOCK
				   (car (cl-file-locker::lock "../.gitignore"
											  :LOCKING
											  "(select :table)"))))
		   (ok (eq :ALREADY_LOCKED
				   (car (cl-file-locker::lock "../.gitignore"
											  :LOCKING
											  "(select :table)"))))
		   (ok (string= (string-downcase "path:../.gitignore,status:LOCKING,contents:(select :table)")
						(string-downcase (cl-file-locker::to-string
										  (cdr (cl-file-locker::lock "../.gitignore"
																	 :LOCKING
																	 "(select :table)"))))))
		   (ok (eq :SUCCESS_UNLOCK
				   (car (cl-file-locker::unlock "../.gitignore")))))
  )
