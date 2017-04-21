class Lease4 < Sequel::Model(:lease4)

  def hwaddr
    @values[:hwaddr].unpack('H*').first.scan(/../).join(':')
  end

  def client_id
    (@values[:client_id] || '').unpack('H*').first.scan(/../).join(':')
  end

  def state
    @values[:name]
  end

  def address
    ip = @values[:address]
    bytes = []
    bytes[0] = ip & 0xFF;
    bytes[1] = (ip >> 8) & 0xFF;
    bytes[2] = (ip >> 16) & 0xFF;
    bytes[3] = (ip >> 24) & 0xFF;
    bytes.reverse.join('.')
  end

  def has_problem?
    (self.a_record != self.address) || dhcid_record == ''
  end

  def needed_ddns_updates?
    res = false
    if dhcid_record == '' && a_record
      puts "update delete #{self.hostname} a"
      res = true
    end
    if dhcid_record != '' && a_record == ''
      puts "update delete #{self.hostname} dhcid"
      res = true
    end
    res
  end

  def expire_lease!
    @values[:expire] = Time.parse('1970-01-01 14:23:42 +0000')
    self.save
  end

  def a_record_equal_lease?
    a_record == self.address
  end

  def a_record
    return @a_record if @a_record

    begin
      nameserver = ENV['NAMESERVER']
      if nameserver
        resolver = Resolv::DNS.new(:nameserver => [nameserver], :search => ['.'], :ndots => 1)
      else
        resolver = Resolv::DNS.new
      end
      @a_record = resolver.getaddress(self.hostname).to_s
      return @a_record
    rescue Resolv::ResolvError
      return ''
    end
  end

  def dhcid_record
    return @dhcid_record if @dhcid_record

    # https://docs.ruby-lang.org/en/2.3.0/Resolv/DNS.html#method-i-getresource does not have a dedicated DHCID type...
    return '' unless self.hostname.length >= 1
    nameserver = ENV['NAMESERVER'] ? "@#{ENV['NAMESERVER']}" : ''
    @dhcid_record = (`dig #{nameserver} #{self.hostname} +short dhcid `)
  end

end