source 'https://ruby.taobao.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Access an IRB console on exception pages or by using <%= console %> in views
gem 'web-console', group: :development

##
# 更友好的出错页面
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner', '~> 1.5.1'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'mongoid-rspec', '~> 2.1.0'
end

gem 'mongoid',  '4.0.2'
gem 'haml',     '4.0.7'
gem 'devise',   '4.1.1'
gem 'kaminari', '0.16.3'

gem 'question_bank',   github: 'mindpin/question_bank',
                     ref: '18763e8'

gem 'lily-components', github: 'kc-train/lily-components',
                     ref: 'b8f7672'

source 'https://rails-assets.org'
gem 'rails-assets-semantic'
