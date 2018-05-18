from threading import Thread
from time import sleep
import Queue

def T(dir, pattern):
  "This is just a stub that simulate a dir operation"
  sleep(1)
  print('searching pattern %s in dir %s' % (pattern, dir))

dirs = ['a/b/c', 'a/b/d', 'b/c', 'd/f']
pattern = 'hello'

def wrapper():
  while True:
    try:
      dir = taskQueue.get(True, 0.1) #N#
      if dir is None:
        taskQueue.put(dir)
        break

      T(dir, pattern)
    except Queue.Empty:
        continue

taskQueue = Queue.Queue()
threadsPool = [Thread(target=wrapper) for i in range(2)] #N#

for thread in threadsPool: #N#
  thread.start()

for dir in dirs:
  taskQueue.put(dir) #N#

taskQueue.put(None)


for thread in threadsPool:
  thread.join()
print('Main thread end here')


import os
def ensure_dir(file_path):
  directory = os.path.dirname(file_path)
  if not os.path.exists(directory):
    os.makedirs(directory)

