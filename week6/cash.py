# Take input
while True:
    try:
        dollars = float(input("Change owed: "))
        if dollars >= 0:
            break
    except:
        pass

# Convert to cents
cents = round(dollars * 100)

coins = 0

# 25 cents
coins += cents // 25
cents %= 25

# 10 cents
coins += cents // 10
cents %= 10

# 5 cents
coins += cents // 5
cents %= 5

# 1 cent
coins += cents

# Output
print(coins)
