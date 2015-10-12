;;; wrapper.lisp --- Wrappers around the standard API

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


(defun format (destination format-control &rest args)
  "Wrapper around the standard FORMAT function.
When FORMAT-CONTROL is a string, it is interpreted according to the current
format table."
  (when (stringp format-control)
    (setq format-control (standard-format-string format-control)))
  (apply #'cl:format destination format-control args))

(defmacro formatter (format-string)
  "Wrapper around the standard FORMATTER macro.
FORMAT-STRING is interpreted according to the current format table."
  `(cl:formatter (standard-format-string ,format-string)))

;;; wrapper.lisp ends here
