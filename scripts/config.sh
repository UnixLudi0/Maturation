#!/bin/bash
export HG_ROOT=$(realpath .)

config_menu() {
    PS3="Выберите: "
    options=("Язык" "Процессор" "Видеокарта" "Диск" "Показать настройки" "Назад")
    clear
    echo "=== ГЛАВНОЕ МЕНЮ КОНФИГА ==="
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                choose_language
                ;;
            2)
                choose_cpu
                ;;
            3)
                choose_gpu
                ;;
            4)
                choose_disk
                ;;
            5)
                show_config
                ;;
            6)
                return 0
                ;;
            *)
                echo "Неверный выбор! Выберите от 1 до 6"
                ;;
        esac
    done
}

choose_language() {
    PS3="Выберите: "
    options=("Русский" "Английский" "Назад")
    clear
    echo "=== ВЫБОР ЯЗЫКА ==="
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                export HG_LANG=ru
                echo "Выбран русский язык"
                return 0
                ;;
            2)
                export HG_LANG=en
                echo "Выбран английский язык"
                return 0
                ;;
            3)
                return 0
                ;;
            *)
                echo "Неверный выбор!"
                ;;
        esac
    done
}

choose_cpu() {
    PS3="Выберите: "
    options=("Intel" "AMD" "Назад")
    clear
    echo "=== ВЫБОР ПРОЦЕССОРА ==="
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                export HG_CPU=intel-cpu
                echo "Выбран процессор Intel"
                return 0
                ;;
            2)
                export HG_CPU=amd-cpu
                echo "Выбран процессор AMD"
                return 0
                ;;
            3)
                return 0
                ;;
            *)
                echo "Неверный выбор!"
                ;;
        esac
    done
}

choose_gpu() {
    PS3="Выберите: "
    options=("Intel" "AMD" "Nvidia" "Назад")
    clear
    echo "=== ВЫБОР ВИДЕОКАРТЫ ==="
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                export HG_GPU=intel-gpu
                echo "Выбрана видеокарта Intel"
                return 0
                ;;
            2)
                export HG_GPU=amd-gpu
                echo "Выбрана видеокарта AMD"
                return 0
                ;;
            3)
                export HG_GPU=nvidia-gpu
                echo "Выбрана видеокарта Nvidia"
                return 0
                ;;
            4)
                return 0
                ;;
            *)
                echo "Неверный выбор!"
                ;;
        esac
    done
}

choose_disk() {
    PS3="Выберите: "
    options=("SSD" "HDD" "Назад")
    clear
    echo "=== УКАЖИТЕ ТИП ДИСКА ==="
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                export HG_DISK=ssd
                echo "Выбран SDD"
                return 0
                ;;
            2)
                export HG_DISK=hdd
                echo "Выбран HDD"
                return 0
                ;;
            3)
                return 0
                ;;
            *)
                echo "Неверный выбор!"
                ;;
        esac
    done
}


show_config() {
    PS3="Выберите: "
    options=("Назад")
    clear
    echo "=== ТЕКУЩИЕ НАСТРОЙКИ ==="
    echo "Корневая директория: $HG_ROOT"
    echo "Язык: ${HG_LANG:-не выбрано}"
    echo "Процессор: ${HG_CPU:-не выбрано}" 
    echo "Видеокарта: ${HG_GPU:-не выбрано}"
    echo "Тип диска: ${HG_DISK:-не выбрано}"
    echo "=========================="
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                return 0
                ;;
            *)
                echo "Неверный выбор!"
                ;;
        esac
    done
}

config_menu
