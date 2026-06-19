;; -*- lexical-binding: t; -*-
(setq ;;file-name-handler-alist nil
      read-process-output-max (* 10 1024 1024) ;; 10mb
      gc-cons-threshold 200000000
      auto-window-vscroll nil
      )

(setq visible-bell t
      inhibit-startup-message t
      scroll-conservatively 101
      use-dialog-box nil
      x-gtk-use-system-tooltips nil
      confirm-kill-processes nil
      )
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(blink-cursor-mode 0)
(winner-mode t)
;;(desktop-save-mode t)
(save-place-mode t)

(load-theme 'modus-vivendi-deuteranopia)
(electric-pair-mode 1)
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(visual-line-mode t)
(global-visual-line-mode t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(fringe-mode 5)


;;(setq column-number-mode 1)
(setopt tab-always-indent t)
(setq read-extended-command-predicate #'command-completion-default-include-p)


;; Zoom
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key [C-wheel-up] 'text-scale-increase)
(global-set-key [C-wheel-down] 'text-scale-decrease)

(setq backup-directory-alist `(("." . ,(expand-file-name ".tmp/backups/"
                                                         user-emacs-directory)))
      tramp-backup-directory-alist `(("." . ,(expand-file-name ".tmp/tramp-backups/"
                                                               user-emacs-directory))))

(setq delete-by-moving-to-trash t)
;;(add-to-list 'default-frame-alist '(alpha-background . 0.9))



(setq make-backup-files nil) 
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)

(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))
;;font
(set-frame-font "JetBrainsMono Nerd Font 13" nil t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq-default indent-tabs-mode nil)

(setq c-default-style "linux"
      c-basic-offset 4
      fill-column 120
      tab-width 4
      )

(setq comment-style 'multi-line)


(add-hook 'python-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil)
            (setq-local tab-width 4)
            (setq-local python-indent-offset 4)
            ;; Disable indentation cycling so TAB always indents forward
            (setq-local python-indent-trigger-commands nil)))


;; NOTE TRAMP
(setq tramp-default-method "ssh")
(setq remote-file-name-inhibit-cache nil)
(setq tramp-verbose 1)
(setq vc-ignore-dir-regexp (format "%s\\|%s" vc-ignore-dir-regexp tramp-file-name-regexp))
(setq tramp-persistency-file-name "~/.emacs.d/tramp")
(setq vc-handled-backends nil)
(setq tramp-completion-reread-directory-timeout nil)
(setq tramp-backup-directory-alist backup-directory-alist)
(setq tramp-copy-size-limit 1000000) ; Files larger than 1Mb use SCP maintaining SSH session
(connection-local-set-profile-variables
 'remote-direct-async-process
 '((tramp-direct-async-process . t)))
(connection-local-set-profiles
 '(:application tramp :protocol "scp")
 'remote-direct-async-process)

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
  :custom (
	   (doom-modeline-height 20)
	   (doom-modeline-hud nil)
	   (doom-modeline-buffer-encoding nil)
	   (doom-modeline-minor-modes nil)
	   (doom-modeline-persp-name nil)
	   (doom-modeline-enable-buffer-position t)
	   (doom-modeline-env-version nil)
	   (doom-modeline-modal nil)
	   ))

(setq nerd-icons-scale-factor 1.3)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


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
    "w k" '(windmove-up :which-key "move up")
    "w l" '(windmove-right :which-key "move right")
    "t t" '(treemacs :which-key "treemacs")
    "d d" '(dired :which-key "dired")
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
    "p" '(:keymap projectile-command-map :which-key "projectile"))
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; ;; hydra for temporary commands
;; (use-package hydra)


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
  (corfu-auto-delay 0.5)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-preview-current nil)      ; don't auto-insert previewed candidate
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
            t)
    )


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
  :hook((prog-mode . yas-minor-mode)
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
  )


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
                                   fill-nobreak- redicate (cons #'texmathp fill-nobreak-predicate))))
  (add-hook 'TeX-mode-hook #'visual-line-mode)
  (add-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)
  :general
  ;; TODO
  (alf/leader-keys
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
  :hook (LaTeX-mode . adaptive-wrap-prefix-mode)
  :init (setq-default adaptive-wrap-extra-indent 0))





(use-package evil-nerd-commenter
  :after evil)

(use-package treemacs
  :defer t
  :init
  (setq treemacs-follow-after-init t
        treemacs-is-never-other-window nil
        treemacs-sorting 'alphabetic-case-insensitive-asc
        treemacs-select-when-already-in-treemacs 'stay)

  :config
  (treemacs-follow-mode -1)
  (setq treemacs-window-select-behaviour 'original))


(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)


;; ORG
;; Syntax highlight in #+BEGIN_SRC blocks
(setq org-src-fontify-natively t)
;; Don't prompt before running code in org
(setq org-confirm-babel-evaluate nil)
(setq org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)
(setq org-highlight-latex-and-related '(native))
(setq org-startup-with-inline-images t)
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
   (jupyter . t)
   )
 )

(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; FIXME warnings
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
      bibtex-completion-library-path '("~/Documents/bibliography/bibtex_pdfs/")
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
(add-hook 'org-mode-hook 'hl-todo-mode)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/Documents/org/work.org" "~/Documents/org/home.org"))

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

(setq org-latex-packages-alist '(("" "tikz" t)
				 ("" "tikz-cd" t)))

(use-package corg
  :vc (:url "https://github.com/isamert/corg.el"))


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
	      ("NOTE"  . "#00FF20")
	      ("DONE"  . "#00FF20")
	      ("TEMPORARY"  . "#FFFF32")
          ("FUTURE" . "#00FFFF")
	  )
	)
  )

;;; jupyter
(use-package
  jupyter)
(setq ob-async-no-async-languages-alist '("python" "jupyter-python"))
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

(defun my-md-to-org-region (start end)
  "Convert region from markdown to org"
  (interactive "r")
  (shell-command-on-region start end "pandoc -f markdown -t org" t t))


(use-package orderless
  :init
  ;; Tune the global completion style settings to your liking!
  ;; This affects the minibuffer and non-lsp completion at point.
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil))


(use-package eglot
  :ensure
  :defer t
  :custom
  (eglot-sync-connect 1)
  (eglot-send-changes-idle-time 0.5)
  (eglot-autoshutdown t)
  :hook ((c-mode . eglot-ensure)
	 (c++-mode . eglot-ensure)
	 (python-mode . eglot-ensure))
  :config
  (alf/leader-keys
    :keymaps 'eglot-mode-map
    "l" '(:ignore t :which-key "lsp")
    "l d" '(xref-find-definitions :which-key "definition")
    "l r" '(xref-find-references :which-key "references")
    "l a" '(eglot-code-actions :which-key "code actions")
    "l R" '(eglot-rename :which-key "rename")
    "l f" '(eglot-format :which-key "format")
    "l h" '(eldoc :which-key "hover")
    "l F" '(flymake-mode :which-key "flymake on/off")
    "l n" '(flymake-goto-next-error :which-key "next error")
    "l p" '(flymake-goto-prev-error :which-key "prev error")
    "l q" '(eglot-shutdown :which-key "shutdown")
    )
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider
                                            :documentHighlightProvider))
  )

(with-eval-after-load 'eglot
(add-to-list 'eglot-server-programs
             '((c++-mode c-mode)
               . ("clangd"
                  "-j=2"
                  "--header-insertion=never"
                  "--header-insertion-decorators=0"
                  ))))



(add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))

;; Option 1: Specify explicitly to use Orderless for Eglot
(setq completion-category-overrides '((eglot (styles orderless))
                                      (eglot-capf (styles orderless))))

(defun my/eglot-setup-capf ()
  "Set buffer-local capfs for eglot buffers, combining eglot with snippets."
  (setq-local completion-at-point-functions
              (list 
               (cape-capf-super
		#'eglot-completion-at-point
                #'yasnippet-capf))))


(add-hook 'eglot-managed-mode-hook #'my/eglot-setup-capf)

;; (use-package python-black
;;   :ensure t
;;   :demand t
;;   :after python
;;   :hook ((python-mode . python-black-on-save-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/work/thesis/thesis.org" "/home/yamamoto/Documents/org/work.org"))
 '(package-selected-packages nil)
 '(package-vc-selected-packages '((corg :url "https://github.com/isamert/corg.el")))
 '(warning-suppress-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
