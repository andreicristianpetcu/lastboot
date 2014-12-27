#!/usr/bin/env ruby

puts `date`
save_from="/"
save_to="/mnt/lastboot/"
# save_from="/tmp/delete_me/"
# save_to="/mnt/lastboot_small/"
puts "Saving from #{save_from} to #{save_to}"

exclude_file_list=''
extra_ignore_list=["dev", "proc", "sys", "tmp", "run", "mnt", "media", "lost+found"]
extra_ignore_list.each do |exclude_dir|
  exclude_file_list="#{exclude_file_list}" + " --exclude '" + "#{exclude_dir}" + "'"
end

rsync_cmd="rsync -aAXv --delete --sparse #{exclude_file_list} #{save_from} #{save_to}"
puts "#{rsync_cmd}"

`cp /etc/fstab /etc/fstab.original`
`#{rsync_cmd}`
`cp #{save_to}etc/fstab.lastboot #{save_to}/etc/fstab`
puts `date`
