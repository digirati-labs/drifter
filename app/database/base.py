import abc

class Database(object, metaclass=abc.ABCMeta):

    @abc.abstractmethod
    def initialise(self, settings):
        raise NotImplementedError("must define initialise() to use this base class")

