
;;Document filler
(defun start_sheet (title subject) (format t "

\\documentclass[12pt]{article} % Specifies font size
\\usepackage[margin=1in]{geometry} % Sets all four margins to 1 inch
\\usepackage{amssymb} % Access to extra math symbols
\\usepackage{amsmath} % Access to extra math symbols
\\pagestyle{empty} % Ensures that no page numbers are printed
\\parskip = 0.2 in % Puts a little space between paragraphs 
\\parindent = 0.0 in % Enforces no indentation for paragraphs

\\begin{document}

\\begin{center}
  \\textsc{\\large{~a}} \\\\
  ~a, St. Joseph's School
\\end{center}

Date = \\underline{\\hspace*{4cm}} \\hfill
Name = \\underline{\\hspace*{4cm}}
\\newline
" title subject)
)

(defun end_sheet () (format t "
\\end{document}
"))

(defun begin_prob (&optional (size 0.5))
	(format t "\\begin{minipage}[t]{~a\\textwidth} \\textbf{~d) }~%" 
		size (setf count (+ count 1)))
)
(defun end_prob ()
	(format t "\\end{minipage}~%")
)
(defun make_sec (tagline)
	(format t "\\newline ~%\\vspace{1cm} ~%\\textbf{Section ~d} ~%\\textit{~a}~%\\newline~%" 
				sec_count tagline)
	(setf sec_count (+ sec_count 1))
)
;; Utilities________________________________________
(defun nshuffle (sequence)
  (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
                    (elt sequence (1- i))))
  sequence)

(defun texify (expr)
	"Return a string that is a latex representation of +-*/"
(let ((lstring (format nil ""))
		(opp (first expr)))
	(if (listp (second expr)) 
		(setf lstring (concatenate 'string lstring "( " (texify (second expr))))
		(setf lstring (concatenate 'string lstring "( " (latnum (second expr))))
	)
	(cond 
		((eql opp '/) 
			(setf lstring (concatenate 'string  lstring (format nil " \\div "))))
		(t (setf lstring (concatenate 'string lstring (format nil " ~a " opp))))
	)
	(if (listp (third expr)) 
		(setf lstring (concatenate 'string lstring (texify (third expr)) ") "))
		(setf lstring (concatenate 'string lstring (latnum (third expr)) ") "))
	)
	(return-from texify lstring)

))
(defun latnum (num)
	"converts fractions to latex form"
	(if (integerp num) (return-from latnum (format nil "~a" num) )
		(format nil "\\frac{~d}{~d}" (numerator num) (denominator num))
	)
)

(defun expand (expr)
	"Expand a number in an equivalent calculation"
	(when (numberp expr)
		(return-from expand (make_bigger expr)))
	(let ((choice (+ (random (- (length expr) 1)) 1)))
	(cond
		((numberp (nth choice expr))
			(setf value (replace expr 
							(list (make_bigger (nth choice expr))) 
							:start1 choice :end1 (+ 1 choice)))
			(return-from expand value))
		((listp (nth choice expr))
			(setf value (replace expr 
							(list (expand (nth choice expr))) 
							:start1 choice :end1 (+ 1 choice)))
			(return-from expand value))
		(t (format t "Expand was given '~a' as an argument, and doesn't
						know what to do!~%" (nth choice expr))) )
))

(defun make_bigger (num) ;; to be called on a number
(let ( (protype (random 4)) ;add, sub, mult, div
		(newnum (- (random 100) 40)) )
	(when (= newnum 0) (setf newnum 1))
	(cond 
		((= protype 0) ;; addition
			(return-from make_bigger (list '+ newnum (- num newnum))))
		((= protype 1) ;; subtraction
			(return-from make_bigger (list '- (+ newnum num) newnum))) 
		((= protype 2) ;; multiplication
			(return-from make_bigger (list '* (/ num newnum) newnum)))
		((= protype 3) ;; division
			(return-from make_bigger (list '/ (* newnum num) newnum)))
	)
))

(defun expression_prob (step_num)
	(let ((seed (random (- 30 10))))
	(loop repeat step_num do
		(setf seed (expand seed))	
	)
	(format t "$ ~a $~%" (texify seed))
))

(defun expon_prod (&optional (protype 0)) 
	(case protype
		;; Default is random operation
		(0 (expon_prob (+ 3 (random 2))) ) ;; just using times and div for now
		;; 1-add 2-sub 3-mult 4-div
		(t (format t "$ ~a ~a ~a = $~%" 
			(rand_exp (setf rand_base (random 20)))
			(nth protype '("^" "+" "-" "\\times" "\\div"))
			(rand_exp rand_base)))
))
(defun expon_nest ()
	(format t "$ ~a $~%" (rand_exp (rand_paren (rand_exp (random 10)))))
)
(defun rand_exp (&optional (base (rand_thing)))
	(format nil "~d^{~d}" base (- (random 16) 6))
)
(defun rand_thing ()
(let ((choice (random 3)))
	(case choice
		(0 (- (random 200) 100))
		(1 (latnum (rand_rat)))
		(2 (texify (make_bigger (random 10)))))
))

(defun rand_paren (thing)
"Adds a layer of parenthesis, or doesn't"
(let ((choice (random 2)))
	(if (= choice 0) 
		(format nil "( ~a )" thing)
		thing)
))

(defun prop_prob () 
( let ((args (mapcar #'eval '((1+ (random 30)) (1+ (random 15)) (1+ (random 10))
					(nth (random (length chars)) chars))) ))
	(nshuffle args)
	(begin_prob)
	(format t " $ \\frac{~d}{~d} = \\frac{~d}{~d} $ ~%" 
		(first args) (second args) (third args) (fourth args) ) 
	(end_prob)
))

(defun percent_prob () ;; someday, have type as argument
(let ( (percent (random 101))
		(part (1+ (random 50)))
		(whole (1+ (random 200)))
		(protype (random 3)) )

	(begin_prob)
	(cond 
		((= protype 0)
			(format t " ~d is ~d percent of what number? ~%" part percent) )
		((= protype 1)
			(format t " What is ~d percent of ~d? ~%" percent whole))
		((= protype 2)
			(format t " What percent is ~d out of ~d ~%" part whole))
	) ;cond
	(end_prob)
))

(defun sci_not_prob (&optional (protype 0))
	(case protype
		;; Default is random operation
		(0 (sci_not_prob (+ 1 (random 4))) )
		;; 1-add 2-sub 3-mult 4-div
		(t (format t "$ ~d \\times 10^{~d} ~a ~d \\times 10^{~d} = $~%" 
			(/ (random 999) 100.0) 
			(setf expon (- (random 20) 10)) 
			(nth protype '("^" "+" "-" "\\times" "\\div"))
			(/ (random 999) 100.0) 
			(+ expon (- (random 5) 2))) )
))

(defun integer_op_prob (&optional (protype 0))
	(case protype
		;; Default is random operation
		(0 (integer_op_prob (+ 1 (random 4))) )
		;; 1-add 2-sub 3-mult 4-div
		(t (format t "$ (~d) ~a (~d) = $~%" 
			(- (random 100) 50) 
			(nth protype '("^" "+" "-" "\\times" "\\div"))
			(- (random 100) 50) ))
))

(defun compound_frac_prob (&optional (protype 0))
(case protype
	(0 (compound_frac_prob (+ 1 (random 2))))
	(1 (format t "\\large{ $\\frac{~a}{~a} $ }" 
			(latnum (rand_rat)) 
			(latnum (rand_rat))) )
	(2 (format t "$ ~a \\div ~a$"
			(latnum (rand_rat)) 
			(latnum (rand_rat))))
))

(defun rand_rat (&optional (pos 0))
(let ((num 0))
	(if (= pos 0) 
		(setf num (/ (- (random 100) 20) (+ 1 (random 20))))
		(setf num (/ (random 60) (+ 1 (random 20)))) )
	(if (integerp num)
		(rand_rat pos)
		num)
))

(defun testfrac (protype)
	(format t "$ (~a) ~a (~a) = $~%" 
		(latnum (rand_rat))
		(nth protype '("^" "+" "-" "\\times" "\\div"))
		(latnum (rand_rat)))
)

(defun fraction_op_prob (&optional (protype 0))
	;; Default is random operation
	(when (= protype 0) (setf protype (+ 1 (random 4))))
	;; 1-add 2-sub 3-mult 4-div
	(format nil "large{ ~a }" (testfrac protype))
)

(defun conver_prob (&optional (protype 0))
	;; protype: 0=rand, 1=rate conver, 2=unidimensional
	(format t "$~a ~a $ into $ ~a$" (latnum (rand_rat)) "\\frac{mi}{hr}" "\\frac{ft}{sec}")

)

