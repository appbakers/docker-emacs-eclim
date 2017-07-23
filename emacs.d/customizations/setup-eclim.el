(require 'eclim)

(setq eclimd-autostart t)
(custom-set-variables
	'(eclim-eclipse-dirs '("~/eclipse"))
	'(eclim-executable "~/eclipse/eclim"))

(defun my-java-mode-hook ()
	(eclim-mode t))
(add-hook 'java-mode-hook 'my-java-mode-hook)


(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

(require 'auto-complete-config)
(ac-config-default)

(require 'ac-emacs-eclim)
(ac-emacs-eclim-config)


(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

