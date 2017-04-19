# Single Test

task :single do
	system "ruby single.rb"
end

# Parallel Test

require 'json'

browser_list = File.read('browsers.json')
browsers = JSON.parse(browser_list)['browsers']
parallel_tests = Array.new

def run_parallel_test(browser)
	command =  "os=\"#{browser['os']}\" "
	command += "os_version=\"#{browser['os_version']}\" "
	command += "browser=\"#{browser['browser']}\" "
	command += "browser_version=\"#{browser['browser_version']}\" "
	# command += "current_time=#{Time.now} "
	command += "ruby parallel.rb"
	system command
end

browsers.each_with_index do |browser, i|
	eval "parallel_tests << :parallel_test_#{i}"
	eval "task :parallel_test_#{i} do run_parallel_test(#{browser}) end"
end

multitask :parallel => parallel_tests