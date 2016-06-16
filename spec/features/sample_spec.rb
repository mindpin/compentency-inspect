require 'rails_helper'

describe 'sample' do
  # around do |example|
  #   Headless.ly do
  #     example.run
  #   end
  # end

  before {
    user = User.create role: 'admin', name: 'admin', login: 'admin', password: '123456'
  }

  # it 'sample' do
  #   expect(1).to eq(1)
  # end

  # it 'user' do
  #   expect(User.count).to eq(1)
  # end

  # it 'webkit sample' do
  #   headless = Headless.new
  #   headless.start
  #   headless.video.start_capture

  #   visit "/admin/sign_in"
  #   expect(page).to have_selector("body")
  #   expect(page).to have_selector("form")
  #   page.save_screenshot 'screenshot0.png', width: 1024, height: 768

  #   fill_in 'user_login', with: 'admin'
  #   fill_in 'user_password', with: '123456'
  #   page.save_screenshot 'screenshot1.png', width: 1024, height: 768 

  #   click_button '管理员登录'
  #   page.save_screenshot 'screenshot2.png', width: 1024, height: 768

  #   headless.video.stop_and_save 'headless.mov'
  # end

  # it 'baidu' do
  #   headless = Headless.new video: { frame_rate: 12, codec: 'libx264' }
  #   headless.start

  #   headless.video.start_capture

  #   visit 'http://baidu.com'

  #   headless.video.stop_and_save 'headless.mp4'
  #   headless.take_screenshot 'headless.png'

  #   # headless.destroy
  # end

  it 'baidu' do
    headless = Headless.new video: { frame_rate: 12, codec: 'libx264' }
    headless.start

    page.driver.browser.manage.window.resize_to(1280, 1024)

    headless.video.start_capture

    visit "/admin/sign_in"
    sleep 1
    fill_in 'user_login', with: 'admin'
    sleep 1
    fill_in 'user_password', with: '123456'
    sleep 1
    click_button '管理员登录'
    sleep 1
    click_link '账号管理'
    sleep 1
    click_link '创建账号'
    sleep 1
    find('.data-form .field:nth-child(1) input').set('测试用户')
    sleep 1
    find('.data-form .field:nth-child(2) input').set('test1')
    sleep 1
    find('.data-form .field:nth-child(3) input').set('123456')
    sleep 1
    find('.ui.dropdown.selection').click
    sleep 1
    find('.ui.dropdown.selection .item:nth-child(2)').click
    sleep 1
    click_link '确定保存'
    sleep 1

    headless.video.stop_and_save 'headless.mp4'
    headless.take_screenshot 'headless.png'

    # headless.destroy
  end

  # it 'baidu' do
  #   headless = Headless.new video: { frame_rate: 12, codec: 'libx264', log_file_path: '/web/ben7th/temp/headless.log'}
  #   headless.start

  #   p headless
  #   headless.video.start_capture

  #   Selenium::WebDriver::PhantomJS.path = '/web/ben7th/temp/phantomjs-2.1.1-linux-x86_64/bin/phantomjs'
  #   driver = Selenium::WebDriver.for :firefox

  #   driver.navigate.to 'http://baidu.com'
  #   puts driver.title 

  #   headless.video.stop_and_save 'headless.mp4'
  #   headless.take_screenshot 'headless.png'

  #   driver.save_screenshot "screenshot.png"

  #   headless.destroy
  # end

  # it 'add' do
  #   result = page.evaluate_script('4 + 4')
  #   expect(result).to eq(8)
  # end
end