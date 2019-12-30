
class student:
	"""docstring for student"""
	def __init__(self, name,sex):
		self.name = name
		self.sex = sex
class Bin(student):
	"""docstring for Bin"""
	def print_me(self):
		print('Bins Profile'+ name+sex)
		

bin=Bin('pbsb','male')
print(bin.print_me())
