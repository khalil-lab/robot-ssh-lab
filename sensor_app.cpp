#include <cerrno>
#include <cmath>
#include <cstdlib>
#include <iostream>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "ERROR: usage: sensor_app <temperature_c>\n";
        return 2;
    }

    errno = 0;
    char* end = nullptr;
    const double temperature = std::strtod(argv[1], &end);

    if (errno == ERANGE ||
        end == argv[1] ||
        *end != '\0' ||
        !std::isfinite(temperature)) {
        std::cerr << "ERROR: invalid temperature\n";
        return 2;
    }

    if (temperature >= 80.0) {
        std::cout << "WARNING: HIGH_TEMPERATURE\n";
    } else {
        std::cout << "STATUS: NORMAL\n";
    }

    return 0;
}
