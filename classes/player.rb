class Player
	attr_reader :char

	def initialize(char)
		self.char = char
	end

	def get_cell_selection
		Printer.print_output("Enter 'q' to quit")
		Printer.print_output('Enter a selection: ', add_newline_char: false)
		gets.chomp
	end

	private

	attr_writer :char
end

