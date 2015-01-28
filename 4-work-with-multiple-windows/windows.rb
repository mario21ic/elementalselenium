require 'selenium-webdriver'
require 'rspec/expectations'

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

run {
    @driver.get 'http://the-internet.herokuapp.com/windows'
    @driver.find_element(css: '.example a ').click
    @driver.switch_to.window(@driver.window_handles.first)
    @driver.title.should_not eq(/New Window/)
    @driver.switch_to.window(@driver.window_handles.last)
    @driver.title.should eq(/New Window/)
}
