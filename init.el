(setenv "LSP_USE_PLISTS" "true") ;; in early-init.el

(setq read-process-output-max (* 10 1024 1024)) ;; 10mb
(setq gc-cons-threshold 200000000)


(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(tooltip-mode -1)
(load-theme 'tango-dark)
(electric-pair-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq column-number-mode 1)

;; Zoom
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key [C-wheel-up] 'text-scale-increase)
(global-set-key [C-wheel-down] 'text-scale-decrease)


(setq make-backup-files nil) 
;;font
(set-frame-font "JetBrainsMono Nerd Font 10" nil t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq c-default-style "linux"
      c-basic-offset 4)

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
    ))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/work")
    (setq projectile-project-search-path '("~/work")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; Completion
;; (use-package ivy
;;   :diminish
;;   :bind (("C-s" . swiper)
;; 	 :map ivy-minibuffer-map
;; 	 ("TAB" . ivy-alt-done)
;; 	 ("C-l" . ivy-alt-done)
;; 	 ("C-j" . ivy-next-line)
;; 	 ("C-k" . ivy-previous-line)
;; 	 :map ivy-switch-buffer-map
;; 	 ("C-k" . ivy-previous-line)
;; 	 ("C-l" . ivy-done)
;; 	 ("C-d" . ivy-switch-buffer-kill)
;; 	 :map ivy-reverse-i-search-map
;; 	 ("C-k" . ivy-previous-line)
;; 	 ("C-d" . ivy-reverse-i-search-kill))
;;   :config
;;   (ivy-mode 1))


;; hydra for temporary commands
(use-package hydra)


(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error) ; optional but recommended error navigation
              ("M-p" . flycheck-previous-error)))


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
  (corfu-history-mode)
  (corfu-popupinfo-mode) ; Popup completion info
  :config
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                                   corfu-quit-no-match t
                                   corfu-auto nil)
              (corfu-mode))
            nil
            t))

;; (use-package eldoc
;;   :init
;;   (global-eldoc-mode))

;; (use-package eglot
;;   :ensure t
;;   :hook ((( c-mode python-mopde)
;;           . eglot-ensure)
;;          ((cider-mode eglot-managed-mode) . eglot-disable-in-cider))
;;   :custom
;;   (eglot-autoshutdown t)
;;   (eglot-events-buffer-size 0)
;;   (eglot-extend-to-xref nil)
;;   (eglot-stay-out-of '(yasnippet)))


;; languages and completion
(use-package lsp-mode
  :ensure t
  :defer t
  :hook ((lsp-mode . lsp-enable-which-key-integration)
	 (lsp-mode . lsp-diagnostics-mode)
	 (lsp-mode . lsp-ui-mode)
	 (c-mode . lsp-deferred) 
	 (python-mode . lsp-deferred))

  :bind (:map evil-normal-state-map
	      ("ee" . lsp-describe-thing-at-point))
  :commands (lsp lsp-deferred)

  :custom
  (lsp-completion-provider :none)       ; Using Corfu as the provider
  (lsp-diagnostics-provider :flycheck)
  (lsp-log-io nil)                      ; IMPORTANT! Use only for debugging! Drastically affects performance
  (lsp-keep-workspace-alive nil)        ; Close LSP server if all project buffers are closed
  (lsp-idle-delay 0.5)                  ; Debounce timer for `after-change-function'
  ;; core
  (lsp-enable-xref t)                   ; Use xref to find references
  (lsp-auto-configure t)                ; Used to decide between current active servers
  (lsp-eldoc-enable-hover t)            ; Display signature information in the echo area
  (lsp-enable-dap-auto-configure t)     ; Debug support
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding t)        
  (lsp-enable-imenu t)
  (lsp-enable-indentation nil)          ; I use prettier
  (lsp-enable-links nil)                ; No need since we have `browse-url'
  (lsp-enable-on-type-formatting nil)   ; Prettier handles this
  (lsp-enable-suggest-server-download t) ; Useful prompt to download LSP providers
  (lsp-enable-symbol-highlighting t)     ; Shows usages of symbol at point in the current buffer
  (lsp-enable-text-document-color nil)   ; This is Treesitter's job

  (lsp-ui-sideline-show-hover nil)      ; Sideline used only for diagnostics
  (lsp-ui-sideline-diagnostic-max-lines 20) ; 20 lines since typescript errors can be quite big
  ;; completion
  (lsp-completion-enable t)
  (lsp-completion-enable-additional-text-edit nil) ; Ex: auto-insert an import for a completion candidate
  (lsp-enable-snippet t)                         
  (lsp-completion-show-kind t)                   ; Optional
  ;; headerline
  (lsp-headerline-breadcrumb-enable t)  ; Optional, I like the breadcrumbs
  (lsp-headerline-breadcrumb-enable-diagnostics nil) ; Don't make them red, too noisy
  (lsp-headerline-breadcrumb-enable-symbol-numbers nil)
  (lsp-headerline-breadcrumb-icons-enable nil)
  ;; modeline
  (lsp-modeline-code-actions-enable nil) ; Modeline should be relatively clean
  (lsp-modeline-diagnostics-enable nil)  ; Already supported through `flycheck'
  (lsp-modeline-workspace-status-enable nil) ; Modeline displays "LSP" when lsp-mode is enabled
  (lsp-signature-doc-lines 1)                ; Don't raise the echo area. It's distracting
  (lsp-ui-doc-use-childframe t)              ; Show docs for symbol at point
  (lsp-eldoc-render-all nil)            ; This would be very useful if it would respect `lsp-signature-doc-lines', currently it's distracting
  ;; lens
  (lsp-lens-enable nil)                 ; Optional, I don't need it
  ;; semantic
  (lsp-semantic-tokens-enable nil)      ; Related to highlighting, and we defer to treesitter


  :init
  (setq lsp-clients-clangd-args '("--header-insertion=never"
				  "--clang-tidy"
				  "--enable-config"
				  "--query-driver=**"))
  (setq lsp-use-plists t)


  )




(use-package lsp-ui
  :ensure t
  :commands
  (lsp-ui-doc-show
   lsp-ui-doc-glance)
  :bind (:map lsp-mode-map
	      ("C-c C-d" . 'lsp-ui-doc-glance))
  :after (lsp-mode-evil)
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-delay 0.5)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  )

(use-package lsp-treemacs
  :defer t
  :after lsp
  :config
  (setq lsp-treemacs-sync-mode 1)
  )

;; (use-package lsp-ivy
;;   :defer t
;;   :after lsp
;;   :commands lsp-ivy-workspace-symbol)


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
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode)
  :hook((prog_mode . yas-mionor-mode)
	(text-mode . yas-minor-mode))
  )

;; (use-package yasnippet-snippets
;;   :defer t
;;   :after yasnippet
;; )

;; (use-package ivy-yasnippet
;;   :defer t
;;   :after (ivy yasnippet)
;;   )

;; LATEX
(use-package auctex
  :defer t 
  :hook (tex-mode . lsp-deferred)
  :hook (latex-mode . lsp-deferred)
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
  (phundrak/major-leader-key
   :packages 'lsp-mode
   :keymaps  '(latex-mode-map LaTeX-mode-map)
   "l"  '(:keymap lsp-command-map :which-key "lsp"))
  (phundrak/major-leader-key
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
  (auctex-latexmk-setup))

(use-package company-auctex
  :defer t
  :after (company auctex)
  :config
  (company-auctex-init))

(use-package company-math
  :defer t
  :after (company auctex)
  :config
  (defun my-latex-mode-setup ()
    (setq-local company-backends
                (append '((company-math-symbols-latex company-latex-commands))
                        company-backends)))
  (add-hook 'TeX-mode-hook #'my-latex-mode-setup))


(use-package evil-nerd-commenter
  :after evil)

(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "SCP tt") #'treemacs-select-window))
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


(use-package org-superstar
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/OrgNotes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point))
  :config
  (org-roam-setup))

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



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages '((corg :url "https://github.com/isamert/corg.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
