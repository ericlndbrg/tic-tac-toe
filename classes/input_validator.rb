# frozen_string_literal: true

# this class validates the user-submitted input
class InputValidator
  VALID_USER_INPUT = %w[a1 a2 a3 b1 b2 b3 c1 c2 c3 q].freeze

  def validate_user_input(selection, cell_value)
    raise_invalid_input_exception unless VALID_USER_INPUT.include?(selection)
    return if selection == 'q'

    raise_cell_already_taken_exception unless cell_value == ' '
  end

  private

  def raise_invalid_input_exception
    raise(StandardError, 'invalid input, please try again')
  end

  def raise_cell_already_taken_exception
    raise(StandardError, 'that cell is already taken, please try again')
  end
end
