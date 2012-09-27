(define-derived-mode ebnf-mode
  fundamental-mode
  "ebnf-mode"
  "ebnf-mode is simple mode for Extended Backus-Naur Form."
  (set (make-local-variable 'font-lock-defaults) '((("^\\([^=\n]*\\\)=" 1 font-lock-keyword-face)
						    ("\\?[^\\?]+\\?" . font-lock-constant-face))))
  (set (make-local-variable 'comment-start) "(*")
  (set (make-local-variable 'comment-end)   "*)")
  (set (make-local-variable 'indent-line-function) 'ebnf-indent-line) 
  (modify-syntax-entry ?' "|")
  (modify-syntax-entry ?\( ". 1")
  (modify-syntax-entry ?\) ". 4")
  (modify-syntax-entry ?* ". 23"))

(defun ebnf-indent-line ()
  "Indent current line as EBNF"
  (interactive)
  (save-excursion
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)
    (let ((indentation (save-excursion (forward-line -1)
				       (current-indentation)))
	  (byeq nil))
      (if (zerop indentation) 
	  (save-excursion (forward-line -1)
			  (beginning-of-line)
			  (search-forward "=" nil t)
			  (setq byeq t)
			  (setq indentation (- (point) (line-beginning-position) 1))))

      (if (looking-at "^[ \t]*|")
	  (indent-line-to indentation)
	(and (save-excursion
	       (forward-line -1)
	       (end-of-line)
	       (looking-back ",[ \t]*\\((\\*.*\\*)\\)?$"))
	     (indent-line-to (+ indentation (if byeq 2 0)))))))))
  
      


(add-to-list 'auto-mode-alist '("\\.ebnf\\'" . ebnf-mode))

(provide 'ebnf-mode)  
  