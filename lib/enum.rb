#from https://gist.github.com/alexch/a7be54e1b085718473ff
class Enum

  class Item
    attr_reader :value, :label

    def initialize value, label
      @value, @label = value, label
    end

    def ==(other)
      other.is_a?(Enum::Item) and
        other.value == value and
        other.label == label
    end
  end

  include Enumerable

  attr_reader :items

  def initialize item_tuples
    @items = item_tuples.map do |item_tuple|
      Item.new(item_tuple[0], item_tuple[1])
    end
  end

  def each &block
    @items.each &block
  end
end