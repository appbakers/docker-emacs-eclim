(require 'cl)
(require 'eclim)

(setq eclimd-autostart t)
(global-eclim-mode)
(custom-set-variables
  '(eclim-eclipse-dirs '("/home/docker/eclipse"))
  '(eclim-executable "/home/docker/eclipse/eclim")
  '(eclimd-default-workspace "/home/docker/workspace"))


;; Display compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)


;; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(require 'ac-emacs-eclim)
(ac-emacs-eclim-config)
(ac-set-trigger-key "TAB")
(define-key ac-complete-mode-map (kbd "C-n") 'ac-next)
(define-key ac-complete-mode-map (kbd "C-p") 'ac-previous)
(defun my-java-mode-hook ()
	(eclim-mode t))
(add-hook 'java-mode-hook 'my-java-mode-hook)


;; company
(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

;; eclim shortcut key like eclipse
(define-key eclim-mode-map (kbd "C-c C-e ,") 'eclim-problems-prev-same-file)
(define-key eclim-mode-map (kbd "C-c C-e .") 'eclim-problems-next-same-file)
(define-key eclim-mode-map (kbd "C-c C-e 1") 'eclim-problems-correct)


;; Eclipse Outline
(add-hook 'java-mode-hook 'semantic-mode)

;; Eclipse Outline fuzzy matching
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match t)

