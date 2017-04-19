require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class SingleTest < Test::Unit::TestCase

  def setup
  	caps = Selenium::WebDriver::Remote::Capabilities.new
		caps["browser"] = ENV['browser']
		caps["browser_version"] = ENV['browser_version']
		caps["os"] = ENV['os']
		caps["os_version"] = ENV['os_version']

		if ENV['browser'] != "Internet Explorer"
			browser_name = "#{ENV['browser'].capitalize} #{ENV['browser_version']}"
		else
			browser_name = "Internet Explorer #{ENV['browser_version']}"
		end

		caps['project'] = "ACME, Inc. Website"
		caps['build'] = Time.now
		caps['name'] = browser_name

		caps["browserstack.debug"] = "true"

    url = "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => caps)
		@driver.manage.timeouts.implicit_wait = 10

		@test_failure_message = "Success message not found on page"
  end

  def test_post
		@driver.navigate.to 'https://browserstack-demo.herokuapp.com/'

		services_link = @driver.find_element(:css, ".nav > li:nth-child(1) > a:nth-child(1)")
		services_link.click
		sleep 2

		about_link = @driver.find_element(:css, ".nav > li:nth-child(2) > a:nth-child(1)")
		about_link.click
		sleep 2

		blog_link = @driver.find_element(:css, ".nav > li:nth-child(3) > a:nth-child(1)")
		blog_link.click
		sleep 2

		expand_portfolio = @driver.find_element(:class, "dropdown-toggle")
		expand_portfolio.click
		sleep 2

		portfolio_link = @driver.find_element(:css, ".dropdown-menu > li:nth-child(1) > a:nth-child(1)")
		portfolio_link.click
		sleep 2

		contact_link = @driver.find_element(:css, ".nav > li:nth-child(5) > a:nth-child(1)")
		contact_link.click
		sleep 2

		full_name = @driver.find_element(:id, "name")
		full_name.send_keys "James Anderson"
		sleep 1

		phone = @driver.find_element(:id, "phone")
		phone.send_keys "123-456-7890"
		sleep 1

		email = @driver.find_element(:id, "email")
		email.send_keys "me@example.com"
		sleep 1

		message = @driver.find_element(:id, "message")
		message.send_keys "I'd like to know more about your company."
		sleep 1

		submit = @driver.find_element(:class, "btn")
		submit.click

		success_message = @driver.find_element(:class, "contact-message")
		sleep 1
		assert(success_message.displayed?, @test_failure_message)
  end

  def teardown
    api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, { "status" => "failed", "reason" => @test_failure_message}, {:content_type => :json} if ENV['browser'] == "Firefox"

  	@driver.quit
  end
  
end
