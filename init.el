
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

(require 'org)

(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

(setq org-directory "~/org")
(setq org-agenda-files '("~/org"))
(setq org-default-notes-file (concat org-directory "/notes.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (ox-reveal academic-phrases gnuplot gnuplot-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((gnuplot . t)))
;; add additional languages with '((language . t)))

;; Org to display inline images by default:
(setq org-display-inline-images t)
(setq org-redisplay-inline-images t)
(setq org-startup-with-inline-images "inlineimages")
(setq org-log-done t)

;; Babel to update inline images on execution
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;; Reveal.js + Org mode
;; via https://opensource.com/article/18/2/how-create-slides-emacs-org-mode-and-revealjs
(require 'ox-reveal)
(setq org-reveal-root "file:///home/tom/reveal.js")
(setq org-reveal-title-slide nil)


(put 'downcase-region 'disabled nil)
