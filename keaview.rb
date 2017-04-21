require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
autoload :Lease4, './model/lease4'

DHCID_ID_HWADDR = 0
SHA256_DIGEST_TYPE = 1

DEBUG = ENV['DEBUG']
DB = Sequel.connect(ENV['DATABASE_URL'])

def next_expire(n = 10)
  Lease4.order(:expire).take(n).each {|l| puts "#{l.hostname} => #{l.expire}" }
end
def check_all_dns
  Lease4.each {|lease| lease.check_dns!}
end

def fake_dhcid_from_hw_addr(hw_addr, wire_fqdn)
  hw_addr = [hw_addr.gsub(':','')].pack('H*')
  hash_oder_so = [0, DHCID_ID_HWADDR, SHA256_DIGEST_TYPE] + Digest::SHA256.digest(hw_addr+wire_fqdn).unpack('C*')
  Base64.encode64(hash_oder_so.pack('C*'))
end
