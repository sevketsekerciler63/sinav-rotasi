import openpyxl
import sys

sys.stdout.reconfigure(encoding='utf-8')

wb = openpyxl.load_workbook('Marmara_MTOK_v4.xlsx')

print('='*80)
print('SHEET: Konu Sirasi (Full)')
print('='*80)
ws = wb['📚 Konu Sırası']
for i in range(1, ws.max_row + 1):
    row_data = []
    for cell in ws[i]:
        val = cell.value
        if val is not None:
            row_data.append(str(val).strip())
        else:
            row_data.append('')
    if any(v for v in row_data):
        print(f'Row {i}: {row_data}')
