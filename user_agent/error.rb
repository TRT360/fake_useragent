# frozen_string_literal: true

public

class UserAgentError < RuntimeError
  def initialize(msg: nil)
    super
  end
end

class InvalidOption < RuntimeError
  def initialize(msg: nil)
    super
  end
end
