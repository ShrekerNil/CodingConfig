CUR_DIR=$(pwd -P)
# ls | while read file
for file in $(ls); do
if [[ -d $file ]] && [[ -d $file/.git ]]; then
  cd $file
  echo ==============================================================
  echo "Git setup-rebase-pull $file start ..."

  echo "Configing user.name=Shreker.Nil ..."
  git config --global user.name Shreker.Nil

  echo "Configing user.email=ShrekerNil@qq.com ..."
  git config --global user.email ShrekerNil@qq.com
  
  #echo "Configing Rebase-Pull ..."
  #git config pull.rebase true
  
  echo "Configing CR/LT for Git Line Ending ..."
  #git config core.autocrlf true
  git config core.autocrlf input
  git config core.safecrlf true
  
  echo "Configing Long Path Supports ..."
  git config core.longpaths true
  
  echo "Configing Ignore Case ..."
  git config core.ignorecase false
  
  cd $CUR_DIR
  echo "Git setup-rebase-pull $file Finished
  echo ------------------------------------
fi
done
read -p "Press enter to continue ... "
