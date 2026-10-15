import openpyxl
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

wb = openpyxl.load_workbook('Marmara_MTOK_v4.xlsx')
print('Sheet names:', wb.sheetnames)

for sheet_name in wb.sheetnames:
    ws = wb[sheet_name]
    print(f'\n=== Sheet: {sheet_name} ===')
    print(f'Max row: {ws.max_row}, Max col: {ws.max_column}')
    print()
    # Print all rows
    for i in range(1, min(ws.max_row + 1, 200)):
        row_data = []
        for cell in ws[i]:
            row_data.append(str(cell.value) if cell.value is not None else '')
        print(f'Row {i}: {row_data}')
