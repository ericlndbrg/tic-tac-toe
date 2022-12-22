class Printer
	def self.print_output(msg, add_newline_char: true)
		add_newline_char ? puts(msg) : print(msg)
	end
end
