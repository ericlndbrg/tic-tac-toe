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
		[
			'    1   2   3',
			'  +-----------+',
			"A | #{self.cell_hash['a1']} | #{self.cell_hash['a2']} | #{self.cell_hash['a3']} |",
			'  -------------',
			"B | #{self.cell_hash['b1']} | #{self.cell_hash['b2']} | #{self.cell_hash['b3']} |",
			'  -------------',
			"C | #{self.cell_hash['c1']} | #{self.cell_hash['c2']} | #{self.cell_hash['c3']} |",
			'  +-----------+'
		].each do |grid_row|
			Printer.print_output(grid_row)
		end
	end

	def update(selection, char)
		self.cell_hash[selection] = char
	end

	private

	attr_writer :cell_hash
end
