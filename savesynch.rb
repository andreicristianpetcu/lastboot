#!/usr/bin/env ruby
save_from="/"
save_to="/mnt/lastboot/"
# save_from="/tmp/delete_me/"
# save_to="/mnt/lastboot_small/"
puts "Saving from #{save_from} to #{save_to}"
exclude_file_list=''
current_path="#{save_from}home/"
puts "Current path is #{current_path}"
user_include_list=["Anki", "Calibre Library", "Desktop", "Documents", "dotfiles", "Games", "Pictures"]
user_exclude_list=[".config/teamviewer9/"]

nondotfile_links = []

Dir.foreach("#{current_path}") do |user|
  if not user.start_with?(".") then
    user_dir="#{current_path}#{user}"
    puts "Processing user #{user_dir}"
    Dir.foreach("#{user_dir}") do |f|
      if not f.start_with?(".") then

        if not user_include_list.include?(f) then
          exclude_dir="#{user_dir}/#{f}"
          nondotfile_links << exclude_dir
          exclude_dir=exclude_dir[save_from.length, exclude_dir.length]
          exclude_file_list="#{exclude_file_list}" + " --exclude '" + "#{exclude_dir}" + "'"
        end

      end
    end
    user_exclude_list.each do |user_exclude_dir|
      exclude_dir="#{user_dir}/#{user_exclude_dir}"
      if File.exist?(exclude_dir) then
        exclude_dir=exclude_dir[save_from.length, exclude_dir.length]
        puts "user_exclude_dir = #{exclude_dir}"
        exclude_file_list="#{exclude_file_list}" + " --exclude '" + "#{exclude_dir}" + "'"
      end
    end
  end
end

extra_ignore_list=["dev", "proc", "sys", "tmp", "run", "mnt", "media", "lost+found", "var/lib/mongodb"]
extra_ignore_list.each do |exclude_dir|
  exclude_file_list="#{exclude_file_list}" + " --exclude '" + "#{exclude_dir}" + "'"
end
rsync_cmd="rsync -aAXv --delete --sparse #{exclude_file_list} #{save_from} #{save_to}"
puts "#{rsync_cmd}"

`cp /etc/fstab /etc/fstab.original`
`#{rsync_cmd}`
`cp #{save_to}etc/fstab.lastboot #{save_to}/etc/fstab`

links_destination = save_to
links_destination.end_with?("/")?links_destination = links_destination[0..-2]:nil
puts "Link non system resources"
for soft_link in nondotfile_links do
  soft_link_source = soft_link
  soft_link.start_with?("/home")?soft_link_source = soft_link[5..-1]:nil
  source = "/mnt/origin_home" + soft_link_source
  destination = links_destination + soft_link
  puts source + " -> " + destination
  `echo "$source" "$destination"`
  `rm -rf "#{destination}"`
  # `ln -s "#{source}" "#{destination}"`
end
