HANDS = {
  STONE: 0,
  PAPER: 1,
  SCISSORS: 2
}

PLAYER_1_NAME = 'Alice'
PLAYER_2_NAME = 'Bob'

def valid_hand_str?(hand_str)
  HANDS.values.map(&:to_s).include?(hand_str)
end

def hand_str_to_hand_symbol(hand_str)
  hand_num = hand_str.to_i
  HANDS.detect { |key, value| value == hand_num }[0]
end

def get_hand(player_name)
  loop do
    hands_puts_str = HANDS.map { |key, value| "#{key}: #{value}" }.join("\n")
    puts hands_puts_str
    print "Please select #{player_name} hand: "

    input = gets.chomp

    if valid_hand_str?(input)
      return hand_str_to_hand_symbol(input)
    else
      puts "Invalid input: #{input}\n\n"
    end
  end
end

def puts_player_hand(player_name, hand)
  puts "#{player_name} selected #{hand}"
end

player_1_hand = get_hand(PLAYER_1_NAME)
player_2_hand = get_hand(PLAYER_2_NAME)

puts_player_hand(PLAYER_1_NAME, player_1_hand)
puts_player_hand(PLAYER_2_NAME, player_2_hand)

player_1_result =
  case player_1_hand
  when :STONE
    case player_2_hand
    when :STONE
      :DRAW
    when :PAPER
      :LOSE
    when :SCISSORS
      :WIN
    else
      raise "Invalid player_2_hand. player_2_hand = #{player_2_hand}"
    end
  when :PAPER
    case player_2_hand
    when :STONE
      :WIN
    when :PAPER
      :DRAW
    when :SCISSORS
      :LOSE
    else
      raise "Invalid player_2_hand. player_2_hand = #{player_2_hand}"
    end
  when :SCISSORS
    case player_2_hand
    when :STONE
      :LOSE
    when :PAPER
      :WIN
    when :SCISSORS
      :DRAW
    else
      raise "Invalid player_2_hand. player_2_hand = #{player_2_hand}"
    end
  else
    raise "Invalid player_1_hand. player_1_hand = #{player_1_hand}"
  end

case player_1_result
when :WIN
  puts "#{PLAYER_1_NAME} win !!!"
when :LOSE
  puts "#{PLAYER_2_NAME} win !!!"
when :LOSE
  puts 'DRAW !!!'
when :DRAW
else
  raise "Invaild player_1_result. player_1_result = #{player_1_result}"
end
