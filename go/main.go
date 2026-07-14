package main

import (
	"fmt"
	"math/rand"
	"sort"
)

func main() {
	arr := make([]int, 100)
	for i := range arr {
		arr[i] = i
	}

	sort.Slice(arr, func(i, j int) bool {
		return rand.Intn(2) == 0
	})

	fmt.Println(arr)
}
