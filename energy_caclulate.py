def energy_caclulate(kwh):
    steps_price = [1678, 1734, 2014, 2536, 2834, 2927]
    norm = [50, 50, 100, 100, 100]
    total = 0
    for i in range(len(norm)):
        if kwh > norm[i]:
            total += norm[i] * steps_price[i]
            kwh -= norm[i]
        else:
            total += kwh * steps_price[i]
            kwh = 0
            break
    if kwh > 0:
        total += kwh * steps_price[5]
    vat_tax = total * 0.1
    total_money = total + vat_tax
    
    return total_money



kwh =  int(input("kWh: "))
tien_dien = energy_caclulate(kwh)
print(f"Tổng tiền điện phải trả: {tien_dien:.0f} VND")
