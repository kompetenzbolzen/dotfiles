# vi:syntax=sh

function get_git_state () {
	local GIT_STATUS=$(git status -bs)
	local GIT_BRANCH=$(echo $GIT_STATUS | grep "^## :")
	local GIT_CHANGED=$(echo $GIT_STATUS | grep -c "^ M")
	local GIT_UNTRACKED=$(echo $GIT_STATUS | grep -c "^??")
}
