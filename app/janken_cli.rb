# frozen_string_literal: true

require './app/controllers/cli/janken_cli_controller'

def main
  JankenCliController.new.play
end

main if __FILE__ == $PROGRAM_NAME
