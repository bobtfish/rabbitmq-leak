module Puppet::Parser::Functions
  newfunction(:upto_array, :type => :rvalue) do |args|
    0.upto(args[0].to_i).to_a
  end
end

