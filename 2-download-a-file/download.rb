require 'selenium-webdriver'
require 'rspec/expectations'

include RSpec::Matchers

require 'uuid'
require 'fileutils'

def setup
    @download_dir = File.join(Dir.pwd, UUID.new.generate)
    FileUtils.mkdir_p @download_dir

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = @download_dir
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream, application/pdf, image/jpeg'
    profile['pdfjs.disabled'] = true
    @driver = Selenium::WebDriver.for :firefox, profile: profile
end

def teardown
    @driver.quit
    FileUtils.rm_rf @download_dir
end

def run
    setup
    yield
    teardown
end

run do
    @driver.get 'http://the-internet.herokuapp.com/download'
    download_link = @driver.find_element(css: '.example a')
    download_link.click

    @driver.manage.timeouts.implicit_wait = 10 # seconds
    files = Dir.glob("#{@download_dir}/**")
    expect(files.empty?).to eql false

    sorted_files = files.sort_by { |file| File.mtime(file) }
    expect(File.size(sorted_files.last)).to be > 0
end
