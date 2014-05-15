def is_number(x):
    try:
        int(x)
        return True
    except ValueError:
        return False
