import openpyxl
import sys

sys.stdout.reconfigure(encoding='utf-8')

wb = openpyxl.load_workbook('Marmara_MTOK_v4.xlsx')
print('Sheet names:', wb.sheetnames)
print('Total sheets:', len(wb.sheetnames))

for sheet_name in wb.sheetnames:
    ws = wb[sheet_name]
    print(f'\n{"="*80}')
    print(f'Sheet: {sheet_name}')
    print(f'Max row: {ws.max_row}, Max col: {ws.max_column}')
    print(f'{"="*80}')
    for i in range(1, min(ws.max_row + 1, 300)):
        row_data = []
        for cell in ws[i]:
            val = cell.value
            if val is not None:
                row_data.append(str(val).strip())
            else:
                row_data.append('')
        # Only print non-empty rows
        if any(v for v in row_data):
            print(f'Row {i}: {row_data}')
