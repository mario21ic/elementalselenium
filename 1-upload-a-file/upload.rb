require 'selenium-webdriver'
require 'rspec/expectations'

include RSpec::Matchers

def setup
    @driver = Selenium::WebDriver.for :firefox
end

def teardown
    @driver.quit
end

def run
    setup
    yield
    teardown
end

run do
    filename = 'some_file.txt'
    file = File.join(Dir.pwd, filename)

    @driver.get 'http://the-internet.herokuapp.com/upload'
    @driver.find_element(id: 'file-upload').send_keys file
    @driver.find_element(id: 'file-submit').click

    uploaded_file = @driver.find_element(id: 'uploaded-files').text
    expect(uploaded_file).to eql filename
end
