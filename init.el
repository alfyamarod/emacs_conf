;; -*- lexical-binding: t; -*-
(setenv "LSP_USE_PLISTS" "true") ;; in early-init.el

(setq read-process-output-max (* 10 1024 1024)) ;; 10mb
(setq gc-cons-threshold 200000000)

(setq visible-bell t)
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(tooltip-mode -1)
(load-theme 'tango-dark)
(electric-pair-mode 1)
(delete-selection-mode 1)
(set-fringe-mode 10)
(fset 'yes-or-no-p 'y-or-n-p)

(setq column-number-mode 1)
(setopt tab-always-indent 'complete)
					;(dolist (mode '(<<prog-modes-gen()>>))
					;  (add-hook mode #'hs-minor-mode))

;; Zoom
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key [C-wheel-up] 'text-scale-increase)
(global-set-key [C-wheel-down] 'text-scale-decrease)

(setq backup-directory-alist `(("." . ,(expand-file-name ".tmp/backups/"
                                                         user-emacs-directory)))
      tramp-backup-directory-alist `(("." . ,(expand-file-name ".tmp/tramp-backups/"
                                                               user-emacs-directory))))
(setq backup-by-copying t)
(setq delete-by-moving-to-trash t)
;;(add-to-list 'default-frame-alist '(alpha-background . 0.9))




(setq make-backup-files nil) 
;;font
(set-frame-font "JetBrainsMono Nerd Font 14" nil t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq c-default-style "linux"
      c-basic-offset 4
      indent-tabs-mode t
      fill-column 120
      tab-width 4
      )

;; Package sources
(require 'package)
(setq package-archives '(("melpa". "https://melpa.org/packages/")
			 ("org". "https://orgmode.org/elpa/")
			 ("elpa". "https://elpa.gnu.org/packages/")
			 ))

(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)


(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package all-the-icons)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package general
  :ensure t
  :config
  (general-evil-setup t)
  (general-create-definer alf/leader-keys
    :states '(normal insert visual emacs motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")
  (alf/leader-keys
    "w"  '(:ignore t :which-key "window")
    "w h" '(windmove-left :which-key "move left")
    "w j" '(windmove-down :which-key "move down")
    "w k" '(windmove-up :whic-key "move up")
    "w l" '(windmove-right :which-key "move right")
    "t t" '(treemacs :which-key "treemacs")
    ))


(use-package dumb-jump
  :ensure t
  :defer
  :custom
  (dumb-jump-prefer-searcher 'ag)
  (dumb-jump-force-searcher 'ag)
  (dumb-jump-selector 'completing-read)
  (dumb-jump-default-project "~/work")
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  )


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/work")
    (setq projectile-project-search-path '("~/work")))
  (setq projectile-switch-project-action #'projectile-dired)

  :general
  (alf/leader-keys
    "p" '(:keymap projectile-command-map :whic-key "projectile"))
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; hydra for temporary commands
(use-package hydra)


(use-package dabbrev
  :defer t
  :custom
  (dabbrev-upcase-means-case-search t)
  (dabbrev-check-all-buffers nil)
  (dabbrev-check-other-buffers t)
  (dabbrev-friend-buffer-function 'dabbrev--same-major-mode-p)
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))


(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                 ; Allows cycling through candidates
  (corfu-auto t)                  ; Enable auto completion
  (corfu-separator ?\s)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-preview-current 'insert) ; insert previewed candidate
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets
  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind (:map corfu-map
              ("M-SPC"      . corfu-insert-separator)
              ("TAB"        . corfu-next)
              ([tab]        . corfu-next)
              ("S-TAB"      . corfu-previous)
              ([backtab]    . corfu-previous)
              ("S-<return>" . corfu-insert)
              ("RET"        . nil))

  :init
  (global-corfu-mode)
  ;; TODO
  ;;(corfu-history-mode)
  ;;(corfu-popupinfo-mode) ; Popup completion info
  :config
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                                   corfu-quit-no-match t
                                   corfu-auto nil)
              (corfu-mode))
            nil
            t))


(use-package cape
  :ensure t
  :bind ("C-c SPC" . cape-dabbrev)
  :custom
  (cape-dict-case-replace nil)
  (cape-dabbrev-buffer-function 'cape-same-mode-buffers)

  :init
  (defun my/cape-dict-only-in-comments ()
    (cape-wrap-inside-comment 'cape-dict))

  (defun my/cape-dict-only-in-strings ()
    (cape-wrap-inside-string 'cape-dict))

  (defun my/cape-yasnippet-keyword-dabbrev ()
    (cape-wrap-super #'yasnippet-capf #'cape-keyword #'cape-dabbrev))

  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'my/cape-yasnippet-keyword-dabbrev)
  (add-to-list 'completion-at-point-functions #'my/cape-dict-only-in-strings)
  (add-to-list 'completion-at-point-functions #'my/cape-dict-only-in-comments))






(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (common-lisp "https://github.com/theHamsta/tree-sitter-commonlisp")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package yasnippet
  :ensure t
  :defer t
  :init
  (yas-global-mode)
  :hook((prog_mode . yas-minor-mode)
	(text-mode . yas-minor-mode)
	(fundamental-mode . yas-minor-mode)
	)
  )

(use-package yasnippet-snippets
  :defer t
  :after yasnippet
  )




(use-package yasnippet-capf
  :ensure t
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))


;; LATEX
(use-package auctex
  :defer t 
  :init
  (setq TeX-command-default   (if (executable-find "latexmk") "LatexMk" "LaTeX")
        TeX-engine            (if (executable-find "xetex")   'xetex    'default)
        TeX-auto-save                     t
        TeX-parse-self                    t
        TeX-syntactic-comment             t
        TeX-auto-local                    ".auctex-auto"
        TeX-style-local                   ".auctex-style"
        TeX-source-correlate-mode         t
        TeX-source-correlate-method       'synctex
        TeX-source-correlate-start-server nil
        TeX-electric-sub-and-superscript  t
        TeX-fill-break-at-separators      nil
        TeX-save-query                    t)
  :config
  (setq font-latex-match-reference-keywords
        '(;; BibLaTeX.
          ("printbibliography" "[{") ("addbibresource" "[{")
          ;; Standard commands.
          ("cite" "[{")       ("citep" "[{")
          ("citet" "[{")      ("Cite" "[{")
          ("parencite" "[{")  ("Parencite" "[{")
          ("footcite" "[{")   ("footcitetext" "[{")
          ;; Style-specific commands.
          ("textcite" "[{")   ("Textcite" "[{")
          ("smartcite" "[{")  ("Smartcite" "[{")
          ("cite*" "[{")      ("parencite*" "[{")
          ("supercite" "[{")
          ;; Qualified citation lists.
          ("cites" "[{")      ("Cites" "[{")
          ("parencites" "[{") ("Parencites" "[{")
          ("footcites" "[{")  ("footcitetexts" "[{")
          ("smartcites" "[{") ("Smartcites" "[{")
          ("textcites" "[{")  ("Textcites" "[{")
          ("supercites" "[{")
          ;; Style-independent commands.
          ("autocite" "[{")   ("Autocite" "[{")
          ("autocite*" "[{")  ("Autocite*" "[{")
          ("autocites" "[{")  ("Autocites" "[{")
          ;; Text commands.
          ("citeauthor" "[{") ("Citeauthor" "[{")
          ("citetitle" "[{")  ("citetitle*" "[{")
          ("citeyear" "[{")   ("citedate" "[{")
          ("citeurl" "[{")
          ;; Special commands.
          ("fullcite" "[{")
          ;; Cleveref.
          ("cref" "{")          ("Cref" "{")
          ("cpageref" "{")      ("Cpageref" "{")
          ("cpagerefrange" "{") ("Cpagerefrange" "{")
          ("crefrange" "{")     ("Crefrange" "{")
          ("labelcref" "{")))

  (setq font-latex-match-textual-keywords
        '(;; BibLaTeX brackets.
          ("parentext" "{") ("brackettext" "{")
          ("hybridblockquote" "[{")
          ;; Auxiliary commands.
          ("textelp" "{")   ("textelp*" "{")
          ("textins" "{")   ("textins*" "{")
          ;; Subcaption.
          ("subcaption" "[{")))

  (setq font-latex-match-variable-keywords
        '(;; Amsmath.
          ("numberwithin" "{")
          ;; Enumitem.
          ("setlist" "[{")     ("setlist*" "[{")
          ("newlist" "{")      ("renewlist" "{")
          ("setlistdepth" "{") ("restartlist" "{")
          ("crefname" "{")))
  (setq TeX-master t)
  (setcar (cdr (assoc "Check" TeX-command-list)) "chktex -v6 -H %s")
  (add-hook 'TeX-mode-hook (lambda ()
                             (setq ispell-parser          'tex
                                   fill-nobreak-predicate (cons #'texmathp fill-nobreak-predicate))))
  (add-hook 'TeX-mode-hook #'visual-line-mode)
  (add-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)
  :general
  ;; TODO
  (alf/major-leader-key
   :packages 'auctex
   :keymaps  '(latex-mode-map LaTeX-mode-map)
   "v" '(TeX-view            :which-key "View")
   "c" '(TeX-command-run-all :which-key "Compile")
   "m" '(TeX-command-master  :which-key "Run a command")))


(use-package tex-mode
  :defer t
  :config
  (setq LaTeX-section-hook '(LaTeX-section-heading
                             LaTeX-section-title
                             LaTeX-section-toc
                             LaTeX-section-section
                             LaTeX-section-label)
        LaTeX-fill-break-at-separators nil
        LaTeX-item-indent              0))

(use-package adaptive-wrap
  :defer t
  :after auctex
  :hook (LaTeX-mode . adaptative-wrap-prefix-mode)
  :init (setq-default adaptative-wrap-extra-indent 0))

(use-package auctex-latexmk
  :after auctex
  :defer t
  :init
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  (add-hook 'LaTeX-mode (lambda () (setq TeX-command-default "LatexMk")))
  :config

  ;; TODO 
  (auctex-latexmk-setup))



(use-package evil-nerd-commenter
  :after evil)

(use-package treemacs
  :defer t
  :init
  (setq treemacs-follow-after-init t
        treemacs-is-never-other-window nil
        treemacs-sorting 'alphabetic-case-insensitive-asc)

  :config
  (treemacs-follow-mode -1))


(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)


;; org

;; Syntax highlight in #+BEGIN_SRC blocks
(setq org-src-fontify-natively t)
;; Don't prompt before running code in org
(setq org-confirm-babel-evaluate nil)
(setq org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)
(setq org-highlight-latex-and-related '(native))
(setq org-startup-with-inline-images t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "BROKEN(b)" "RUNNING(r)" "VERIFY(v)" "URGENT(u)" "PARTIAL(p)"
                  "|" "DONE(d)" "OPTIONAL(o)" "DELEGATED(e)" "IRRELEVANT(i)")))
(setq org-todo-keyword-faces
      '(("BROKEN" . "red") ("RUNNING" . "yellow")
        ("VERIFY" . "light goldenrod") ("URGENT" . "orange") ("PARTIAL" . "burlywood")
        ("OPTIONAL" . "green") ("IRRELEVANT" . "LightBlue1")
        ("DELEGATED" . "aquamarine3")))
(setq org-src-window-setup 'current-window)

(use-package geiser
  :defer t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)
   (emacs-lisp . t)
   (scheme . t)
   (latex . t)
   (python . t)
   (shell . t)
   )
 )

(use-package org-ref)
(require 'bibtex)

(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "-"
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)

(define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-entry-menu)

(setq bibtex-completion-bibliography '("~/Documents/bibliography/references.bib"
				       "~/Documents/bibliography/master.bib"
				       "~/Documents/bibliography/archive.bib")
      bibtex-completion-library-path '("~/Documents/bibliography/bibtex-pdfs/")
      bibtex-completion-notes-path "~/Documents/notes/"
      bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"

      bibtex-completion-additional-search-fields '(keywords)
      bibtex-completion-display-formats
      '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	(inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	(incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	(inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	(t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
      bibtex-completion-pdf-open-function
      (lambda (fpath)
	(call-process "open" nil 0 nil fpath)))

(define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
(setq org-ref-show-equation-images-in-tooltips t)

(use-package org-superstar
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))


(add-hook 'org-mode-hook 'org-indent-mode)
;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)
(add-hook 'org-mode-hook 'visual-line-mode)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

(use-package corg
  :vc (:url "https://github.com/isamert/corg.el"))

(use-package apheleia
  :ensure t
  :diminish ""
  :defines
  apheleia-formatters
  apheleia-mode-alist
  :functions
  apheleia-global-mode
  :config
  (setf (alist-get 'prettier-json apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))
  (apheleia-global-mode +1))

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode t)

  ;; Set correct Python interpreter
  (setq pyvenv-post-activate-hooks
        (list (lambda ()
                (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))))
  (setq pyvenv-post-deactivate-hooks
        (list (lambda ()
                (setq python-shell-interpreter "python3")))))

(use-package hl-todo
  :config
  (global-hl-todo-mode)
  (setq hl-todo-keyword-faces
	'(("TODO"   . "#FF0000")
          ("FIXME"  . "#FF0000")
          ("DEBUG"  . "#A020F0")
	  ("NOTE"  . "#00FF32")
	  )
	)
  )

;;; jupyter
(use-package
  jupyter)

;;; code cells
(use-package code-cells
  :init
  (add-hook 'python-mode-hook 'code-cells-mode-maybe)
  :config
  (let ((map code-cells-mode-map))
    (define-key map (kbd "C-c <up>") 'code-cells-backward-cell)
    (define-key map (kbd "C-c <down>") 'code-cells-forward-cell)
    (define-key map (kbd "M-<up>") 'code-cells-move-cell-up)
    (define-key map (kbd "M-<down>") 'code-cells-move-cell-down)
    (define-key map (kbd "C-c C-c") 'code-cells-eval)
    ;; Overriding other minor mode bindings requires some insistence...
    (define-key map [remap jupyter-eval-line-or-region] 'code-cells-eval)))

(add-to-list 'auto-mode-alist '("\\.ipynb\\'" . python-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(adaptive-wrap all-the-icons apheleia auctex-latexmk cape code-cells corfu corg doom-modeline dumb-jump evil-collection
		   evil-nerd-commenter geiser general hl-todo jupyter org-ref org-roam org-superstar pyvenv
		   rainbow-delimiters treemacs-evil treemacs-icons-dired treemacs-projectile yasnippet-capf
		   yasnippet-snippets))
 '(package-vc-selected-packages '((corg :url "https://github.com/isamert/corg.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
