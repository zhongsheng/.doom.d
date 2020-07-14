;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "zhong sheng"
      user-mail-address "nily.zhong@gmail.com")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bookmark-default-file "/home/zhong/Clouds/emacs/bookmarks" t)
 '(evil-disable-insert-state-bindings t)
 '(projectile-globally-ignored-directories
   (quote
    ("~/.emacs.d/.local/" "/home/zhong/org/.attach/" "flow-typed" "node_modules" "~/.emacs.d/.local/" ".idea" ".ensime_cache" ".eunit" "spec" ".git" ".hg" ".fslckout" "_FOSSIL_" ".bzr" "_darcs" ".tox" ".svn" ".stack-work" "app/doc"))))
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq org-publish-project-alist
      '(("org-blog"
         ;; Path to your org files.
         :base-directory "~/blog/org/"
         :base-extension "org"

         ;; Path to your Jekyll project.
         :publishing-directory "~/blog/_posts/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 3
         :html-extension "md"
         :body-only t ;; Only export section between <body> </body>
         )

        ("blog"
         :components ("org-blog")
         ;; :publishing-function git-commit
         )))

(defun save-and-evil ()
  "save buffer then go to evil mode"
  (interactive)
  (save-buffer)
  (evil-normal-state)
  )

(defun create-blog-file ()
  "Create org file for my blog"
  (interactive)
  (let ((title (read-from-minibuffer "Title: ")))
    (let ((orgfile_name (concat "~/blog/org/"
                                (format-time-string "%Y-%m-%d-")
                                (replace-regexp-in-string " " "-" title)
                                ".org")))
      (shell-command-to-string (concat "touch " orgfile_name))
      (find-file orgfile_name )
      (org-mode)
      (insert "#+TITLE: " title " \n<f")
      (yas-expand)
      )))

(defun publish-my-blog ()
  "publish to github"
  (interactive)
  (org-publish-current-file)
  (shell-command "../publish.sh -f")
  )

(global-set-key (kbd "<f12>") 'org-agenda-list)
(global-set-key (kbd "M-`") 'save-and-evil)
(global-set-key (kbd "C-c o") 'create-blog-file)
(global-set-key (kbd "C-c i") 'publish-my-blog)

(fset 'evil-visual-update-x-selection 'ignore)

;; Make evil-mode up/down operate in screen lines instead of logical lines
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
;; Also in visual mode
(define-key evil-visual-state-map "j" 'evil-next-visual-line)
(define-key evil-visual-state-map "k" 'evil-previous-visual-line)
(defun evil-paste-after-from-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-paste-after)))

(define-key evil-visual-state-map "p" 'evil-paste-after-from-0)
