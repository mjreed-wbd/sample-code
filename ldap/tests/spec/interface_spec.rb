require 'spec_helper'

Dir.new('..').select do |entry|
  entry !~ /^\./
end.map do |entry|
  [ entry, File.expand_path(File.join '..', entry) ]
end.select do |language, path|
  File.directory? path
end.map do |language, path|
  [ language, File.expand_path(File.join path, 'getphone') ]
end.select do |language, script|
  File.executable? script
end.each do |language, script|
  describe language.capitalize, type: :aruba do
    before :all do
      unset_bundler_env_vars
    end

    it 'should display the usage message wwhen run without an argument' do
      expect do 
         run_simple script
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      expect(last_command_started.stderr).to eq "Usage: #{script} username\n"
    end
  end
end
