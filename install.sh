#!/bin/bash

mkdir -p ./logs
set -euo pipefail

source scripts/config.sh logs/config.log 2>&1

options=("Установить Arch Linux" "Редактировать конфиг" "Базовая настройка" "Установка прикладных программ" "Установка опциональных программ" "Wine" "Оптимизация" "Удаление настроек и прикладных программ" "Выход")
clear
echo "=== ГЛАВНОЕ МЕНЮ УСТАНОВКИ ==="
select opt in "${options[@]}"; do
    case $opt in
        "Установить Arch Linux")
            #echo "Запуск arch.txt..."
            source scripts/arch.sh 2>&1 | tee -a logs/arch.log
            ;;
        "Редактировать конфиг")
            echo "Запуск config.sh..."
            source scripts/config.sh 2>&1 | tee -a logs/config.log
            ;;
        "Базовая настройка")
            echo "Запуск base.sh..."
            source scripts/base.sh 2>&1 | tee -a logs/bash.log

            ;;
        "Установка прикладных программ")
            echo "Запуск packages.sh..."
            source scripts/packages.sh 2>&1 | tee -a logs/packages.log

            ;;
        "Установка опциональных программ")
            echo "Запуск packages_opt.sh..."
            source scripts/packages_opt.sh 2>&1 | tee -a logs/packages_opt.log

            ;;
        "Wine")
            echo "Запуск wine.sh..."
            source scripts/wine.sh 2>&1 | tee -a logs/wine.log

            ;;
        "Оптимизация")
            echo "Запуск optimization.sh..."
            source scripts/optimization.sh 2>&1 | tee -a logs/optimization.log

            ;;
        "Удаление настроек и прикладных программ")
            echo "Запуск скрипта удаления..."
            source uninstall.sh > logs/uninstall.log 2>&1

            ;;
        "Выход")
            exit 0
            ;;
        *)
            echo "Неверный выбор!"
            ;;
    esac
done
