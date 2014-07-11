def is_number(x):
    try:
        int(x)
        return True
    except TypeError:
        return False
    except ValueError:
        return False

def safe_int(x):
    try:
        return int(x)
    except TypeError:
        return None
    except ValueError:
        return None

def safe_float(x):
    try:
        return float(x)
    except TypeError:
        return None
    except ValueError:
        return None
