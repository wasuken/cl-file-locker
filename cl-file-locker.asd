(defsystem "cl-file-locker"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("mylib")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cl-file-locker/tests"))))

(defsystem "cl-file-locker/tests"
  :author ""
  :license ""
  :depends-on ("cl-file-locker"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-file-locker"
  :perform (test-op (op c) (symbol-call :rove :run c)))
