# Python y hojas de cálculo


## Introducción

En esta página se listan librerías y documentación relacionados con trabajar desde python formatos de archivo de hojas de cálculo, fundamentalmente de de ms excel (xls, xlsx). Pero también otras como ods.

Se excluye, librerías más enfocadas a la generación de "fichas excel" al estilo jasperreports. Esta sección está más enfocada a ETL, data wrangling, ...

También se excluye, el manejo directo de estos ficheros a través de MS Office, LibreOffice, COM Windows Objects (py2win32), ...


## Tutoriales y Referencias

https://www.datacamp.com/community/tutorials/python-excel-tutorial

**openpyxl**

* https://automatetheboringstuff.com/chapter12/
* https://medium.com/aubergine-solutions/working-with-excel-sheets-in-python-using-openpyxl-4f9fd32de87f
* https://code.tutsplus.com/tutorials/how-to-work-with-excel-documents-using-python--cms-25698

**pandas**

* http://www.marcelscharth.com/python/pandas1.html
* https://data-flair.training/blogs/data-wrangling-with-python/
* https://www.tutorialspoint.com/python/python_data_wrangling.htm
* https://www.kdnuggets.com/2017/01/pandas-cheat-sheet.html
* https://towardsdatascience.com/data-wrangling-with-pandas-5b0be151df4e

## Descripción de las Librerías

Hay dos páginas de referencia para información sobre estas librerías:

* http://www.python-excel.org/
* http://www.pythonexcel.com/

Además de las que son listadas en esas páginas hay que resaltar:

* pandas
* https://github.com/pyexcel/pyexcel
* tablib

En iCarto por defecto usamos **pyexcel**. A pesar de ser más lenta que las demás provee la misma API para formatos más variados y funciones de alto nivel útiles.

* En caso de encontrarse algún error o problema la siguiente librería a usar es openpyxl.
* xlrd, xlwt quedarían sólo para cuando se necesitará usar librerías python nativas. 
* XlsxWriter en el caso de que alguna operación de escritura o manipulación no funcionase con pyexcel o openpyxl se podría probar esta y documentar el resultado
* tablib. El posible caso de uso es tener que leer/manipular dbf, json, yaml en formato tabla. Pero probablmente sea mejor opción hacer [una conversión de formatos con otra herramienta](https://stackoverflow.com/questions/41898561/) y luego usar algo conocido como pandas.
* pandas. Es un caso especial. Probablemente el way to go, y la siguiente librería a ser investigada porque en iCarto no le hemos prestado la anteción necesaria.

### OpenPyXL
OpenPyXL es una librería que se utiliza para leer y excribir archivos Excel 2010 (xlsx/xlsm/xltx/xltm).

* https://openpyxl.readthedocs.io/en/stable/
* https://bitbucket.org/openpyxl/openpyxl

Proyecto bien mantenido, con contribuidores y releases periodicas.

```python
import openpyxl
excel_document = openpyxl.load_workbook('sample.xlsx')
excel_document.get_sheet_names()  # [u'Sheet1']
sheet = excel_document.get_sheet_by_name('Sheet1')

cell_a2 = sheet['A2']
c.row  # Retrieve the row number of your element
c.column  # Retrieve the column letter of your element
c.coordinate  # Retrieve the coordinates of the cell
c.value  # Retrieve the value of the cell

print(sheet.cell(row = 5, column = 2).value)

multiple_cells = sheet['A1':'B3']
for row in multiple_cells:
    for cell in row:
        print(cell.value)
        
all_rows = sheet.rows
all_columns = sheet.columns

anotherSheet = wb.active  # Get currently active sheet


from openpyxl.utils import get_column_letter, column_index_from_string
get_column_letter(1)  # Return 'A'
column_index_from_string('A')  # Return '1'

sheet.max_row  # Retrieve the maximum amount of rows 
sheet.max_column  # Retrieve the maximum amount of columns
```


### xlrd

Es para leer ficheros xls/xlsx. Es complementaria a xlwt.

* https://github.com/python-excel/xlrd
* http://xlrd.readthedocs.io/en/latest/

xlrd se basa en un objeto workbook que sería equivalente al libro de excel (el fichero completo), objetos sheet que contendrían cada una de las hojas del libro, y las rows que son cada una de las filas de la hoja entre la primera y la última con datos (si hay filas vacias entra la primera y la última con datos devolverán valores nulos.

Extract data from Excel spreadsheets (.xls and .xlsx, versions 2.0 onwards) on any platform. Pure Python (2.7, 3.4+). Strong support for Excel dates. Unicode-aware.

```python
import xlrd 
wb = xlrd.open_workbook('sample.xls')
sheet = wb.sheet_by_index(0) 
sheet.cell_value(0, 0) 
number_of_rows = sheet.nrows

for i in range(sheet.ncols): 
    print(sheet.cell_value(0, i))
    
for i in range(sheet.nrows): 
    print(sheet.cell_value(i, 0))
    
print(sheet.row_values(1))  # lista con todos los valores de la fila 1

for sheet_name in book.sheet_names(): 
   sheet = book.sheet_by_name(sheet_name) 
   print sheet.row_values(0)[0]
```

### xlwt

Es una librería para escribir o manipular ficheros xls (no xlsx). Es complementaria a xlrd.
The package itself is pure Python with no dependencies on modules or packages outside the standard Python distribution.

* https://github.com/python-excel/xlwt
* https://xlwt.readthedocs.io/en/latest/

```python
from xlwt import Workbook 

wb = Workbook() 
sheet1 = wb.add_sheet('Sheet 1') 
  
sheet1.write(1, 0, 'ISBT DEHRADUN') 
sheet1.write(2, 0, 'SHASTRADHARA') 
sheet1.write(0, 1, 'ISBT DEHRADUN')

style = xlwt.easyxf('font: bold 1, color red;')   # Specifying style 
sheet1.write(0, 2, 'SHASTRADHARA', style) 
  
wb.save('xlwt example.xls') 
```

### XlsxWriter

https://github.com/jmcnamara/XlsxWriter

En caso de que la librería usada en escritura, no soporte bien formatos, imágenes, gráficas, ... se puede probar con esta.

En iCarto no la hemos probado.

### Pandas

The pandas library has a quick and easy way to read excel (pandas.read_excel) just like pandas.read_csv. If it's mostly just data and nothing too complicated it'll work:


```python
import pandas as pd
df = pd.read_excel('excel_file.xlsx')  # pandas DataFrame, which is handy for data munging, etc.
print(df)
print(df.head(5))  # print first 5 rows of the dataframe
df['column1_name'].values.tolist()  # To go to a list:

df.to_excel('test.xlsx', sheet_name='sheet1', index=False)  # Write the dataframe to xlsx



df.shape # Inspect the shape 
df.ndim  # Inspect the number of dimensions
df.dtype  # Inspect the data type


import openpyxl  # Convertirlo en un DataFrame
excel_document = openpyxl.load_workbook('sample.xlsx')
sheet = excel_document.get_sheet_by_name('Sheet1')
df = pd.DataFrame(sheet.values)


print(df)  # to specify headers and indices more code is needed
data = sheet.values  # Put the sheet values in `data`
cols = next(data)[1:]  # Indicate the columns in the sheet values
data = list(data)  # Convert your data to a list
idx = [r[0] for r in data]  # Read in the data at index 0 for the indices
data = (islice(r, 1, None) for r in data) # Slice the data at index 1 
df = pd.DataFrame(data, index=idx, columns=cols) # Make your DataFrame
```

If you have multiple tables and things in each worksheet then you may want to use another library.



### pyexcel

Es un wrapper en torno a distintas librerías como xlrd, openpyxl, ... que proporciona una API de alto nivel unificada para lectura y escritura de distintos formatos de archivo: csv, xls, xlsx, ods, ...

Suele ser más lenta que las librerías subyacentes pero a cambio suele proporcionar algunas meta-utilidades chulas, como volcar las tablas a html o rst, ejemplos de como volcar la hoja a base de datos, ...

* https://github.com/pyexcel/pyexcel
* http://docs.pyexcel.org/en/latest/index.html

```python
import pyexcel

my_array = pyexcel.get_array(file_name="test.xls")


my_dict = pyexcel.get_dict(file_name="test.xls", name_columns_by_row=0)  # Get your data in an ordered dictionary of lists
book_dict = pyexcel.get_book_dict(file_name="test.xls")  # Get your data in a dictionary of 2D arrays
records = pyexcel.get_records(file_name="test.xls")  # Retrieve the records of the file


data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
pyexcel.save_as(array=data, dest_file_name="array_data.xls")  # Save the array to a file

2d_array_dictionary = {'Sheet 1': [
                                   ['ID', 'AGE', 'SCORE']
                                   [1, 22, 5],
                                   [2, 15, 6],
                                   [3, 28, 9]
                                  ],
                       'Sheet 2': [
                                    ['X', 'Y', 'Z'],
                                    [1, 2, 3],
                                    [4, 5, 6]
                                    [7, 8, 9]
                                  ],
                       'Sheet 3': [
                                    ['M', 'N', 'O', 'P'],
                                    [10, 11, 12, 13],
                                    [14, 15, 16, 17]
                                    [18, 19, 20, 21]
                                   ]}

pyexcel.save_book_as(bookdict=2d_array_dictionary, dest_file_name="2d_array_data.xls")  # Save the data to a file
```

### tablib

https://github.com/kennethreitz/tablib

Una librería para trabajar de forma "abstracta" sobre datos tabulares. Datasets can be imported from JSON, YAML, DBF, and CSV; they can be exported to XLSX, XLS, ODS, JSON, YAML, DBF, CSV, TSV, and HTML.

En iCarto no la hemos probado.


