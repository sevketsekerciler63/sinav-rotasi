import openpyxl
import sys

sys.stdout.reconfigure(encoding='utf-8')

wb = openpyxl.load_workbook('Marmara_MTOK_v4.xlsx')
print('=== SHEET NAMES ===')
for idx, name in enumerate(wb.sheetnames):
    ws = wb[name]
    print(f'{idx}: "{name}" (rows: {ws.max_row}, cols: {ws.max_column})')
