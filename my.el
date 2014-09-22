(global-set-key "\C-o" 'copy-region-as-kill)
(transient-mark-mode 1)

(add-to-list 'load-path "/usr/local/go/misc/emacs")
(require 'go-mode-load)
(setq gofmt-command "/usr/local/go/bin/gofmt")

(add-hook 'before-save-hook #'gofmt-before-save)

(defun underscore-to-camel ()
  "Convert underscore_case to CamelCase for the symbol at point."
  (interactive)
  (save-excursion
    (let* 
	((bounds (bounds-of-thing-at-point 'symbol))
	 (start (car bounds))
	 (end (cdr bounds))
	 (buf (current-buffer))
	 (out 
	  (with-temp-buffer
	    (insert-buffer-substring buf start end)
	    (downcase-region (point-min) (point-max))
	    (let* ((x (point-min)))
	      (while (/= x (point-max))
		(if (or (= x (point-min))
			(= (char-before x) ?_))
		    (upcase-region x (+ x 1)))
		(setq x (1+ x))))
	     (replace-string "_" "" nil (point-min) (point-max))
	     (buffer-string))))
      (delete-region start end)
      (goto-char start)
      (insert out))))
(global-set-key (kbd "C-M-u") 'underscore-to-camel)
