class Player
	attr_reader :char

	def initialize(char)
		self.char = char
	end

	def get_cell_selection
		puts "Enter 'q' to quit"
		print 'Enter a selection: '
		gets.chomp
	end

	private

	attr_writer :char
end

