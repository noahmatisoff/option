class OptionClass

  def or_nil
  end

  def ==(that)
    case that
      when OptionClass then or_nil == that.or_nil
      else or_nil == that
    end
  end
end

class SomeClass < OptionClass

  def initialize(value)
    @value = value
  end

  def to_a
    [get]
  end

  def get
    @value
  end

  def get_or_else(&blk)
    get
  end

  def foreach(&blk)
    blk.call(get)

    nil
  end

  def or_nil
    get
  end

  def present?
    true
  end

  def empty?
    false
  end

  def map(&blk)
    Option(blk.call(get))
  end

  def flat_map(&blk)
    result = blk.call(get)
    case result
      when OptionClass then return result
      else raise TypeError, "Must be an Option"
    end
  end

  def fold(if_empty, &blk)
    blk.call(get)
  end

  def exists?(&blk)
    !! blk.call(get)
  end

  def filter(&blk)
    exists?(&blk) ? self : None
  end
end

class NoneClass < OptionClass

  def to_a
    []
  end

  def get
    raise IndexError, "None.get"
  end

  def get_or_else(&blk)
    blk.call
  end

  def foreach(&blk)
    nil
  end

  def or_nil
    nil
  end

  def present?
    false
  end

  def empty?
    true
  end

  def map(&blk)
    flat_map(&blk)
  end

  def flat_map(&blk)
    self
  end

  def fold(if_empty, &blk)
    if_empty.call
  end

  def exists?(&blk)
    false
  end

  def filter(&blk)
    self
  end
end

None = NoneClass.new
Some = SomeClass

def Some(value)
  SomeClass.new(value)
end

def Option(value)
  value.nil? ? None : Some(value)
end
