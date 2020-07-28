(defpackage cl-file-locker
  (:use :cl)
  (:export :define-operations))
(in-package :cl-file-locker)

(defparameter *file-lock-management-book* (make-hash-table :test #'equal))
(defparameter *action-log-path* "./action.log")

;;; util行き候補。
(defun define-kv ()
  (let ((default '()))
	(loop for x in '((hash-table-keys . k) (hash-table-values . v))
	   do (eval `(defun ,(car x) (table)
				   (let ((lst ,default))
					 (maphash #'(lambda (k v) (setf lst (append lst (list ,(cdr x))))) table)
					 lst))))))

(define-kv)

(defparameter *gen-id-f* #'(lambda (x) (1+ (apply #'max (keys table)))))

;;; util行き候補。
(defun interleave (a b &optional phase)
  (cond ((and (null a) (null b)) nil)
		((not a) b)
		((not b) a)
		((or a b)
		 (if phase
			 `(,(car b) ,@(interleave a (cdr b) (not phase)))
			 `(,(car a) ,@(interleave (cdr a) b (not phase)))))))

(defun book-detail-log-write (path bd)
  (with-open-file (s path :direction :output)
	(format s "~a~%" (to-string bd))))

;;; たくさん書き込むならこっちの方が早いかもしれない。
(defun book-detail-logs-bulk-write (path bd-lst)
  (with-open-file (s path :direction :output)
	(format s "~{~a~%~}" (mapcar #'to-string bd-lst))))

;;; 再定義しようとする(define-operations実効2回目以降)と、落ちる。
;;; 再定義前提なら関数を返却する手法に切り替える。
(defun define-operations (params)
  (let ((names (append  '(path status) (mapcar #'car params))))
	(fmakunbound 'make-book-detail)
	(makunbound 'book-detail)
	(eval `(defstruct book-detail
			 ,@(mapcar #'(lambda (param)
						   (if (find :type param)
							   param
							   `(,(car param) "" :type string)))
					   (append '((path "" :type string)
								 (status :LOCKING :type keyword))
							   params))))
	(fmakunbound 'unlock)
	(eval `(defun unlock (path)
			 (if (gethash path *file-lock-management-book*)
				 (:UNLOCK . (remhash path *file-lock-management-book*))
				 (:NOT_LOCKED . path))
			 ))
	(fmakunbound 'lock)
	(eval `(defun lock ,names
			 (if (gethash path *file-lock-management-book*)
				 `(:ALREADY_LOCKED . ,(gethash path *file-lock-management-book*))
				 (let ((bd (make-book-detail
							,@(interleave (mapcar #'(lambda (x) (intern (symbol-name x) :keyword))
												  names)
										  names))))
				   (setf (gethash (slot-value bd 'path)
								  *file-lock-management-book*)
						 bd)
				   `(:SUCCESS_LOCK . bd)))
			 ))
	(fmakunbound 'to-string)
	(eval `(defun to-string (bd)
			 (format nil "~a,log-created:~a"
					 (format nil "~{~a~^,~}"
							 (mapcar #'(lambda (x)
										 (format nil
												 "~a:~a"
												 (intern (symbol-name x) :keyword)
												 (slot-value bd x)
												 ))
									 ',names))
					 ;; timestamp的な
					 (mylib:get-format-date))))
	))
