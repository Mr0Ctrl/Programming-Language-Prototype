#!/bin/bash
# eski dosyaları sill
rm mpl.tab.c
rm mpl.tab.h
rm lex.yy.c
rm mpl


# Lex dosyasını çalıştır
lex mpl.l

# Bison dosyasını çalıştır
bison -d mpl.y

# GCC ile derleme işlemi yap
gcc lex.yy.c mpl.tab.c -o mpl

# Derleme tamamlandıysa mesaj ver
if [ $? -eq 0 ]; then
    echo "Derleme başarılı! Çıktı: ./mpl"
else
    echo "Derleme başarısız!"
fi
