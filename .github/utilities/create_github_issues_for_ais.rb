require 'pathname'
require 'octokit'
require 'nmea_plus'

# This script automatically creates github issues based on collected data
# (specifically binary subtypes).  It extracts the AIS type info from the
# filename, makes sure that such a class does not exist, makes sure the
# generated issue title does not exist, and if not, creates an issue in
# github with the acquired sample data.
#
# Running the script multiple times should not create duplicate issues.

GAT = 'GITHUB_ACCESS_TOKEN'.freeze
REPO = 'ianfixes/nmea_plus'.freeze

# usage: ruby create_github_issues_for_ais.rb samples/*
if ARGV.empty?
  puts "Dude, specify the data files (vdm-ais-type-*d*f*.txt) on the comand line"
  exit 1
end

if ENV[GAT].nil?
  puts "Dude, set ENV[#{GAT}] with your github access token"
  exit 1
end


# i've recorded data in the form vdm-ais-type-8d997f21.txt
def extract_ais_fields_from_filename(filename)
  pn = Pathname.new(filename)
  matches = /vdm-ais-type-(\d)d(\d+)f(\d+)\.txt/.match(pn.basename.to_s)
  return nil if matches.nil?
  matches.captures
end

# https://stackoverflow.com/a/1187276/2063546
def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  false
end

def ais_class_exists?(ais_type, dac, fid)
  class_exists?("NMEAPlus::Message::AIS::VDMPayload::VDMMsg#{ais_type}d#{dac}f#{fid}")
end

# get github client and existing issue titles
github = Octokit::Client.new(access_token: ENV[GAT], per_page: 100)
github.auto_paginate = true
existing_issues = github.list_issues(REPO, state: "all")
existing_issue_titles = existing_issues.map(&:title)

ARGV.each_with_index do |f, i|
  pieces = extract_ais_fields_from_filename(f)
  next if pieces.nil?
  ais = pieces[0]
  dac = pieces[1]
  fid = pieces[2]
  title = "Add support for AIS type #{ais} binary subtype of DAC=#{dac} and FID=#{fid}"
  body = "Sample data:\n```\n#{IO.read(f)}```"
  # next if title in existing_github_issues
  puts "--------\n#{i} - #{f}"

  # create issue
  if existing_issue_titles.include? title
    puts "Issue already exists"
  elsif ais_class_exists?(ais, dac, fid)
    puts "Class already exists"
  else
    puts title
    puts body
    github.create_issue(REPO, title, body, labels: "Need spec,enhancement")
    puts
  end
end
