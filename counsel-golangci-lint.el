;;; counsel-golangci-lint.el --- golangci-lint with ivy -*- lexical-binding: t; -*-

;;; Commentary:
;; golangci-lint with ivy

;;; Code:

(require 'ivy)
(require 'counsel)

(defvar counsel-golangci-lint-history nil
  "History for `counsel-golangci-lint'.")

(defvar counsel-golangci-lint-cmd "LOG_LEVEL=error golangci-lint run --print-issued-lines=false --out-format=line-number ./..."
  "Command for `counsel-golangci-lint'.")

(defun counsel--go-root ()
  "Find go mod root."
  (expand-file-name (shell-command-to-string "dirname $(go env GOMOD)")))

(defun counsel-golangci-lint-cands ()
  "Call `golangci-lint'."
  (string-split (shell-command-to-string counsel-golangci-lint-cmd) "\n"))



;;;###autoload
(defun counsel-golangci-lint ()
  "Counsel interface for golangci-lint."
  (interactive)
  (let ((default-directory (or (counsel--git-root)
			       (counsel--go-root)
			       default-directory)))
    (ivy-read "golangci-lint: "
	      (counsel-golangci-lint-cands)
	      :action #'counsel-git-grep-action
	      :history 'counsel-golangci-lint-history
	      :caller 'counsel-golangci-lint)))

(ivy-configure 'counsel-golangci-lint
  :display-transformer-fn #'counsel-git-grep-transformer
  :unwind-fn #'swiper--cleanup)
	    


(provide 'counsel-golangci-lint)

;;; counsel-golangci-lint.el ends here
