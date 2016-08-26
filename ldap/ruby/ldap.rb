#!/usr/bin/env ruby
require 'bundler/setup'
require 'net/ldap'
require 'uri'
require 'highline' # for no-echo password prompt

def main(args)
  ldap_url = URI.parse(ENV.fetch 'AD_LDAP_URL', 'ldap://ldap.turner.com')
  high = HighLine.new
  samaccountname = high.ask 'Enter username to search for: '
  user = high.ask 'Enter username to bind with: '
  user = "Turner\\#{user}" unless user =~ /[\\,]/
  pass = high.ask('Enter bind user password: ') { |q| q.echo = false }
  conn = Net::LDAP.new(encryption: :tls, host: ldap_url.host, port: ldap_url.port)
  conn.auth(user, pass)
  conn.bind
  conn.search(base: 'cn=users,dc=turner,dc=com', 
             filter: "samaccountname=#{samaccountname}",
             attributes: %w(telephoneNumber)).each do |entry|
    print "DN: #{entry.dn}\nPhone: #{entry.telephoneNumber}\n"
  end
end

main(ARGV)
