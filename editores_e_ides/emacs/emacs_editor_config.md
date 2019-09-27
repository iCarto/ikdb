# EditorConfig - Emacs

_(Actualizado a Agosto/2017)_

Lo más fácil es instalar el paquete de [EditorConfig para Emacs](https://github.com/editorconfig/editorconfig-emacs) a través de Melpa y [use-package](https://github.com/jwiegley/use-package) añadiendo las siguientes líneas a `~/.emacs`

    (use-package editorconfig
      :ensure t
      :config
      (editorconfig-mode 1))

    (add-hook 'editorconfig-custom-hooks
      (lambda (hash) (setq web-mode-block-padding 0)))

Algunos comportamientos curiosos:

-   Si una linea no cumple el `indent_size` y hacemos intro desde esa línea, re-indenta la linea que no lo cumple y la siguiente
-   El comportamiento anterior tiene que ver con el [electric-indent-mode](http://emacsredux.com/blog/2013/03/29/automatic-electric-indentation/), y [se puede evitar](https://www.emacswiki.org/emacs/AutoIndentation) a cambio de perder cierta magia, como que indente correctamente las `}` al teclearlas.


    (electric-indent-mode 0)
    (define-key global-map (kbd "RET") 'newline-and-indent)

-   Con `insert_final_newline` no hace nada. Si está a true, elimina o añade las líneas necesarias para que siempre haya una única al final del fichero.
-   Con `trim_trailing_whitespace=true` elimina automáticamente los espacios al salvar.
-   La configuración de `indent_style` sobreescribe el [indent-tabs-mode](http://ergoemacs.org/emacs/emacs_tabs_space_indentation_setup.html) de emacs, que es lo esperado.
-   El funcionamiento del `max_line_length` es difícil de entender o no parece hacer nada, pero este comportamiento [tampoco está muy definido](https://stackoverflow.com/questions/723881/how-to-enforce-maximum-line-length-in-emacs) en Emacs hay varios paquetes al respecto..
