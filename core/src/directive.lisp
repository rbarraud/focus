;;; directive.lisp --- Format directives management

;; Copyright (C) 2015 Didier Verna

;; Author: Didier Verna <didier@didierverna.net>

;; This file is part of FoCus.

;; Permission to use, copy, modify, and distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.

;; THIS SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


;;; Commentary:



;;; Code:

(in-package :net.didierverna.focus)
(in-readtable :net.didierverna.focus)


;; ==========================================================================
;; Directive Data Structure
;; ==========================================================================

(defstruct format-directive "Base structure for format directives.")



;; ==========================================================================
;; Standard Directives
;; ==========================================================================

(defstruct (standard-directive
	    (:include format-directive)
	    (:conc-name directive-))
  "Base structure for standard directives.
This structure holds the (upcase) directive character."
  (character nil :type character :read-only t))

(defstruct (standard-delimiting-directive
	    (:include standard-directive)
	    (:conc-name directive-))
  "Structure for standard delimiting directives.")

(defstruct (standard-opening-directive
	    (:include standard-directive)
	    (:conc-name directive-))
  "Structure for standard opening directives.
This structure holds the corresponding (upcase) closing character."
  (closing-character nil :type character :read-only t))

(defstruct (standard-closing-directive
	    (:include standard-directive)
	    (:conc-name directive-))
  "Structure for standard closing directives.
This structure holds the corresponding (upcase) opening character."
  (opening-character nil :type character :read-only t))

(defparameter *standard-directives*
  (nconc (mapcar (lambda (character)
		   (make-standard-directive :character character))
		 '(#\C #\% #\& #\| #\~ #\R #\D #\B #\O #\X #\F #\E #\G #\$ #\A
		   #\S #\W #\_ #\I #\T #\* #\? #\P #\; #\^ #\Newline))
	 (list (make-standard-delimiting-directive :character #\/))
	 (mapcan (lambda (opening-character closing-character)
		   (list (make-standard-opening-directive
			  :character opening-character
			  :closing-character closing-character)
			 (make-standard-closing-directive
			  :character closing-character
			  :opening-character opening-character)))
		 '(#\< #\[ #\{ #\()
		 '(#\> #\] #\} #\))))
  "The list of standard format directives.")


;; -------------------------
;; Standard directive lookup
;; -------------------------

;; #### NOTE: this is pedantic since we only have one sub-condition...
(define-condition standard-directive-lookup-error (focus-error)
  ()
  (:documentation "A standard directive lookup error."))

(define-condition nonstandard-directive-character
    (standard-directive-lookup-error)
  ((character :documentation "The character."
	      :initarg :character
	      ;; The lack of polymorphism on standard functions sucks. I want
	      ;; to use just CHARACTER here.
	      :reader nonstandard-directive-character))
  (:report (lambda (error stream)
	     (cl:format stream "~S: nonstandard directive character ."
		(nonstandard-directive-character error))))
  (:documentation "A nonstandard directive character error."))

(defun find-standard-directive
    (character &aux (character (char-upcase character))
		    (directive (find character *standard-directives*
				     :test #'char=
				     :key #'directive-character)))
  "Return the standard directive corresponding to CHARACTER.
Throw a NONSTANDARD-DIRECTIVE-CHARACTER error otherwise."
  (unless directive
    (error 'nonstandard-directive-character :character character))
  directive)



;; ==========================================================================
;; User Directives
;; ==========================================================================

(defstruct (function-directive
	    (:include format-directive)
	    (:conc-name directive-))
  "Structure for user-defined function directives.
This structure holds the associated function name."
  (function-name nil :type symbol))

;;; directive.lisp ends here
