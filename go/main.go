package main

import (
	"fmt"
	"math/rand"
	"os"
	"sort"
	"strconv"
)

func main() {
	n := 100
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	arr := make([]int, n)
	for i := range arr {
		arr[i] = i
	}

	sort.Slice(arr, func(i, j int) bool {
		return rand.Intn(2) == 0
	})

	k := 100
	if k > len(arr) {
		k = len(arr)
	}
	fmt.Println(arr[:k])
}
