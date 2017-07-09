(setq op/repository-directory "/Users/astropeak/Dropbox/project/astropeak.github.io")

(setq op/site-domain "http://astropeak.github.io/")
(setq  op/site-main-title "自然语言处理")
(setq  op/site-sub-title "")
(setq  op/personal-github-link "https://github.com/astropeak")


(defun op/my-do-publication-and-preview-site (path)
  "Do publication in PATH and preview the site in browser with simple-httpd.
When invoked without prefix argument then PATH defaults to
`op/site-preview-directory'."
  (interactive
   (if current-prefix-arg
       (list (read-directory-name "Path: "))
     (list op/site-preview-directory)))

  ;; commit all changes
  (condition-case error
      (progn
        (op/git-change-branch op/repository-directory "source")
        (op/git-commit-changes op/repository-directory "Changes")
        (op/do-publication t nil path)

        ;;change index to blog index
        (copy-file (concat path "/blog/index.html") (concat path "/index.html") t t))
    ('git-error  (message "Error is %s" error)))

  (httpd-serve-directory path)
  (browse-url (format "http://%s:%d" system-name httpd-port)))
