require_relative "item"
require_relative "constants"

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_item()
    @items.each do |item|
      next if item.name == Constants::LEGENDARY

      # modify quality
      if item.name != Constants::AGED_BRIE and item.name != Constants::BACKSTAGE_PASS
        reduce_quality(item)
        if item.name == Constants::CONJURED
          reduce_quality(item)
        end
      else
        increase_quality(item)
        if item.name == Constants::BACKSTAGE_PASS
          if item.sell_in < 11
            increase_quality(item)
          end
          if item.sell_in < 6
            increase_quality(item)
          end
        end
      end

      # reduce sell in
      item.sell_in = item.sell_in - 1

      # additional quality modifiers
      if item.sell_in < 0
        if item.name == Constants::AGED_BRIE
          increase_quality(item)
        else
          if item.name == Constants::BACKSTAGE_PASS
            item.quality = 0
          else
            reduce_quality(item)
          end

          if item.name == Constants::CONJURED
            reduce_quality(item)
          end
        end
      end
    end
  end

  def reduce_quality(item)
    if item.quality > 0
      item.quality -= 1
    end
  end

  def increase_quality(item)
    if item.quality < Constants::MAX_QUALITY
      item.quality += 1
    end
  end
end


