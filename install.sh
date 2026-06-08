#!/bin/bash

mkdir -p ./logs
set -euo pipefail

source scripts/config.sh > logs/config.log 2>&1

options=("Установить Arch Linux" "Редактировать конфиг" "Базовая настройка" "Установка прикладных программ" "Установка опциональных программ" "Wine" "Оптимизация" "Удаление настроек и прикладных программ" "Выход")
clear
echo "=== ГЛАВНОЕ МЕНЮ УСТАНОВКИ ==="
select opt in "${options[@]}"; do
    case $opt in
        "Установить Arch Linux")
            #echo "Запуск arch.txt..."
            source scripts/arch.sh > logs/arch.log 2>&1
            ;;
        "Редактировать конфиг")
            echo "Запуск config.sh..."
            source scripts/config.sh > logs/config.log 2>&1
            ;;
        "Базовая настройка")
            echo "Запуск base.sh..."
            source scripts/base.sh > logs/bash.log 2>&1

            ;;
        "Установка прикладных программ")
            echo "Запуск packages.sh..."
            source scripts/packages.sh > logs/packages.log 2>&1

            ;;
        "Установка опциональных программ")
            echo "Запуск packages_opt.sh..."
            source scripts/packages_opt.sh > logs/packages_opt.log 2>&1

            ;;
        "Wine")
            echo "Запуск wine.sh..."
            source scripts/wine.sh > logs/wine.log 2>&1

            ;;
        "Оптимизация")
            echo "Запуск optimization.sh..."
            source scripts/optimization.sh > logs/optimization.log 2>&1

            ;;
        "Удаление настроек и прикладных программ")
            echo "Запуск скрипта удаления..."
            source uninstall.sh > logs/uninstall.log 2>&1

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
