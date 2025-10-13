# Git abbreviations

# Basic git commands
abbr -a -- g git
abbr -a -- ga "git add"
abbr -a -- gaa "git add --all"
abbr -a -- gap "git apply"
abbr -a -- gapa "git add --patch"
abbr -a -- gau "git add --update"

# Branch operations
abbr -a -- gb "git branch -vv"
abbr -a -- gbD "git branch -D"
abbr -a -- gba "git branch -a -v"
abbr -a -- gban "git branch -a -v --no-merged"
abbr -a -- gbd "git branch -d"
abbr -a -- gbl "git blame -b -w"
abbr -a -- gg 'git gone'
abbr -a -- ggsup "git branch --set-upstream-to=origin/(git branch --show-current)"
abbr -a -- glgg 'git pull && git gone'

# Bisect operations
abbr -a -- gbs "git bisect"
abbr -a -- gbsb "git bisect bad"
abbr -a -- gbsg "git bisect good"
abbr -a -- gbsr "git bisect reset"
abbr -a -- gbss "git bisect start"

# Commit operations
abbr -a -- gac "git add -A && git commit -v"
abbr -a -- gam 'git add --all && meteor'
abbr -a -- gc "git commit -v"
abbr -a -- gc! "git commit -v --amend"
abbr -a -- gca! "git commit -v -a --amend"
abbr -a -- gcam "git commit -a -m"
abbr -a -- gcan! "git commit -v -a --no-edit --amend"
abbr -a -- gcav "git commit -a -v --no-verify"
abbr -a -- gcav! "git commit -a -v --no-verify --amend"
abbr -a -- gce 'git commit --allow-empty -m "Empty commit"'
abbr -a -- gcfx "git commit --fixup"
abbr -a -- gcn! "git commit -v --no-edit --amend"
abbr -a -- gcs "git commit -S"
abbr -a -- gcv "git commit -v --no-verify"
abbr -a -- gscam "git commit -S -a -m"

# Config and clone
abbr -a -- gcf "git config --list"
abbr -a -- gcl "git clone"

# Clean operations
abbr -a -- gclean "git clean -di"
abbr -a -- gclean! "git clean -dfx"
abbr -a -- gclean!! "git reset --hard; and git clean -dfx"
abbr -a -- gpristine 'git reset --hard; and git clean --force -dfx'
abbr -a -- gpv 'git prune --verbose'

# Misc operations
abbr -a -- gcount "git shortlog -sn"
abbr -a -- gcp "git cherry-pick"
abbr -a -- gcpa "git cherry-pick --abort"
abbr -a -- gcpc "git cherry-pick --continue"

# Diff operations
abbr -a -- gd "git diff"
abbr -a -- gdca "git diff --cached"
abbr -a -- gdg "git diff --no-ext-diff"
abbr -a -- gds "git diff --stat"
abbr -a -- gdsc "git diff --stat --cached"
abbr -a -- gdt "git diff-tree --no-commit-id --name-only -r"
abbr -a -- gdto "git difftool"
abbr -a -- gdw "git diff --word-diff"
abbr -a -- gdwc "git diff --word-diff --cached"

# Index operations
abbr -a -- gignore "git update-index --assume-unchanged"
abbr -a -- gunignore "git update-index --no-assume-unchanged"

# Fetch operations
abbr -a -- gf "git fetch"
abbr -a -- gfa "git fetch --all --prune"
abbr -a -- gfm "git fetch origin (git show-default) --prune; and git merge FETCH_HEAD"
abbr -a -- gfo "git fetch origin"

# Pull operations
abbr -a -- ggl "git pull origin (git branch --show-current)"
abbr -a -- ggu "git pull --rebase origin (git branch --show-current)"
abbr -a -- gl "git pull"
abbr -a -- gll "git pull origin"
abbr -a -- glr "git pull --rebase"
abbr -a -- gup "git pull --rebase"
abbr -a -- gupa "git pull --rebase --autostash"
abbr -a -- gupav "git pull --rebase --autostash -v"
abbr -a -- gupv "git pull --rebase -v"

# Log operations
abbr -a -- glg "git log --stat"
abbr -a -- glgga "git log --graph --decorate --all"
abbr -a -- glo "git log --oneline --decorate --color"
abbr -a -- glod "git log --oneline --decorate --color develop.."
abbr -a -- glog "git log --oneline --decorate --color --graph"
abbr -a -- gloga "git log --oneline --decorate --color --graph --all"
abbr -a -- glom "git log --oneline --decorate --color (git show-default).."
abbr -a -- gloo "git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"

# Merge operations
abbr -a -- gm "git merge"
abbr -a -- gmod 'git merge origin/develop'
abbr -a -- gmom "git merge origin/(git show-default)"
abbr -a -- gmt "git mergetool --no-prompt"

# Push operations
abbr -a -- ggp "git push origin (git branch --show-current)"
abbr -a -- ggp! "git push origin (git branch --show-current) --force-with-lease"
abbr -a -- ggpnp "git pull origin (git branch --show-current); and git push origin (git branch --show-current)"
abbr -a -- gp "git push"
abbr -a -- gp! "git push --force-with-lease"
abbr -a -- gpf 'git push --force-with-lease --force-if-includes'
abbr -a -- gpo "git push origin"
abbr -a -- gpo! "git push --force-with-lease origin"
abbr -a -- gpoat "git push origin --all; and git push origin --tags"
abbr -a -- gpu "git push origin (git branch --show-current) --set-upstream"

# Remote operations
abbr -a -- gr "git remote -vv"
abbr -a -- gra "git remote add"
abbr -a -- grmv "git remote rename"
abbr -a -- grpo "git remote prune origin"
abbr -a -- grrm "git remote remove"
abbr -a -- grset "git remote set-url"
abbr -a -- grup "git remote update"
abbr -a -- grv "git remote -v"

# Rebase operations
abbr -a -- grb "git rebase"
abbr -a -- grba "git rebase --abort"
abbr -a -- grbc "git rebase --continue"
abbr -a -- grbd "git rebase develop"
abbr -a -- grbdi "git rebase develop --interactive"
abbr -a -- grbdia "git rebase develop --interactive --autosquash"
abbr -a -- grbi "git rebase --interactive"
abbr -a -- grbm "git rebase (git show-default)"
abbr -a -- grbmi "git rebase (git show-default) --interactive"
abbr -a -- grbmia "git rebase (git show-default) --interactive --autosquash"
abbr -a -- grbod 'git rebase origin/develop'
abbr -a -- grbom "git fetch origin (git show-default); and git rebase FETCH_HEAD"
abbr -a -- grbomi "git fetch origin (git show-default); and git rebase FETCH_HEAD --interactive"
abbr -a -- grbomia "git fetch origin (git show-default); and git rebase FETCH_HEAD --interactive --autosquash"
abbr -a -- grbs "git rebase --skip"

# Reset operations
abbr -a -- grev "git revert"
abbr -a -- grh "git reset"
abbr -a -- grhh "git reset --hard"
abbr -a -- grhpa "git reset --patch"

# Remove operations
abbr -a -- grm "git rm"
abbr -a -- grmc "git rm --cached"

# Restore operations
abbr -a -- grs "git restore"
abbr -a -- grss "git restore --source"
abbr -a -- grst "git restore --staged"

# Show operations
abbr -a -- gsh "git show"

# SVN operations
abbr -a -- gsd "git svn dcommit"
abbr -a -- gsr "git svn rebase"

# Status operations
abbr -a -- gs "git status -sb"
abbr -a -- gss "git status -s"
abbr -a -- gst "git status"

# Stash operations
abbr -a -- gsta "git stash"
abbr -a -- gstd "git stash drop"
abbr -a -- gstl "git stash list"
abbr -a -- gstp "git stash pop"
abbr -a -- gsts "git stash show --text"

# Submodule operations
abbr -a -- gsu "git submodule update"
abbr -a -- gsur "git submodule update --recursive"
abbr -a -- gsuri "git submodule update --recursive --init"

# Switch operations
abbr -a -- gsw "git switch"
abbr -a -- gswc "git switch --create"

# Tag operations
abbr -a -- gts "git tag -s"
abbr -a -- gtv "git tag | sort -V"

# Whatchanged
abbr -a -- gwch "git whatchanged -p --abbrev-commit --pretty=medium"

# Checkout operations
abbr -a -- gcb "git checkout -b"
abbr -a -- gcd "git checkout develop"
abbr -a -- gcm "git checkout (git show-default)"
abbr -a -- gcmg "git checkout (git show-default) && git pull && git gone"
abbr -a -- gco- 'git checkout -'
abbr -a -- gcod "git checkout develop"
abbr -a -- gcom "git checkout (git show-default)"

# Git flow operations
abbr -a -- gfb "git flow bugfix"
abbr -a -- gff "git flow feature"
abbr -a -- gfh "git flow hotfix"
abbr -a -- gfr "git flow release"
abbr -a -- gfs "git flow support"

abbr -a -- gfbs "git flow bugfix start"
abbr -a -- gffs "git flow feature start"
abbr -a -- gfhs "git flow hotfix start"
abbr -a -- gfrs "git flow release start"
abbr -a -- gfss "git flow support start"

abbr -a -- gfbt "git flow bugfix track"
abbr -a -- gfft "git flow feature track"
abbr -a -- gfht "git flow hotfix track"
abbr -a -- gfrt "git flow release track"
abbr -a -- gfst "git flow support track"

abbr -a -- gfp "git flow publish"

# Git worktree operations
abbr -a -- gwt "git worktree"
abbr -a -- gwta "git worktree add"
abbr -a -- gwtlo "git worktree lock"
abbr -a -- gwtls "git worktree list"
abbr -a -- gwtmv "git worktree move"
abbr -a -- gwtpr "git worktree prune"
abbr -a -- gwtrm "git worktree remove"
abbr -a -- gwtulo "git worktree unlock"

# GitLab push options
abbr -a -- gmr "git push origin (git branch --show-current) --set-upstream -o merge_request.create"
abbr -a -- gmwps "git push origin (git branch --show-current) --set-upstream -o merge_request.create -o merge_request.merge_when_pipeline_succeeds"
