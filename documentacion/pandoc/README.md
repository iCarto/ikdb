1. Instalar tipo de letra _Arial_
2. Para poder trabajar con la fuente que deseamos (en este caso _Arial_), es necesario instalar `xelatex` en el equipo.
   1. Ref: https://pandoc.org/MANUAL.html (buscar "mainfont, sansfont, monofont, mathfont, CJKmainfont")
   2. Ayudas instalación
      1. [Windows](http://www.texts.io/support/0002/)
      2. [Mac](http://www.texts.io/support/0001/)
      3. [Ubuntu](https://zoomadmin.com/HowToInstall/UbuntuPackage/texlive-xetex) Es parte del paquete _textlive-xetex_
3. pandoc --template <ruta_repo_ikdb>/documentacion/pandoc/pandoc-templates/icarto/icarto-latex.tex --defaults <ruta_repo_ikdb>/documentacion/pandoc/pandoc-templates/icarto/icarto-pandoc.yaml guia_comunicacion.md --output guia_comunicacion.pdf