(global-set-key "\C-o" 'copy-region-as-kill)
(transient-mark-mode 1)

(add-to-list 'load-path "/usr/local/go/misc/emacs")
(require 'go-mode-load)
(setq gofmt-command "/usr/local/go/bin/gofmt")

(add-hook 'before-save-hook #'gofmt-before-save)

(defun camelize-string (s)
      "Convert under_score string S to CamelCase string."
      (let* ((words (split-string s "_")))
	(if (<= (length words) 1)
	    s
	  (mapconcat 'identity (mapcar
				'(lambda (word) (capitalize (downcase word)))
				words) ""))))

(defun camelize-at-point ()
  "Convert underscore_case to CamelCase for the symbol at point."
  (interactive)
  (save-excursion
    (let* ((bounds (bounds-of-thing-at-point 'symbol))
	 (start (car bounds))
	 (end (cdr bounds))
	 (buf (current-buffer))
	 (repl))
      (setq repl (camelize-string (buffer-substring start end)))
      (delete-region start end)
      (goto-char start)
      (insert repl))))
(global-set-key (kbd "C-M-u") 'underscore-to-camel)

(defun camelize-region (start end)
  "Camelize the whole region."
  (interactive "r")
  (save-excursion
    (let* ((start (region-beginning))
	   (end (region-end))
	   (buf (current-buffer))
	   (repl))
      (message "start %d end %d" start end)
      (setq repl
	    (with-temp-buffer
	      (insert-buffer-substring buf start end)
	      (goto-char (point-min))
	      (forward-word)
	      (while (< (point) (point-max))
		(progn
		  (camelize-at-point)
		  (forward-word)
		  (forward-word)))
	      (buffer-string)))
      (delete-region start end)
      (goto-char start)
      (insert repl))))
