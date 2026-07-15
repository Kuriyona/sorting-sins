#include <algorithm>
#include <iostream>
#include <random>
#include <vector>

int main(int argc, char* argv[]) {
    int n = argc > 1 ? std::stoi(argv[1]) : 100;
    std::vector<int> arr(n);
    std::iota(arr.begin(), arr.end(), 0);

    std::random_device rd;
    std::mt19937 gen(rd());

    std::sort(arr.begin(), arr.end(), [&gen](int, int) {
        return std::uniform_int_distribution<>(0, 1)(gen) == 0;
    });

    auto limit = std::min(arr.size(), size_t(100));
    std::cout << '[';
    for (size_t i = 0; i < limit; ++i) {
        if (i) std::cout << ", ";
        std::cout << arr[i];
    }
    std::cout << "]\n";

    return 0;
}
