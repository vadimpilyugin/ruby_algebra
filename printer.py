import logging

logging.basicConfig(format='%(asctime)-15s %(funcName)s from %(filename)s: %(message)s')
printer = logging.getLogger("printer")
printer.setLevel(logging.WARNING)