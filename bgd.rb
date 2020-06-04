#!/usr/bin/env ruby

require "net/http"
require "json"
require "fileutils"

uri = "https://bestdori.com/assets/jp/"
dir = ENV["RBENV_DIR"]
tmp = "#{dir}/tmp"

if ARGV.size != 2
    puts "Path を入力してください:"
    print "Path[0]: "
    path = gets.chop

    puts "サムネイル画像の場所を入力してください:"
    print "Path[1]: "
    moc_ico = gets.chop
else
    path = ARGV[0]
    moc_ico = ARGV[1]
end

unless File.exist? moc_ico
    warn "\033[31mエラー: サムネイル画像が存在しません\033[0m"
    exit false
end

req = URI.parse "#{uri}#{path}_rip/buildData.asset"
res = Net::HTTP.get req
assets_data = JSON.parse(res)

req = URI.parse "#{uri}#{assets_data["Base"]["model"]["bundleName"]}_rip/#{moc = File.basename assets_data["Base"]["model"]["fileName"], ".bytes"}"
res = Net::HTTP.get req
open "#{tmp}/#{moc}", "w" do |f|
    f << res
end

req = URI.parse "#{uri}#{assets_data["Base"]["textures"][0]["bundleName"]}_rip/#{textures = assets_data["Base"]["textures"][0]["fileName"]}"
res = Net::HTTP.get req
open "#{tmp}/#{textures}", "w" do |f|
    f << res
end

name = "#{File.basename(path).match(/^\d*?_(.*?)$/)[1]}_#{File.basename moc, ".moc"}" 

info_moc_ico = `identify -format "%[height],%[width]" #{moc_ico}`
if info_moc_ico == "730,973"
    `convert #{moc_ico} -crop 275x275+347+85 #{tmp}/out.png`
    moc_ico = "#{tmp}/out.png"
end

`#{dir}/main.rb #{name} #{tmp}/#{moc} #{tmp}/#{textures} #{moc_ico}`
