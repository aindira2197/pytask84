class DataSynchronizer:
    def __init__(self):
        self.data = {}

    def add_data(self, key, value):
        self.data[key] = value

    def remove_data(self, key):
        if key in self.data:
            del self.data[key]

    def update_data(self, key, value):
        if key in self.data:
            self.data[key] = value

    def get_data(self, key):
        return self.data.get(key)

    def sync_data(self, other_synchronizer):
        for key, value in other_synchronizer.data.items():
            self.add_data(key, value)

class DataManager:
    def __init__(self):
        self.synchronizers = []

    def create_synchronizer(self):
        synchronizer = DataSynchronizer()
        self.synchronizers.append(synchronizer)
        return synchronizer

    def remove_synchronizer(self, synchronizer):
        if synchronizer in self.synchronizers:
            self.synchronizers.remove(synchronizer)

    def sync_all(self):
        for i in range(len(self.synchronizers)):
            for j in range(i + 1, len(self.synchronizers)):
                self.synchronizers[i].sync_data(self.synchronizers[j])
                self.synchronizers[j].sync_data(self.synchronizers[i])

def main():
    data_manager = DataManager()
    synchronizer1 = data_manager.create_synchronizer()
    synchronizer2 = data_manager.create_synchronizer()
    synchronizer3 = data_manager.create_synchronizer()

    synchronizer1.add_data('key1', 'value1')
    synchronizer2.add_data('key2', 'value2')
    synchronizer3.add_data('key3', 'value3')

    data_manager.sync_all()

    print(synchronizer1.get_data('key1'))
    print(synchronizer1.get_data('key2'))
    print(synchronizer1.get_data('key3'))

    print(synchronizer2.get_data('key1'))
    print(synchronizer2.get_data('key2'))
    print(synchronizer2.get_data('key3'))

    print(synchronizer3.get_data('key1'))
    print(synchronizer3.get_data('key2'))
    print(synchronizer3.get_data('key3'))

if __name__ == '__main__':
    main()