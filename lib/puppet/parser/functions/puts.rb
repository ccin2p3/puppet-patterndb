# frozen_string_literal: true

module Puppet::Parser::Functions
  newfunction(:puts) do |args|
    puts args
  end
end
