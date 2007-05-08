require 'digest/sha1'
module HashHasher
  def self.mk_hash(secret,h)
    s = ''
    h[:secret] = secret
    h.keys.sort_by {|k| k.to_s}.each do |k|
      next if k.to_s == 'hash'
      s << h[k].to_s << k.to_s
    end
    
    Digest::SHA1.hexdigest(s).to_s
  end
end