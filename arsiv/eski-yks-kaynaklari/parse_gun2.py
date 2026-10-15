import openpyxl
import sys

sys.stdout.reconfigure(encoding='utf-8')

wb = openpyxl.load_workbook('Marmara_MTOK_v4.xlsx')

ws = wb['📆 Gün Gün Plan']
# Write to a file for easier reading
with open('gun_gun_plan_output.txt', 'w', encoding='utf-8') as f:
    for i in range(1, ws.max_row + 1):
        row_data = []
        for cell in ws[i]:
            val = cell.value
            if val is not None:
                row_data.append(str(val).strip())
            else:
                row_data.append('')
        if any(v for v in row_data):
            f.write(f'Row {i}: {row_data}\n')
print("Done writing gun_gun_plan_output.txt")
