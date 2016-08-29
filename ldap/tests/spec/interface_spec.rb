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
      if aruba.environment.include? 'BUNDLE_GEMFILE' then
        aruba.environment['PATH'] = aruba.environment['BUNDLE_ORIG_PATH']
        %w(BUNDLE_BIN_PATH BUNDLE_GEMFILE BUNDLE_ORIG_PATH GEM_HOME RBENV_DIR
         RBENV_HOOK_PATH RUBYLIB RUBYOPT).each do |key|
            aruba.environment.delete key
        end
      end
    end

    it 'should display the usage message wwhen run without an argument' do
      expect do 
         run_simple script
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      expect(last_command_started.stderr).to eq "Usage: #{script} username\n"
    end
  end
end
