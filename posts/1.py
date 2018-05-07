class Foo:
  attr1 = 'value1'
  def __init__(self, attr2):
    self.__dict__['attr2'] = attr2

  @property
  def attr2(self):
    return 'value2, descriptor attr'


foo = Foo('value2, instance attr')
print(foo.attr2)
