#include <algorithm>
#include <iostream>
#include <random>
#include <vector>

int main() {
    std::vector<int> arr(100);
    std::iota(arr.begin(), arr.end(), 0);

    std::random_device rd;
    std::mt19937 gen(rd());

    std::sort(arr.begin(), arr.end(), [&gen](int, int) {
        return std::uniform_int_distribution<>(0, 1)(gen) == 0;
    });

    std::cout << '[';
    for (size_t i = 0; i < arr.size(); ++i) {
        if (i) std::cout << ", ";
        std::cout << arr[i];
    }
    std::cout << "]\n";

    return 0;
}
