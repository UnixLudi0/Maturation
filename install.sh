#!/bin/bash

source scripts/config.sh

options=("Установить Arch Linux" "Редактировать конфиг" "Базовая настройка" "Установка прикладных программ" "Установка продвинутых программ" "WINE" "Оптимизация" "Удаление Hyprland и прикладных программ" "Выход")
clear
echo "=== ГЛАВНОЕ МЕНЮ УСТАНОВКИ ==="
select opt in "${options[@]}"; do
    case $opt in
        "Установить Arch Linux")
            #echo "Запуск arch.txt..."
            #sudo bash ./arch.txt
            ;;
        "Редактировать конфиг")
            echo "Запуск config.sh..."
            source scripts/config.sh
            ;;
        "Базовая настройка")
            echo "Запуск base.sh..."
            source scripts/base.sh
            ;;
        "Установка прикладных программ")
            echo "Запуск apps.sh..."
            source scripts/apps.sh
            ;;
        "Установка продвинутых программ")
            echo "Запуск apps-extra.sh..."
            source scripts/apps-extra.sh
            ;;
        "WINE")
            echo "Запуск wine.sh..."
            source scripts/wine.sh
            ;;
        "Оптимизация")
            echo "Запуск optimization.sh..."
            source scripts/optimization.sh
            ;;
        "Удаление Hyprland и прикладных программ")
            echo "Запуск скрипта удаления..."
            source uninstall.sh
            ;;
        "Выход")
            echo "=== ФИНАЛЬНЫЕ НАСТРОЙКИ ==="
            echo "Корневая директория: $HG_ROOT"
            echo "Язык: ${HG_LANG:-не выбран}"
            echo "Процессор: ${HG_CPU:-не выбран}" 
            echo "Видеокарта: ${HG_GPU:-не выбран}"
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверный выбор!"
            ;;
    esac
done
