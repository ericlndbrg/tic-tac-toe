class Grid
	attr_reader :cell_hash

	def initialize
		self.cell_hash = {
		  'a1' => ' ', 'a2' => ' ', 'a3' => ' ',
		  'b1' => ' ', 'b2' => ' ', 'b3' => ' ',
		  'c1' => ' ', 'c2' => ' ', 'c3' => ' '
		}
	end

	def draw
		puts '    1   2   3'
		puts '  +-----------+'
		puts "A | #{self.cell_hash['a1']} | #{self.cell_hash['a2']} | #{self.cell_hash['a3']} |"
		puts '  -------------'
		puts "B | #{self.cell_hash['b1']} | #{self.cell_hash['b2']} | #{self.cell_hash['b3']} |"
		puts '  -------------'
		puts "C | #{self.cell_hash['c1']} | #{self.cell_hash['c2']} | #{self.cell_hash['c3']} |"
		puts '  +-----------+'
	end

	def update(selection, char)
		self.cell_hash[selection] = char
	end

	private

	attr_writer :cell_hash
end
