class Hash
  def self.auto(&block)
    Hash.new {|h,k| h[k] = yield}
  end
end