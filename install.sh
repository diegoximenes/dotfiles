full_path=$(pwd)/$0
dir=$(dirname $full_path)/

rm ~/.bashrc
ln -s $dir/.bashrc ~/.bashrc
rm ~/.tmux.conf
ln -s $dir/.tmux.conf ~/.tmux.conf
