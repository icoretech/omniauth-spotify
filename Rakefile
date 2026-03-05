# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new(:test_unit) do |task|
  task.libs << 'lib'
  task.libs << 'test'
  task.test_files = FileList['test/omniauth_spotify_test.rb']
end

Rake::TestTask.new(:test_rails_integration) do |task|
  task.libs << 'lib'
  task.libs << 'test'
  task.test_files = FileList['test/rails_integration_test.rb']
end

Rake::TestTask.new(:test) do |task|
  task.libs << 'lib'
  task.libs << 'test'
  task.test_files = FileList['test/**/*_test.rb']
end

RuboCop::RakeTask.new(:lint)

task default: %i[lint test_unit]
