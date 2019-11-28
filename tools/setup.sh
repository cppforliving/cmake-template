#!/usr/bin/env bash
set -euo pipefail

setup_main() {
    declare package_manager=
    declare build_type=
    declare build_dir=
    declare update=

    declare opt
    for opt in "$@"; do
        case $opt in
        --package_manager=*)
            declare -r package_manager=${opt#*=}
            case $package_manager in
            conan | vcpkg) ;;
            *) echo "unknown 'package_manager' value '$package_manager'" >&2 && exit 2 ;;
            esac
            ;;
        --build_type=*)
            declare -r build_type=${opt#*=}
            case $build_type in
            Debug | Release) ;;
            *) echo "unknown 'build_type' value '$build_type'" >&2 && exit 2 ;;
            esac
            ;;
        --build_dir=*)
            case ${opt#*=} in
            '') echo "'build_dir' unspecified" >&2 && exit 2 ;;
            *) declare -r build_dir=${opt#*=} ;;
            esac
            ;;
        --update)
            declare -r update=-u
            ;;
        *) echo "unknown option '$opt'" >&2 && exit 2 ;;
        esac
    done
    unset opt

    if [[ -z $package_manager ]]; then
        echo "'package_manager' unspecified" >&2 && exit 2
    fi

    if [[ -z $build_type ]]; then
        declare -r build_type=Release
        echo "'build_type' defaults to '$build_type'"
    fi

    if [[ -z $build_dir ]]; then
        declare -r build_dir=./build/$build_type
        echo "'build_dir' defaults to '$build_dir'"
    fi

    mkdir -p "$build_dir"

    case $package_manager in
    conan)
        conan profile new \
            --detect --force \
            "$build_dir"/conan_profile
        declare conan_detected_libcxx
        conan_detected_libcxx=$(
            conan profile get settings.compiler.libcxx "$build_dir"/conan_profile || :
        )
        declare -r conan_detected_libcxx
        if [[ $conan_detected_libcxx == libstdc++ ]]; then
            conan profile update \
                settings.compiler.libcxx=libstdc++11 \
                "$build_dir"/conan_profile
        fi
        conan install . "$update" \
            -if "$build_dir" \
            -s build_type="$build_type" \
            -pr "$build_dir"/conan_profile \
            -b missing
        ;;
    vcpkg)
        ln -sf "$VCPKG_ROOT"/scripts/buildsystems/vcpkg.cmake "$build_dir"/vcpkg.cmake
        [[ -n $update ]] && "$VCPKG_ROOT"/vcpkg update
        "$VCPKG_ROOT"/vcpkg install @vcpkgfile.txt
        ;;
    esac
}

if [[ $0 == "${BASH_SOURCE[0]}" ]]; then
    setup_main "$@"
fi
