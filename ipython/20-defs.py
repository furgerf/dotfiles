def pickle_load(path):
  with open(path, "rb") as fh:
    return pickle.load(fh)

def pickle_dump(data, path):
  with open(path, "wb") as fh:
    return pickle.dump(data, fh)
