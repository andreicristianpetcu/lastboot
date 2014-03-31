work_dir=/tmp/delete_me 
rm -rf $work_dir
mkdir -p $work_dir

cd $work_dir
mkdir -p soft_link_src_dir normal files link_destinations
mkdir -p home/{user1,user2}/{ignoreme1,ignoreme2,'igno reme3',.include1,.include2,.include3}

cd files
echo "hard_link_src_file content" | sudo tee hard_link_src_file
echo "soft_link_src_file content" | sudo tee soft_link_src_file

echo "hard_link_src_file child content" | sudo tee hard_link_src_file
echo "soft_link_src_file child content" | sudo tee soft_link_src_file

cd $work_dir/soft_link_src_dir
touch soft{1,2}.txt

cd $work_dir/normal
touch soft{1,2}.txt

cd $work_dir/link_destinations 
ln ../files/hard_link_src_file hard_link_dest_file
ln -s ../files/soft_link_src_file soft_link_dest_file
ln -s ../soft_link_src_dir soft_link_dest_dir

ln -s $work_dir/link_destinations/soft_link_src_file $work_dir/home/user1/.soft_link_src_file 
ln -s $work_dir/link_destinations/soft_link_src_dir $work_dir/home/user1/.soft_link_src_dir
mkdir -p $work_dir/home/user1/dotfiles/bashrc
ln -s $work_dir/home/user1/dotfiles/bashrc $work_dir/home/user1/.bashrc
cd $work_dir

# clear

tree
tree -u
