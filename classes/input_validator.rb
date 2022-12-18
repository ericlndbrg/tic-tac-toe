class InputValidator
	VALID_USER_INPUT = ['a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3', 'q'].freeze

	def validate_user_input(selection, cell_value)
		# check if the input is allowed
		unless VALID_USER_INPUT.include?(selection)
			raise(StandardError, 'invalid input, please try again')
		end

		# break out if selection == 'q'
		return if selection == 'q'

		# check if the selected cell is available
		unless cell_value == ' '
			raise(StandardError, 'that cell is already taken, please try again')
		end
	end
end
