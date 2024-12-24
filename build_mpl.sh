#!/bin/bash
# eski dosyaları sill
rm mpl.tab.c
rm mpl.tab.h
rm lex.yy.c
rm mpl


# Bison dosyasını çalıştır
bison -d mpl.y
if [ $? -eq 0 ]; then
    echo "yacc done."
fi

# Lex dosyasını çalıştır
lex mpl.l
if [ $? -eq 0 ]; then
    echo "lex done."
fi

# GCC ile derleme işlemi yap
gcc lex.yy.c mpl.tab.c -o mpl 

# Derleme tamamlandıysa mesaj ver
if [ $? -eq 0 ]; then
    echo "Derleme başarılı! Çıktı: ./mpl"
else
    echo "Derleme başarısız!"
fi
