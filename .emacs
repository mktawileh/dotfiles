(package-initialize)

;; TODO: put this code in a seperate file
;; ---------------------------------------------- ;;
(defvar rc/package-contents-refreshed nil)
(load-theme 'gruber-darker)

(defun rc/package-refresh-contents-once ()
  (when (not rc/package-contents-refreshed)
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (when (not (package-installed-p package))
    (rc/package-refresh-contents-once)
    (package-install package)))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))
;; ---------------------------------------------- ;;


(defun font-available-p (font-name)
  (find-font (font-spec :name font-name)))

;; ---------------------------------------------- ;;


(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(setq-default inhibit-splash-screen t
              make-backup-files nil
              tab-width 4
              indent-tabs-mode nil
              compilation-scroll-output t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(ido-mode 1)
(cond ((font-available-p "Ubuntu Mono")
       (set-frame-font "Ubuntu Mono-16")))
(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; ansi-color
(rc/require 'ansi-color)

;; Company
(rc/require 'company)
(global-company-mode)

;; (setq company-idle-delay nil)

;; magit
;; magit requres this lib, but it is not installed automatically on
;; Windows.
(rc/require 'cl-lib)
(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;;; Syntax subword
(rc/require 'syntax-subword)
(global-syntax-subword-mode)
(setq syntax-subword-skip-spaces t)


;;; Misc
;; Stolen from https://github.com/rexim/dotfiles/blob/master/.emacs.rc/misc-rc.el
(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))
(global-set-key (kbd "C-,") 'rc/duplicate-line)

;;; Move text
(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;;; Comment or uncomment a region
(defun toggle-comment-line-or-region ()
  "Toggle comment on the current line or region."
  (interactive)
  (if (use-region-p)
      (let ((start (region-beginning))
            (end (region-end)))
        (save-excursion
          (goto-char start)
          (beginning-of-line)
          (setq start (point))
          (goto-char end)
          (end-of-line)
          (setq end (point)))
        (comment-or-uncomment-region start end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position)
                                 )))
(global-set-key (kbd "C-;") 'toggle-comment-line-or-region)

;;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

(global-display-line-numbers-mode)

;; (set-frame-font "Ubuntu Mono-15" nil t)

;;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

;; (add-hook 'after-change-major-mode-hook 'rc/set-up-whitespace-handling)

;;; Tide
(rc/require 'tide)

(defun rc/turn-on-tide ()
  (interactive)
  (tide-setup))

(add-hook 'typescript-mode-hook 'rc/turn-on-tide)

;;; Packages that don't require configuration
(rc/require
 'typescript-mode
 'markdown-mode
 )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages
   '(markdown-mode typescript-mode tide syntax-subword smex multiple-cursors move-text magit gruber-darker-theme company))
 '(whitespace-style
   '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
