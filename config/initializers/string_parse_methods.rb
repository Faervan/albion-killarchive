# frozen_string_literal: true

class String
  def parse_item
    match = match(/(?:T(?<tier>[1-8])_)?(?<double>2H_)?(?<item_type>[^@]*)(?:@(?<enchantment>[0-4]))?/)
    {
      path: (match[:tier].to_i.positive? ? "T#{match[:tier]}_" : '') +
        "#{match[:double] || ''}#{match[:item_type]}@#{match[:enchantment] || 0}",
      tier: match[:tier].to_i,
      enchantment: match[:enchantment].to_i
    }
  end

  def parse_item_type
    match = match(/(?:T[1-8]_)?(?<double>2H_)?(?<item_type>[^@]*)(?:@[0-4])?/)
    {
      two_handed: match[:double].present?,
      path: (match[:double] || '') + match[:item_type]
    }
  end

  def parse_item_slot
    case self
    when 'Chest'
      'Armor'
    when 'Feet'
      'Shoes'
    else
      self
    end
  end
end
