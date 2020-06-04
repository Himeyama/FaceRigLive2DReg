#!/usr/bin/env ruby

require "fileutils"

dir = "#{ENV["RBENV_DIR"]}/Objects"
FileUtils.mkdir_p dir
name = ARGV[0]
unless name
    warn "名前を与えてください"
    exit false
end

moc_file = ARGV[1]
unless moc_file
    warn "*.moc の場所を与えてください"
    exit false
end
unless File.exist? moc_file
    warn "#{moc_file} が見つかりません"
    exit false
end

moc_texture = ARGV[2]
unless moc_texture
    warn "テクスチャ(*.png) の場所を与えてください"
    exit false
end
unless File.exist? moc_texture
    warn "#{moc_texture} が見つかりません"
    exit false
end

moc_ico = ARGV[3]
unless moc_ico
    warn "サムネイル(*.png) の場所を与えてください"
    exit false
end
unless File.exist? moc_ico
    warn "#{moc_ico} が見つかりません"
    exit false
end

dir_n = "#{dir}/#{name}"

`convert #{moc_ico} -resize 500x500! #{moc_ico}_500.png`
FileUtils.mkdir_p dir_n
FileUtils.mkdir_p "#{dir_n}/#{name}.1024"
FileUtils.copy moc_file, dir_n
FileUtils.copy moc_texture, "#{dir_n}/#{name}.1024/texture_00.png"
FileUtils.copy "#{moc_ico}_500.png", "#{dir_n}/ico_#{name}.png"

str = "set_friendly_name #{name}\nset_avatar_skin_description #{name} default txt_desc#{name}\n"
open "#{dir_n}/cc_names_#{name}.cfg", "w" do |f|
    f << str
end
