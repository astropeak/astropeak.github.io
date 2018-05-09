class Descriptor:
  def __init__(self):
    self.data = None
  def __get__(self, obj, type):
    print('get called')
    return self.data
  def __set__(self, obj, value):
    print('set called')
    self.data = value
  def __delete__(self, obj):
    print('delete called')
    del self.data

class Foo:
  attr = Descriptor()

foo = Foo()

