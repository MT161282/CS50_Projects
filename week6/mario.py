while True:
    try:
        height = int(input("Height: "))
        if 1 <= height <= 8:
            break
    except:
        pass

# Print pyramid
for i in range(1, height + 1):

    # spaces
    for j in range(height - i):
        print(" ", end="")

    # hashes
    for j in range(i):
        print("#", end="")

    print()
